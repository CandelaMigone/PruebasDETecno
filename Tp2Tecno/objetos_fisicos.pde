// --------- Verduras --------- \\
class Verdura extends FCircle {
  PImage[] verduraImgDer, verduraImgIzq;
  String nombre;
  String lado;
  float anguloVel = 40;
  float velocidad = 500;
  float angulo = radians(-90);
  float anguloVerdura;
  float vxVerdura;
  float vyVerdura;
  float posX;

  Verdura (String _lado) {
    super (50);
    //nombre = _nombre;
    lado = _lado;
    setName (lado);

    verduraImgIzq = new PImage[2];
    verduraImgDer = new PImage[2];

    for (int i = 0; i < 2; i++) {
      verduraImgIzq[i] = loadImage ("img/verduraIzq" + i + ".png");
      verduraImgDer[i] = loadImage ("img/verduraDer" + i + ".png");
    }

    setGrabbable (false); // ¿Se puede agarrar? *va false
    setStatic (false); // ¿Es estático?
    setRestitution (1);
    setDamping (-1);
  }

  void inicializar () {
    if (lado.equals("verduraIzq")) {
      attachImage (verduraImgIzq[int (random(0, 2))]);
      jugando.verduraPrevia = "izquierda";
      posX = -5;
      setPosition (posX, 50); // Asignacion de posición
      anguloVerdura = angulo + radians(90); 
      vxVerdura = velocidad * cos(anguloVerdura);
      vyVerdura = velocidad * sin(anguloVerdura);
      setVelocity(vxVerdura, vyVerdura);
    } else if (lado.equals("verduraDer")) {
      attachImage (verduraImgDer[int (random(0, 2))]);
      jugando.verduraPrevia = "izquierda";
      posX = width + 5;
      setPosition (posX, 50); // Asignacion de posición
      anguloVerdura = angulo - radians(90); 
      vxVerdura = velocidad * cos(anguloVerdura);
      vyVerdura = velocidad * sin(anguloVerdura);
      setVelocity(vxVerdura, vyVerdura);
    }
  }
}


// --------- Ollas --------- \\
class Olla extends FBox {
  String lado;
  PImage ollaDer;
  PImage ollaIzq;

  Olla (float _w, float _h, String _lado) {
    super (_w, _h);
    lado = _lado;
    ollaDer = loadImage ("img/ollaDer.png");
    ollaIzq =  loadImage ("img/ollaIzq.png");
  }

  void actualizar () {

    if (lado.equals("ollaDer")) {
      attachImage(ollaDer);
      setName ("ollaDer"); // Asignacion de nombre
      setPosition (width - 200 / 2, height -  240 / 2 - 130); // Asignacion de posición
      setGrabbable (false); // ¿Se puede agarrar? *va false
      setStatic (true); // ¿Es estático?}
    } else if (lado.equals("ollaIzq")) {
      attachImage(ollaIzq);
      setName ("ollaIzq"); // Asignacion de nombre
      setPosition (200 / 2, height -  240 / 2 - 130); // Asignacion de posición
      setGrabbable (false); // ¿Se puede agarrar? *va false
      setStatic (true); // ¿Es estático?
    }
  }
}


// --------- Jugador --------- \\
class Jugador extends FBox {
  PImage jugadorImg;

  Jugador(float _ancho, float _alto) {
    super (_ancho, _alto);
    setName ("jugador"); // Asignacion de nombre
    setRotatable (false); // ¿Es estático?
    jugadorImg = loadImage ("img/jugadorImg.png");
  }

  void inicializar () {
    attachImage(jugadorImg);
    setPosition (width / 2, height - 119 / 2 - 120); // Asignacion de posición
    setGrabbable (false); // ¿Se puede agarrar? *va false
  }
}


// --------- funcion colision --------- \\
String  conseguirNombre (FBody body) {
  String nombre = "nada";
  if (body != null) {
    nombre = body.getName();
    if (nombre == null) {
      nombre = "nada";
    }
  }
  return nombre;
}


void contactStarted (FContact colision) {
  FBody _body1 = colision.getBody1();
  FBody _body2 = colision.getBody2();

  String nombre1 = conseguirNombre (_body1);
  String nombre2 = conseguirNombre (_body2);

  if ((nombre1.equals(jugando.verduraIzq.lado) && nombre2.equals("ollaDer")) || (nombre2.equals (jugando.verduraIzq.lado) && nombre1.equals("ollaDer"))) {
    println (nombre1, nombre2);
    if (nombre1.equals(jugando.verduraIzq.lado) && colision.getNormalY() > 0) {
      //reproducirEv (4);
      jugando.remyEstado = 4;
      jugando.puntos++;
      println ("puntos: " + jugando.puntos);
      jugando.limpiar();
    } else if (nombre2.equals(jugando.verduraIzq.lado) && colision.getNormalY() < 0) {
      //reproducirEv (4);
      jugando.remyEstado = 4;
      jugando.puntos++;
      println ("puntos: " + jugando.puntos);
      jugando.limpiar();
    }
  } else if ((nombre1.equals(jugando.verduraIzq.lado) && nombre2.equals("ollaIzq")) || (nombre2.equals (jugando.verduraIzq.lado) && nombre1.equals("ollaIzq"))) {
    println (nombre1, nombre2);
    if (nombre1.equals(jugando.verduraIzq.lado) && colision.getNormalY() > 0) {
      println ("perdiste");
      estado = 4; // cambio de estado
      jugando.puntos = 0;
      jugando.limpiar();
    } else if (nombre2.equals(jugando.verduraIzq.lado) && colision.getNormalY() < 0) {
      println ("perdiste");
      estado = 4; // cambio de estado
      jugando.puntos = 0;
      jugando.limpiar();
    }
  } else if ((nombre1.equals(jugando.verduraIzq.lado) && nombre2.equals("piso")) || (nombre2.equals (jugando.verduraIzq.lado) && nombre1.equals("piso"))) {
    //println (nombre1, nombre2);
    //reproducirEv (2);
    jugando.remyEstado = 2;
    jugando.verduraIzq.setVelocity(0, 0);
    jugando.verduraIzq.setRestitution (0);
    jugando.verduraIzq.setDamping (0);
  } else if ((nombre1.equals(jugando.verduraDer.lado) && nombre2.equals("piso")) || (nombre2.equals (jugando.verduraDer.lado) && nombre1.equals("piso"))) {
    //println (nombre1, nombre2);
    //reproducirEv (2);
    jugando.remyEstado = 2;
    jugando.verduraDer.setVelocity(0, 0);
    jugando.verduraDer.setRestitution (0);
    jugando.verduraDer.setDamping (0);
  } else if ((nombre1.equals(jugando.verduraIzq.lado) && nombre2.equals("jugador")) || (nombre2.equals (jugando.verduraIzq.lado) && nombre1.equals("jugador"))) {
    println (nombre1, nombre2);
    //reproducirEv (1);
  } else if ((nombre1.equals(jugando.verduraDer.lado) && nombre2.equals("jugador")) || (nombre2.equals (jugando.verduraDer.lado) && nombre1.equals("jugador"))) {
    println (nombre1, nombre2);
    //reproducirEv (1);
  } else if ((nombre1.equals(jugando.verduraDer.lado) && nombre2.equals("ollaIzq")) || (nombre2.equals (jugando.verduraDer.lado) && nombre1.equals("ollaIzq"))) {
    if (nombre1.equals(jugando.verduraDer.lado) && colision.getNormalY() > 0) {
      //reproducirEv (4);
      jugando.remyEstado = 4;
      jugando.puntos++;
      println ("puntos: " + jugando.puntos);
      jugando.limpiar();
    } else if (nombre2.equals(jugando.verduraDer.lado) && colision.getNormalY() < 0) {
      //reproducirEv (4);
      jugando.remyEstado = 4;
      jugando.puntos++;
      println ("puntos: " + jugando.puntos);
      jugando.limpiar();
    }
  } else if ((nombre1.equals(jugando.verduraDer.lado) && nombre2.equals("ollaDer")) || (nombre2.equals (jugando.verduraDer.lado) && nombre1.equals("ollaDer"))) {
    if (nombre1.equals(jugando.verduraDer.lado) && colision.getNormalY() > 0) {
      println ("perdiste");
      estado = 4; // cambio de estado
      jugando.puntos = 0;
      jugando.limpiar();
    } else if (nombre2.equals(jugando.verduraDer.lado) && colision.getNormalY() < 0) {
      println ("perdiste");
      estado = 4; // cambio de estado
      jugando.puntos = 0;
      jugando.limpiar();
    }
  } else if ((nombre1.equals("jugador") && nombre2.equals("ollaDer")) || (nombre2.equals ("jugador") && nombre1.equals("OllaDer"))) {
  } else if ((nombre1.equals("jugador") && nombre2.equals("ollaIzq")) || (nombre2.equals ("jugador") && nombre1.equals("OllaIzq"))) {
  }
}

void contactPersisted (FContact colision) {
  jugando.colisionConBarra = false;
  FBody _body1 = colision.getBody1();
  FBody _body2 = colision.getBody2();

  String nombre1 = conseguirNombre (_body1);
  String nombre2 = conseguirNombre (_body2);

  if ((nombre1.equals(jugando.verduraIzq.lado) && nombre2.equals("piso")) || (nombre2.equals (jugando.verduraIzq.lado) && nombre1.equals("piso"))) {
    //jugando.remyEstado = 3;
    jugando.evaluarColisionBarra ();
    //println (jugando.colisionConBarra);
    if (jugando.colisionConBarra) {
      //reproducirEv (3);
      //jugando.colisionConBarra = false;
      jugando.limpiar();
    }
  } else if ((nombre1.equals(jugando.verduraDer.lado) && nombre2.equals("piso")) || (nombre2.equals (jugando.verduraDer.lado) && nombre1.equals("piso"))) {
    //jugando.estado(3);
    jugando.evaluarColisionBarra ();
    //println (jugando.colisionConBarra);
    if (jugando.colisionConBarra) {
      //reproducirEv (3);
      //jugando.colisionConBarra = false;
      jugando.limpiar();
    }
  } else if ((nombre1.equals("jugador") && nombre2.equals("ollaDer")) || (nombre2.equals ("jugador") && nombre1.equals("OllaDer"))) {
  } else if ((nombre1.equals("jugador") && nombre2.equals("ollaIzq")) || (nombre2.equals ("jugador") && nombre1.equals("OllaIzq"))) {
  }
}
