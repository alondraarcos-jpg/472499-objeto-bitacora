 Table table; almacenar datos csv, donde están guardadas todas las coordenadas (latitud, longitud y velocidad).

int index = 1; puntero que nos dice que fila del csv estamos leyendo

float prevX, prevY;Variables decimales para guardar la posición (X, Y) del punto anterior. Sin esto, no podríamos tirar una línea entre el "antes" y el "ahora".


float minLat, maxLat; Variables para guardar los valores geográficos más extremos. Sirven para que el mapa no se salga de la pantalla.

float minLon, maxLon; • float minLat, maxLat, minLon, maxLon: Estas cuatro variables forman el "Bounding Box" (Caja de límite). El GPS entrega coordenadas 
globales, pero tu pantalla solo tiene 800 píxeles. Estos valores permiten que el programa calcule el zoom automático para que tu ruta ocupe toda la pantalla, ni más ni menos.




// Definen la resolución de la cuadrícula visual. 
No afectan a los datos, solo a la estética del "mapa base".
int cols = 10;
int rows = 10;

// Es una herramienta de optimización
Es la eficiencia. En lugar de dibujar cada milímetro (que gastaría mucha memoria), la máquina salta puntos para que el dibujo sea fluido sin perder la forma del camino.
int step = 2; // saltar datos (2 = mitad de puntos)
  
// Distancia mínima en píxeles para dibujar; evita manchas si el GPS no se movió.
float minDist = 2.0;    // distancia mínima para dibujar

void setup() { // Crea la ventana y activa la aceleración por tarjeta de video.
  size(800, 800, P2D);
  background(10);// Pinta el fondo de color gris casi negro.

   table = loadTable("Location.csv", "header"); // Carga el archivo ignorando la fila de títulos.

  if (table == null) {
    println("Error cargando CSV");
    exit(); // Si no encuentra el archivo, el programa se cierra.
  }

  // Bucle para escanear todo el CSV y encontrar los límites reales del viaje
  minLat = maxLat = table.getFloat(0, "latitude");
  minLon = maxLon = table.getFloat(0, "longitude");

  for (TableRow row : table.rows()) {
    float lat = row.getFloat("latitude");
    float lon = row.getFloat("longitude");

    if (lat < minLat) minLat = lat; // Actualiza el punto más al sur.
    if (lat > maxLat) maxLat = lat; // Actualiza el punto más al norte.
    if (lon < minLon) minLon = lon; // Actualiza el punto más al oeste.
    if (lon > maxLon) maxLon = lon; // Actualiza el punto más al este.
  }

  drawGrid(cols, rows);   // Dibuja la red de líneas de fondo.
  drawLabels(cols, rows); // Escribe los números de las coordenadas en los bordes.

  // Calcula el punto donde comenzará el dibujo
  float lat0 = table.getFloat(0, "latitude");
  float lon0 = table.getFloat(0, "longitude");

  // Transforma la primera coordenada GPS en píxeles de pantalla
  prevX = map(lon0, minLon, maxLon, 50, width - 50);
  prevY = map(lat0, minLat, maxLat, height - 50, 50);
}

// ==========================================
// 3. FUNCIÓN DRAW (Animación paso a paso)
// ==========================================
void draw() {
  if (index < table.getRowCount()) { // Mientras queden filas por leer en el cuaderno...

    float lat = table.getFloat(index, "latitude");
    float lon = table.getFloat(index, "longitude");
    float speed = table.getFloat(index, "speed");

    // Salta la fila si los datos están dañados (NaN = No es un número)
    if (Float.isNaN(lat) || Float.isNaN(lon)) {
      index += step;
      return;
    }

    // Traduce la posición actual a píxeles usando los límites min/max
    float x = map(lon, minLon, maxLon, 50, width - 50);
    float y = map(lat, minLat, maxLat, height - 50, 50);

    float d = dist(prevX, prevY, x, y); // Calcula cuánto se movió el punto.

    if (d > minDist) { // Si el movimiento es significativo, dibuja.
      stroke(getColorForSpeed(speed)); // Cambia el color del pincel según la velocidad.
      strokeWeight(3);                 // Grosor de la línea del camino.
      line(prevX, prevY, x, y);        // Une el punto anterior con el actual.

      prevX = x; // El punto actual se convierte en el "anterior" para el siguiente ciclo.
      prevY = y;
    }

    index += step; // Mueve el puntero hacia adelante según el valor de 'step'.
  }
}

// ==========================================
// 4. FUNCIONES EXTRA (Lógica visual)
// ==========================================

// Traduce la velocidad en un color (Morado -> Verde -> Amarillo)
color getColorForSpeed(float v) {
  float norm = map(v, 0, 1.5, 0, 1); // Convierte la velocidad a una escala de 0 a 1.
  norm = constrain(norm, 0, 1);      // Asegura que no se pase de esos límites.

  if (norm < 0.5) {
    return lerpColor(color(150, 0, 255), color(0, 255, 100), norm * 2);
  } else {
    return lerpColor(color(0, 255, 100), color(255, 255, 0), (norm - 0.5) * 2);
  }
}

// Dibuja las líneas de la cuadrícula de fondo
void drawGrid(int cols, int rows) {
  stroke(40); // Color gris oscuro para que no distraiga del camino.
  strokeWeight(1);

  float cellW = width / float(cols);
  float cellH = height / float(rows);

  for (int i = 0; i <= cols; i++) {
    float x = i * cellW;
    line(x, 0, x, height); // Líneas verticales.
  }
  for (int j = 0; j <= rows; j++) {
    float y = j * cellH;
    line(0, y, width, y);  // Líneas horizontales.
  }
}

// Escribe los números de las coordenadas GPS en los ejes
void drawLabels(int cols, int rows) {
  fill(180); // Color del texto (gris claro).
  textSize(10);

  float cellW = width / float(cols);
  float cellH = height / float(rows);

  // Escribe las longitudes en la parte inferior
  for (int i = 0; i <= cols; i++) {
    float x = i * cellW;
    float lon = map(x, 50, width - 50, minLon, maxLon);
    text(nf(lon, 0, 4), x + 2, height - 5);
  }

  // Escribe las latitudes en el lateral izquierdo
  for (int j = 0; j <= rows; j++) {
    float y = j * cellH;
    float lat = map(y, height - 50, 50, minLat, maxLat);
    text(nf(lat, 0, 4), 5, y);
  }
}