class Jugando {
  // --------- Objetos físicos --------- \\
  Verdura verduraDer, verduraIzq;
  Olla ollaDer, ollaIzq;  // Declaramos Ollas
  FBox piso; // Declaramos piso
  Jugador jugador; // Declaramos jugador
  FMouseJoint cadena; // Declaramos joint para mover al jugador


  // --------- Captura de movimiento --------- \\
  int PUERTO_OSC = 12345; // Puerto de comunicación con el programa de Matias
  Receptor receptor; // Administra la  entrada de los mensajes y asignacion de blobs
  Administrador administrador;
  float currentTargetX;
  float currentTargetY;


  // --------- Recursos --------- \\
  PImage ganasteImg; // Poster ganaste
  PImage perdisteImg; // Poster perdiste
  PImage fondoImg; // Poster fondo
  // --------- imágenes --------- \\

  PImage [] remy;
  int remyEstado;


  // --------- limpieza --------- \\
  boolean colisionConBarra;

  // --------- verdura --------- \\
  boolean verduraEnPantalla;
  String verduraPrevia;


  // --------- Antes del constructor --------- \\
  PImage barraImg;
  PImage colette;
  //-------------------------------\\

  // --------- variables --------- \\
  int puntos;
  boolean hayVerdura;

  Jugando () {

    fondoImg = loadImage ("img/fondoImg.png");
    // --------- imágenes --------- \\
    ganasteImg = loadImage ("img/ganasteImg.png");
    perdisteImg = loadImage ("img/perdisteImg.png");

    remy = new PImage[4];
    for (int i = 0; i < 4; i++) {
      remy[i] = loadImage ("img/remy" + i + ".png");
    }
    remyEstado = 0;

    // --------- limpieza --------- \\
    colisionConBarra = false;

    // --------- verdura --------- \\
    verduraEnPantalla = false;
    verduraPrevia = null;

    // --------- ganar --------- \\
    puntos = 0;

    ollaDer = new Olla (200, 250, "ollaDer"); // Inicializamos olla izquierda
    ollaDer.actualizar ();
    mundo.add (ollaDer); // Agregamos olla izquierda al mundo

    ollaIzq = new Olla (200, 240, "ollaIzq"); // Inicializamos olla izquierda
    ollaIzq.actualizar ();
    mundo.add (ollaIzq); // Agregamos olla izquierda al mundo

    piso = new FBox(width, 240); // Inicializamos el piso transparente
    piso.setPosition (width/2, height - 5); // Asignacion de posición
    piso.setName ("piso"); // Asignacion de nombre
    piso.setNoStroke(); // noStroke
    piso.setNoFill(); // noFill
    piso.setStatic (true); // ¿Es estático?
    piso.setGrabbable (false); // ¿Se puede agarrar?
    mundo.add (piso); // Agregamos piso al mundo
    receptor = new Receptor();
    administrador = new Administrador(mundo);
    jugador = new Jugador (110, 40); // Inicializamos jugador
    jugador.inicializar ();
    mundo.add (jugador); // Agregamos jugador al mundo

    cadena = new FMouseJoint (jugador, width / 2, height - 119/2 - 130); // Inicializamos la cadena
    cadena.setFrequency (2); // delay de acercamiento - = + delay
    mundo.add (cadena); // Agregamos la cadena al mundo


    // --------- Captura de movimiento --------- \\

    setupOSC(PUERTO_OSC);
  }

  void dibujar() {
    image (fondoImg, 0, 0); // Se reemplaza por portadaImg en el estado 0
    // image(colette1, -40, 50, 250, 150);

    cadena.setTarget(mouseX, height - 119 / 2 - 120); // el joint recibe la x del puntero

    if (remyEstado == 0) {
      image (remy[0], width/2 - 160/2, 10 + 150/2);
    } else if (remyEstado == 1) {
      image (remy[1], width/2 - 160/2, 10 + 150/2);
    } else if (remyEstado == 2) {
      image (remy[2], width/2 - 160/2, 10 + 150/2);
    } else if (remyEstado == 3) {
      image (remy[3], width/2 - 160/2, 10 + 150/2);
    } else if (remyEstado == 4) {
      image (remy[4], width/2 - 160/2, 10 + 150/2);
    } else if (remyEstado == 5) {
      image (remy[5], width/2 - 160/2, 10 + 150/2);
    }


    // --------- verdura --------- \\
    if (!verduraEnPantalla) {
      if (frameCount == 10) {
        remyEstado = 0;
        //reproducirEv (0);
        verduraIzq = new Verdura ("verduraIzq");
        verduraIzq.inicializar();
        mundo.add(verduraIzq);
        verduraEnPantalla = true;
      }
    }
 // --------- Captura de movimiento --------- \\
  receptor.actualizar(mensajes); //
  receptor.dibujarBlobs(width, height);

  //// Eventos de entrada y salida de blobs
  for (Blob b : receptor.blobs) {

    if (b.entro) {
      administrador.crearPuntero(b);
      println("--> entro blob: " + b.id);
    }

    if (b.salio) {
      administrador.removerPuntero(b);
      println("<-- salio blob: " + b.id);
    }

    administrador.actualizarPuntero(b);
  }

  if (!receptor.blobs.isEmpty()) {
    Blob blob = receptor.blobs.get(0); // Sup primer blob en la lista

    float targetX = blob.centroidX * width;
    float targetY = blob.centroidY * height;

    // lerp para suavizar el movimiento
    float lerpAmount = 0.2; // Ajusta este valor según la velocidad de suavizado deseada
    currentTargetX = lerp(currentTargetX, targetX, lerpAmount);
    currentTargetY = lerp(currentTargetY, targetY, lerpAmount);

    cadena.setTarget(currentTargetX, height - 119/2); // el joint recibe la x del puntero
  }
  if (receptor.blobs.isEmpty()) {
  }

    // --------- ganar --------- \\
    if (puntos >= 4) {
      estado = 3; // cambio de estado
      limpiar();
      puntos = 0;
    }


    mundo.step(); // Sucede el tiempod
    mundo.draw(); // Dibuja el mundo
  }

// --------- limpieza --------- \\
void evaluarColisionBarra () {
  if (mouseX < 200 && mouseX > 0 && mouseY > 0 && mouseY < 200) {
    colisionConBarra = true;
    //println (colisionConBarra);
  }
}

void limpiar() {
  remyEstado = 3;
  mundo.remove (verduraIzq);
  mundo.remove (verduraDer);

  if (verduraPrevia == "izquierda") {
    //reproducirEv (0);
    remyEstado = 1;
    verduraDer = new Verdura ("verduraDer");
    verduraDer.inicializar();
    mundo.add(verduraDer);
    verduraEnPantalla = true;
    verduraPrevia = "derecha";
  } else if (verduraPrevia == "derecha") {
    //reproducirEv (0);
    remyEstado = 0;
    verduraIzq = new Verdura ("verduraIzq");
    verduraIzq.inicializar();
    mundo.add(verduraIzq);
    verduraEnPantalla = true;
    verduraPrevia = "izquierda";
  }
}

  void ganar() {
    image (ganasteImg, 0, 0); // Imagen de Poster en posición
  }


  void perder () {
    image (perdisteImg, 0, 0); // Imagen de Poster en posición
  }
}
