#codigo de recorrido en el manzano cajon del maipo

float[] valores = {
0.7860671903391775,
0.8364861462963084
0.7997717147377209,
0.7737864207290726,
0.7775553273662861,
0.7246893922093773,
0.6458692351740078,
0.5490055033725632,
0.6750997603421102,
0.7908525560069702,
0.8476070620397171
};

int paso = 0;

void setup() {
size(600, 400);
}

void draw() {
background(0);
stroke(255);

// aumenta el paso con el tiempo
if (frameCount % 10 == 0 && paso < valores.length) {
paso++;
}

for (int i = 0; i < paso; i++) {
float valor = valores[i];

float x = map(i, 0, valores.length, 50, width - 50);
float y = map(valor, 0, 1, height - 50, 50);

if (i > 0) {
float prevValor = valores[i - 1];

float prevX = map(i - 1, 0, valores.length, 50, width - 50);
float prevY = map(prevValor, 0, 1, height - 50, 50);

line(prevX, prevY, x, y);
}

fill(255, 100, 200);
ellipse(x, y, 10, 10);
}
//}
