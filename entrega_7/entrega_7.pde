Table table;
int n; // numero de filas en tabla
float[] prices; // arrange para almacenar precios
float[] emissions; // arrange para almacenar emisiones por fila
String[] brands; // arrange para nombres de las marcas

void setup() {
  size(1000, 700);
  table = loadTable("true_cost_fast_fashion.csv", "header");
  n = table.getRowCount(); //para el numero total de filas de la tabla

  // para inicializar los arranges
  prices = new float[n];
  emissions = new float[n];
  brands = new String[n];

  // recorre cada fila y almacena
  for (int i = 0; i < n; i++) {
    prices[i] = table.getFloat(i, "Avg_Item_Price_USD");
    emissions[i] = table.getFloat(i, "Carbon_Emissions_tCO2e");
    brands[i] = table.getString(i, "Brand");
  }

  // Alineacion
  textAlign(LEFT);
  ellipseMode(CENTER);
}

void draw() {
  background(255);
  // titulo general
  fill(0, 0, 139);
  textSize(20);
  text("Precio promedio vs Emisiones de CO₂ por articulos de marca", 40, 40);



  // ejes x y Y
  textSize(14);
  text("Precio promedio (USD)", width/2 - 60, height - 40);
  pushMatrix();
  translate(30, height/2 + 60);
  rotate(-HALF_PI);
  text("Emisiones CO₂ (tCO₂e)", 0, 0);
  popMatrix();

  // Dibuja los puntos y encuentra los maximos
  float maxPrice = max(prices);
  float maxEmission = max(emissions);

  // dibujar los puntos
  for (int i = 0; i < n; i++) {
    float x = map(prices[i], 0, maxPrice, 80, width - 50);
    float y = map(emissions[i], 0, maxEmission, height - 80, 60);

    // Condición para los puntos más contaminantes, mayor co2 a 10,000
    boolean esContaminante = emissions[i] > 10000;

    // Color y tamaño según nivel de emisiones, si es mas o menos que el valor.
    if (esContaminante) {
      
      fill(90, 90, 90, 180); // gris 
    } else {
      fill(100, 150, 255, 180); // azul 
    }
    noStroke();
    float tamaño = 12;
    ellipse(x, y, tamaño, tamaño);



    // Interacción: muestra el nombre de la marca si el mouse está cerca de ese punto.
    if (dist(mouseX, mouseY, x, y) < 8) {
      fill(0);
      textSize(12);
      text(brands[i], x + 10, y); // nombre de la marca al lado del punto
    }
  }
}
