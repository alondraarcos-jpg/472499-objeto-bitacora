# Clase online 

nos enseño una paguina de datos global, un repositorio donde estan muchos datos ambientales que podemos utilizar.

## [Visualizacion de mapa](https://www.google.com/maps/d/u/0/?hl=es)

### [Pagina de datos](https://open-meteo.com/en/docs)

### [Pagina IA](https://claude.ai/onboarding)


## codigo de prueba como tarea de recorrido en el manzano cajon del maipo ##
```processing
Table table;

int index = 1;

float prevX, prevY;

float minLat, maxLat;
float minLon, maxLon;

// configuración grilla
int cols = 10;
int rows = 10;

void setup() {
  size(800, 800, P2D);
  background(10);

  table = loadTable("Location.csv", "header");

  if (table == null) {
    println("Error cargando CSV");
    exit();
  }

  println("Filas: " + table.getRowCount());

  // calcular límites
  minLat = maxLat = table.getFloat(0, "latitude");
  minLon = maxLon = table.getFloat(0, "longitude");

  for (TableRow row : table.rows()) {
    float lat = row.getFloat("latitude");
    float lon = row.getFloat("longitude");

    if (lat < minLat) minLat = lat;
    if (lat > maxLat) maxLat = lat;
    if (lon < minLon) minLon = lon;
    if (lon > maxLon) maxLon = lon;
  }

  // dibujar fondo + grilla UNA VEZ
  drawGrid(cols, rows);
  drawLabels(cols, rows);

  // primer punto
  float lat0 = table.getFloat(0, "latitude");
  float lon0 = table.getFloat(0, "longitude");

  prevX = map(lon0, minLon, maxLon, 50, width - 50);
  prevY = map(lat0, minLat, maxLat, height - 50, 50);
}

void draw() {
  if (index < table.getRowCount()) {

    float lat = table.getFloat(index, "latitude");
    float lon = table.getFloat(index, "longitude");
    float speed = table.getFloat(index, "speed");

    if (Float.isNaN(lat) || Float.isNaN(lon)) {
      index++;
      return;
    }

    float x = map(lon, minLon, maxLon, 50, width - 50);
    float y = map(lat, minLat, maxLat, height - 50, 50);

    stroke(getColorForSpeed(speed));
    strokeWeight(3);
    line(prevX, prevY, x, y);

    prevX = x;
    prevY = y;

    index++;
  }
}


color getColorForSpeed(float v) {
  float norm = map(v, 0, 1.5, 0, 1);
  norm = constrain(norm, 0, 1);

  if (norm < 0.5) {
    return lerpColor(color(150, 0, 255), color(0, 255, 100), norm * 2);
  } else {
    return lerpColor(color(0, 255, 100), color(255, 255, 0), (norm - 0.5) * 2);
  }
}

void drawGrid(int cols, int rows) {
  stroke(40);
  strokeWeight(1);

  float cellW = width / float(cols);
  float cellH = height / float(rows);

  for (int i = 0; i <= cols; i++) {
    float x = i * cellW;
    line(x, 0, x, height);
  }

  for (int j = 0; j <= rows; j++) {
    float y = j * cellH;
    line(0, y, width, y);
  }
}

void drawLabels(int cols, int rows) {
  fill(180);
  textSize(10);

  float cellW = width / float(cols);
  float cellH = height / float(rows);

  // longitudes abajo
  for (int i = 0; i <= cols; i++) {
    float x = i * cellW;
    float lon = map(x, 50, width - 50, minLon, maxLon);
    text(nf(lon, 0, 4), x + 2, height - 5);
  }

  // latitudes izquierda
  for (int j = 0; j <= rows; j++) {
    float y = j * cellH;
    float lat = map(y, height - 50, 50, minLat, maxLat);
    text(nf(lat, 0, 4), 5, y);
  }
}
```





