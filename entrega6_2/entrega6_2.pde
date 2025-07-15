
// variables y estados
int estado = 0;
boolean capturando = false;
boolean barracudaActiva = false;
boolean barracudaLlegó = false;
boolean huevosAtacados = false;

// objetos principales
Pez nemo, marlin, dory, mama;
Barracuda barracuda;
ArrayList<Huevo> huevos;

void setup() {
  size(800, 600);

  // empezr con peces
  nemo = new Pez(color(255, 150, 0), 100, 300, "Nemo");
  marlin = new Pez(color(255, 100, 0), 100, 400, "Marlin");
  dory = new Pez(color(0, 100, 255), 100, 500, "Dory");
  mama = new Pez(color(255, 200, 200), 200, 300, "Mamá");

  // empezar barracuda
  barracuda = new Barracuda(900, 250);

  // empezar huevos
  huevos = new ArrayList<Huevo>();
  for (int i = 0; i < 5; i++) {
    huevos.add(new Huevo(180 + i * 25, 350));
  }
}

void draw() {
  background(200, 240, 255);

  // escena 0, inicio
  if (estado == 0) {
    textSize(12);
    fill(204, 102, 0);
    text("Inicio: Marlin se encontraba con su familia un dia normal en las anemonas...", 230, 50);
    marlin.mostrar();
    nemo.mostrar();
    if (!huevosAtacados) {
      mama.mostrar();
      for (Huevo h : huevos) h.mostrar();
    }
    text("Presiona 'b' para que llegue la barracuda", 230, 100);

    // escena 1, ataque de la barracuda
  } else if (estado == 1) {
    fill(204, 102, 0);
    text("¡Hasta que los ataco la barracuda!", 210, 50);
    marlin.mostrar();
    nemo.mostrar();
    if (!huevosAtacados) {
      mama.mostrar();
      for (Huevo h : huevos) h.mostrar();
    }

    // detectar barracuda
    if (!barracudaLlegó) {
      barracuda.moverHacia(marlin.x, marlin.y);
      if (dist(barracuda.x, barracuda.y, marlin.x, marlin.y) < 100) {
        barracudaLlegó = true;
        huevosAtacados = true;
      }
    }
    barracuda.mostrar();

    if (barracudaLlegó) {
      fill(255, 140, 0);
      text("Presiona la flecha DERECHA para continuar", 210, 100);
    }

    // escena 2: captura de nemo
  } else if (estado == 2) {
    fill(204, 102, 0);
    text("en el despiste de nemo, fue capturado por unos buzos..", 250, 50);
    if (capturando) {
      nemo.y -= 2;
      if (nemo.y < 100) {
        estado = 3;
        capturando = false;
        marlin.x = 100;
        dory.x = 100;
      }
    } else {
      nemo.mover();
    }
    nemo.mostrar();
    fill(255, 140, 0);
    text("Presiona flecha ARRIBA para capturarlo", 250, 100);

    // escena 3: marlin y dory buscan a nemo
  } else if (estado == 3) {
    fill(204, 102, 0);
    text("Marlin y Dory emprenden la expedición para encontrarlo ", 40, 50);
    text(" Así hayan obstáculos en el camino...", 40, 30);
    marlin.mover();
    dory.mover();
    marlin.mostrar();
    dory.mostrar();
    fill(255, 140, 0);
    text("Usa flechas ↑ ↓ para moverlos", 100, 100);
    text("Presiona 'n' para el reencuentro con nemo", 100, 130);

    // Corales como obstaculos fijos
    fill(200, 100, 150);
    noStroke();
    rect(150, 500, 30, 200);
    rect(400, 0, 30, 400);
    rect(650, 450, 30, 210);

    // escena 4, reencuentro feliz
  } else if (estado == 4) {
    fill(204, 102, 0);
    text("¡Apareció! Nemo, Marlin y Dory juntos porfin", 250, 50);
    nemo.mostrar();
    marlin.mostrar();
    dory.mostrar();
    fill(255, 140, 0);
    text("manten presionado ESPACIO para que bailen de la felicidad", 250, 100);
  }
}

void keyPressed() {

  // avanza el ataque
  if (estado == 0 && key == 'b') {
    estado = 1;
    barracudaActiva = true;
    barracudaLlegó = false;

    // captura si llego la barracuda
  } else if (estado == 1 && keyCode == RIGHT && barracudaLlegó) {
    estado = 2;

    // inicia captura de nemo
  } else if (estado == 2 && keyCode == UP) {
    capturando = true;

    // pasar al reencuentro
  } else if (estado == 3 && key == 'n') {
    estado = 4;

    // baile
  } else if (estado == 4 && key == ' ') {
    nemo.bailar();
    marlin.bailar();
    dory.bailar();
  }

  // movimiento de marlin y dory
  if (estado == 3) {
    if (keyCode == UP) {
      marlin.y -= 10;
      dory.y -= 10;
    } else if (keyCode == DOWN) {
      marlin.y += 10;
      dory.y += 10;
    }
  }
}

void mousePressed() {
  println("Click en el mar");
}

// Clases

// clase pez
class Pez {
  color c;
  float x, y;
  String nombre;

  Pez(color tempC, float tempX, float tempY, String tempNombre) {
    c = tempC;
    x = tempX;
    y = tempY;
    nombre = tempNombre;
  }

  // cuerpo, aletas, ojo y nombre
  void mostrar() {
    pushMatrix();
    translate(x, y);

    // Cuerpo
    fill(c);
    noStroke();
    ellipse(0, 0, 60, 30);

    // Cola
    fill(c);
    triangle(-30, 0, -45, -10, -45, 10);

    // Aleta arriba
    fill(c - 40); // más oscuro
    triangle(-10, -15, 0, -30, 10, -15);

    // Aleta inferior
    triangle(-10, 15, 0, 30, 10, 15);

    // Ojo
    fill(255);
    ellipse(20, -5, 8, 8);
    fill(0);
    ellipse(20, -5, 4, 4);

    // Nombre
    popMatrix();
    fill(0);
    textSize(12);
    text(nombre, x - 20, y - 30);
  }

  // movimiento a la derecha
  void mover() {
    x += 2;
    if (x > width) {
      x = -50;
    }
  }

  // movimiento random para el baile
  void bailar() {
    x += random(-5, 5);
    y += random(-5, 5);
  }
}

// clase huevo
class Huevo {
  float x, y;

  Huevo(float tempX, float tempY) {
    x = tempX;
    y = tempY;
  }

  void mostrar() {
    fill(255, 180, 100);
    ellipse(x, y, 15, 15);
  }
}

// clase barracuda
class Barracuda {
  float x, y;

  Barracuda(float tempX, float tempY) {
    x = tempX;
    y = tempY;
  }

  void mostrar() {
    pushMatrix();
    translate(x, y);
    scale(-1, 1); // Invertir horizontalmente

    // Cuerpo
    fill(100);
    noStroke();
    ellipse(0, 0, 150, 40);

    // Cola
    fill(100);
    triangle(-65, 0, -95, -15, -95, 15);

    // Aleta arriba
    fill(80);
    triangle(-15, -15, -5, -35, 5, -15);

    // Aleta inferior
    triangle(-15, 15, -5, 35, 5, 15);

    // Ojo rojo
    fill(255, 150, 150);
    ellipse(55, -10, 12, 12);
    fill(0);
    ellipse(55, -10, 6, 6);

    // Boca
    stroke(0);
    strokeWeight(2);
    line(40, 10, 70, 10);

    // Colmillos
    stroke(255);
    strokeWeight(1.5);
    line(43, 10, 43, 5);
    line(48, 10, 48, 5);
    line(53, 10, 53, 5);
    line(58, 10, 58, 5);

    popMatrix();
  }

  // movimiento hacia un objeto
  void moverHacia(float objetivoX, float objetivoY) {
    if (x > objetivoX) x -= 4;
    if (y < objetivoY) y += 1.5;
    else if (y > objetivoY) y -= 1.5;
  }
}
