//Reloj flotante

// variables que extraen el tiempo, segundos, minutos, horas actuales
int h;
int m;
int s;

// indicamos que tiene 60 columnas y filas para representar los 60 minutos de la hora y 60 segundos del minuto.
int cols = 60;
int rows = 60;

// indicamos que habran 12 diferentes colores para representar el cambio de hora,
// uno por hora de 1-12. para las otras 12 horas luego se usa el mismo tono correspondiente pero bajandole el brillo.
color[] coloresDia = new color[12];

void setup() {
  size(900, 800);
  noStroke();
  // se cambia la imagen 30 veces por segundo para el movimiento fluido
  frameRate(30);
  // en color mode se usa HSB para poder hacer los cambios de colores
  colorMode(HSB, 360, 100, 100);

  // Colores pastel para las 12 horas del día (puedes modificarlos)
  coloresDia[0]  = color(0, 30, 100);  // rojo
  coloresDia[1]  = color(30, 40, 100);  // naranja
  coloresDia[2]  = color(60, 40, 100);  // amarillo
  coloresDia[3]  = color(90, 30, 100);  // verde 1
  coloresDia[4]  = color(120, 30, 100);  // verde 2
  coloresDia[5]  = color(160, 30, 100);  // turquesa
  coloresDia[6]  = color(200, 40, 100);  // azul cielo
  coloresDia[7]  = color(240, 30, 100);  // azul
  coloresDia[8]  = color(280, 30, 100);  // morado
  coloresDia[9]  = color(310, 30, 100);  // rosado
  coloresDia[10] = color(330, 30, 100);  // palo rosa
  coloresDia[11] = color(350, 20, 100);  // coral
}



void draw() {
  // obtiene el tiempo del computador
  h = hour();
  m = minute();
  s = second();

  // convierte los valores de h, m, s en un rango de 0 a 1 (dividiendolo por el valor max de cada uno)
  // es para las animaciones mas fluidas
  float mNorm = m / 59.0;
  float sNorm = s / 59.0;
  float hNorm = h / 23.0;

  // convierte la hora a 12 horas para poder aplicar los 12 colores
  int hora12 = h % 12;
  // verifica que la hora sea mayor o igual a las 6pm y antes de 6am para ser noche
  boolean noche = (h >= 18 || h < 6); // desde 6pm hasta 6am

  // Color base según la hora
  color base = coloresDia[hora12];

  if (noche) {
    // si es de noche... cambia solo el brillo de la base
    float hVal = hue(base);
    float sVal = saturation(base);
    float bVal = brightness(base) * 0.4; // reduce el brillo al 40%
    base = color(hVal, sVal, bVal);
  }
  // cambia de color cada hora
  background(base);


  // cuadricula de puntos que palpitan cada sec
  for (int i = 0; i <= cols; i++) {
    for (int j = 0; j < rows; j++) {

      // margenes de la cuadricula, posicion de los puntos
      float xBase = map(i, 0, cols, 40, width - 40);
      float yBase = map(j, 0, rows, 40, height - 20);

      // con sin y cos se crea un efecto de onda
      // y framecount para palpito de los puntos, * 0.02 hace el movimieto mas lento
      // j= fila (x), i= columna (y), tienen patron ondulado
      // multiplico sNorm * 10 que da un latido cada segundo, sincronizado con el computador.
      // cuando el segundo avanza, el latido se fortalece.

      float offsetX = sin(j / 2.0 + frameCount * 0.02 + sNorm * 10) * ( 5 + 10 * sNorm);
      float offsetY = cos(i / 2.0 + frameCount * 0.02 + sNorm * 10) * (5 + 10 * sNorm);


      // Cambio de color por minuto de blanco a gris claro, de filas menores al numero de minuto que ya paso
      if (j < m) {
        fill(0, 0, 60); // gris claro
      } else {
        fill(0, 0, 100); // blanco
      }
      // el dibujo de cada punto con su animacion
      ellipse(xBase + offsetX, yBase + offsetY, 4, 4);
    }
  }
}


// Relacion con la lectura " The Digital Architecture of Time Management de Judy Wajcman" =
// Mi visual son un patron de puntos que se mueven en una onda por segundo, cambian de color por minuto (Las ileras), y el fondo cambia de color por hora.
// Esto representa ua alternativa a la manera tradicional de medir el tiempo. En vez, muestra un movimiento, y un sentimiento. Como la critica del autor hacia estos metodos rigidos que solo nos llevan a la productividad constante.
// Yo propongo un cambio de atmosferas por cada paso del tiempo, representado por los colores y su cambio de brillo en la noche. Por esto, es una interpretacion sensorial que siente el tiempo como propone wajcman
