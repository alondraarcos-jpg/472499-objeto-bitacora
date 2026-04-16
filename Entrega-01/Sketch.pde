Table tabla;
int paso = 0;
float minLat, maxLat, minLon, maxLon;

void setup() {
size(800, 800); // Ventana cuadrada para que el mapa no se deforme tanto

// Carga el archivo desde la carpeta /data
tabla = loadTable("Location_Processing_Ready.csv", "header");

if (tabla == null) {
exit();
} else {
println("Éxito: " + tabla.getRowCount() + " puntos cargados.");
calcularLimites();
}
frameRate(60);
}

void draw() {
background(10, 15, 20); // Color oscuro tipo mapa nocturno

// Título e información
fill(255);
textSize(18);
text("Recorrido: El Manzano - Cajón del Maipo", 30, 40);

fill(180, 50, 255);
text("● Puntos con error de GPS", 30, 70);

// Animación del recorrido
if (paso < tabla.getRowCount()) {
paso += 3; // Puedes subir este número para que sea más rápido
}

translate(0, 0); // Reset de coordenadas

for (int i = 0; i < paso; i++) {
TableRow fila = tabla.getRow(i);

float lat = fila.getFloat("latitude");
float lon = fila.getFloat("longitude");
float accuracy = fila.getFloat("horizontalAccuracy");

// Mapeo dinámico: Ajusta los puntos a los márgenes de la ventana (50px de margen)
float x = map(lon, minLon, maxLon, 50, width - 50);
float y = map(lat, minLat, maxLat, height - 50, 50);

// Dibujar líneas entre puntos para ver el camino
if (i > 0) {
TableRow previa = tabla.getRow(i-1);
float px = map(previa.getFloat("longitude"), minLon, maxLon, 50, width - 50);
float py = map(previa.getFloat("latitude"), minLat, maxLat, height - 50, 50);
stroke(255, 60); // Línea blanca transparente
strokeWeight(1.5);
line(px, py, x, y);
}

// Lógica de color de Sensor Logger para errores
// Si la precisión es mayor a 12 metros, Sensor Logger suele marcar "morado"
if (accuracy > 12) {
fill(180, 50, 255, 200); // Morado semitransparente
noStroke();
ellipse(x, y, 12, 12); // Punto más grande para resaltar el error
} else {
fill(0, 255, 200, 180); // Cian (recorrido limpio)
noStroke();
ellipse(x, y, 6, 6);
}
}
}

// Esta función encuentra las coordenadas más lejanas para centrar el mapa
void calcularLimites() {
minLat = 1000; maxLat = -1000;
minLon = 1000; maxLon = -1000;
for (TableRow fila : tabla.rows()) {
float lat = fila.getFloat("latitude");
float lon = fila.getFloat("longitude");
if (lat < minLat) minLat = lat;
if (lat > maxLat) maxLat = lat;
if (lon < minLon) minLon = lon;
if (lon > maxLon) maxLon = lon;
}
}

