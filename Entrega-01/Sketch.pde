// Array de datos (velocidad normalizada entre 0 y 1)
// Cada valor representa un momento en el tiempo
float[] valores = {
0.0, 0.0, 0.0, 0.0, 0.0,
0.12, 0.35, 0.48, 0.22, 0.67,
0.89, 0.54, 0.31, 0.15, 0.08,
0.0, 0.0, 0.0, 0.25, 0.60,
0.78, 0.92, 0.70, 0.40, 0.18
};

// Variable que controla cuántos puntos se dibujan (animación)
int paso = 0;

void setup() {
// Tamaño de la ventana
size(600, 400);
}

void draw() {
// Fondo negro para alto contraste
background(0);

// Color de las líneas
stroke(255);

// Hace que la visualización se dibuje de a poco (simula paso del tiempo)
if (frameCount % 10 == 0 && paso < valores.length) {
paso++;
}

// Recorre los datos hasta el punto actual
for (int i = 0; i < paso; i++) {

// Obtiene el valor actual (velocidad)
float valor = valores[i];

// Mapea la posición horizontal (tiempo → eje X)
float x = map(i, 0, valores.length, 50, width - 50);

// Mapea la velocidad a altura (valor → eje Y)
float y = map(valor, 0, 1, height - 50, 50);

// Dibuja línea entre puntos consecutivos (conecta el recorrido)
if (i > 0) {
float prevValor = valores[i - 1];

float prevX = map(i - 1, 0, valores.length, 50, width - 50);
float prevY = map(prevValor, 0, 1, height - 50, 50);

line(prevX, prevY, x, y);
}

// Color del punto (puedes cambiarlo según velocidad si quieres)
fill(255, 100, 200);

// Dibuja un punto en cada dato
ellipse(x, y, 10, 10);
}
}
