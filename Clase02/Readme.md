```processing

const CX=1000,CY=500,IX=200,IY=200;

var velocidad = -0.5;
var diametro = 200;
var x;
var y;


function draw() {
var gris = barra.value();
background(gris);
 
}
function setup() {
createCanvas(480, 120);
  createCanvas(480, 120);
barra = createSlider(0, 255, 100);
barra.position(20, 20);




}
function draw() {
background(204);
randomSeed(0);
for (var i = 35; i < width + 40; i += 400) {
var gris = int(random(0, 102));
var escalar = random(0.25, 1.0);
lechuza(i, 110, gris, escalar);
}
}

function draw() {
var x = desplazamiento + cos(angulo) * escalar;
var y = desplazamiento + sin(angulo) * escalar;
ellipse(x, y, 2, 2);
angulo += velocidad;
escalar += velocidad;
}

function setup() {
	createCanvas(CX, CY);
	img = createImage(IX, IY);
	g={};
	frameRate(660);
}


  var a=9
  state=0;
const max=6;
function draw() {
	img.loadPixels();
	if(g.pain==true){
		a=0;
			for(var i=0;i<img.pixels.length;i++){

	img.pixels[i] = 255;

			}
	img.updatePixels();
		
		state++;
		if(state>max){
			state=0;
		}
	}
	a++;
// 	for(var i=0;i<img.pixels.length;i++){
// if(i%3==0){
// 	 img.pixels[i] = 0.5;
// 	 } else {
// 	img.pixels[i] = 225;
// }
// 			}
// 	img.updatePixels();
	
	 colorMode(HSB);
// for(var i=0;i<width;i++){
// 	for(var j=0;j<height;j++){
// 		img.set(i,j,color(255));
// 	}
// }

	
// a++;
	// console.log(state);
	// bline(x,g.cur,x-1,g.last);
	g.last=0;
	for(var x=0;x<IX;x++){
		r=random();
		switch(state) {
  case 0:
    g.cur=IY*asin((x/(0.5/sin(x*a)))/a)+50;
				img.set(x, g.cur, color((5*a) % 360, 70, 100));
    break;
  case 1:
    g.cur=1000*sin((a/20)*a*floor(a*x^2))/x +50
				img.set(x, g.cur, color((5*a) % 360, 70, 100));
    break;
  case 2:
    g.cur=a/x*(cos(x*g.last)*x^2+g.last^2-1000)
				img.set(x, g.cur, color((5*a) % 360, 70, 100));
    break;
  case 3:
    g.cur=IX*sin(x+(a*0.05))+g.last/a;
				img.set(x, g.cur, color((5*a) % 360, 70, 100));
    break;
  case 4:
   g.cur=IX*sin(x*IY+a*0.01)+a;
				img.set(x, g.cur, color((5*a) % 360, 70, 100));
    break;
  case 5:
   g.cur=(50*sin(a))*sin(x/5+(r*0.5)+a)+50
				img.set(x, g.cur, color((5*a) % 360, 70, 100));
    break;
  case 6:
    g.cur=50*sin(x/10+(r*0.01))+100*r
				bline(x,floor(g.cur),x, floor(g.last));
    break;


}
		
		g.last=g.cur;
}
  img.updatePixels();
  noSmooth();
  image(img, 0, 0, CX, CY);
}



function mouseReleased() {
    g.pain = false;
}

function bline(x0, y0, x1, y1) {
    var dx = Math.abs(x1 - x0);
    var dy = Math.abs(y1 - y0);
    var sx = (x0 < x1) ? 1 : -1;
    var sy = (y0 < y1) ? 1 : -1;
    var err = dx - dy;

    while (true) {
        img.set(x0, y0, color((5*a) % 360, 700, 100));

        if ((x0 == x1) && (y0 == y1)) break;
        var e2 = 2 * err;
        if (e2 > -dy) {
            err -= dy;
            x0 += sx;
        }
        if (e2 < dx) {
            err += dx;
            y0 += sy;
        }
    }

}
