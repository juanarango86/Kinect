//import SimpleOpenNI.*; //<>// //<>//
import org.openkinect.freenect.*;                    //Se importan librerias OpenKinect
import org.openkinect.processing.*;                  //Se importan librerias OpenKinect

//SimpleOpenNI kinect;
//Traking tracker;

import controlP5.*;                                  //Se importan librerias ControlP5
ControlP5 cp5;                                       //Declaracion
//Accordion accordion;                               
//float v1 = 50, v2, v3, v4 = 100;
Kinect mikinect;                                      //Declaracion de Objeto Kinect
KinectTracker tracker;                                //Declaracion de objeto para llamar funciones de la clase KinectTracker    
//Range range;

int ValorCercano;                                     //Declaracion de variable para uso en metodo de deteccion del pixel mas cercano
//int ValorX;
//int ValorY;
int[][] mat = new int[8][2];                         //Matriz de equivalencia 1ra valor, 2da equivalencia 
float threshold = 50;                                // En centimetros
float circle1, circle2, circle3;                     //Declaracion cirle para anillos de aproximacion
//boolean colorDepth = false;

void setup()                                      //Metodo Setup se declara todo lo que siempre se va a ejecutar al iniciar el programa
{
  FillMat();                                      //Declaracion de matriz
  //kinect.enableDepth();
  //kinect.enableColorDepth(colorDepth);
  //kinect = new SimpleOpenNI(this);
  //kinect.initDevice();
  size(860, 480);                                 //Declaracion tamaño del formulario
  mikinect = new Kinect(this);                    //Declaracion de Objeto Kinect
  //mikinect.initDepth();
  //mikinect.initVideo();
  mikinect.enableMirror(true);                    //Activa efecto de espejo en visualizacion del Kinect
  tracker = new KinectTracker();                  //Declaracion Kinect Traker para realizar seguimiento

  background(220);                                //Background Amarillo
  rect (640, 1, 220, 480);                        //Area de controles de la aplicacion
  noStroke();                                     //No muestra borde de figura rectangulo
  cp5 = new ControlP5(this);                      //Declaracion Objeto para uso de libreria ControlP5 (Botones, Sliders, etc...)

  cp5.addButton("Start")                          //Declaracion de boton start para iniciar el video del Kinect
    .setValue(0)                                  //Valor Inicial 0
    .setPosition(650, 50)                         //Posicion de Objeto Boton
    .setSize(80, 25)                              //Tamaño de Objeto Boton
    .addCallback(new CallbackListener() {                      //Declaracion de objeto para usar en el boton
    public void controlEvent(CallbackEvent event) {            //Metodo para activar funcionalidad del boton
      if (event.getAction() == ControlP5.ACTION_RELEASED) {    //Condicional boton
        mikinect.initDepth();                                  //Activa la camara de profundidad
        mikinect.initVideo();                                  //Muestra el Video en Pantalla
      }
    }
  }
  );

  // and add another 2 buttons
  cp5.addButton("Stop")                                       //Declaracion de boton stop para Detener el video del Kinect
    .setValue(0)                                              //Valor Inicial 0
    .setPosition(650, 200)                                    //Posicion de Objeto Boton
    .setSize(80, 25)                                          //Tamaño de Objeto Boton
    .addCallback(new CallbackListener() {                     //Declaracion de objeto para usar en el boton
      public void controlEvent(CallbackEvent event) {         //Metodo para activar funcionalidad del boton
      if (event.getAction() == ControlP5.ACTION_RELEASED) {   //Condicional boton
        mikinect.stopDepth();                                 //Detiene la camara de profundidad
        mikinect.stopVideo();                                 //Detiene el Video en Pantalla
      }
    }
  }
  );

  //PImage[] imgs = {loadImage("button_a.png"),loadImage("button_b.png"),loadImage("button_c.png")};

  cp5.addButton("Help !")                                     //Declaracion de boton Help ! para Visualizar instrucciones de uso del software
    //.setValue(128) //Valor Inicial 128
    .setPosition(740, 200)                                    //Posicion de Objeto Boton
    //.setImages(imgs)
    //.updateSize()
    .setSize(80, 25);                                         // Tamaño de objeto Boton
  ;

  cp5.addButton("Exit")                                       //Declaracion de boton stop para Detener el video del Kinect
    //.setValue(128)                                          //Valor Inicial 0
    .setPosition(650, 240)                                    //Posicion de Objeto Boton
    //.setImages(imgs)
    //.updateSize()
    .setSize(80, 25)                                          //Tamaño del objeto Boton
    .addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent event) {           //Metodo para activar funcionalidad del boton
      if (event.getAction() == ControlP5.ACTION_RELEASED) {   //Condicional boton
        exit();                                               //Funcion que termina la aplicacion
      }
    }
  }
  );

  //range = cp5.addRange("Threshold")
  //  // disable broadcasting since setRange and setRangeValues will trigger an event
  //  .setBroadcast(false) 
  //  .setPosition(650, 85)
  //  .setSize(150, 40)
  //  .setHandleSize(20)
  //  .setRange(0, 255)
  //  .setRangeValues(50, 100)
  //  // after the initialization we turn broadcast back on again
  //  .setBroadcast(true)
  //  .setColorForeground(color(255, 40))
  //  .setColorBackground(color(255, 40))  
  //  ;

  cp5.addSlider("sliderValue")                                //Declaracion Objeto Slider para controlar el umbral
    .setRange(50, 400)                                        //Rango de Desplazamiento del Slider
    .setPosition(650, 85)                                     //Posicion del Objeto Slider
    .setSize(120, 25)                                         //Tamaño del Objeto
    .setValue(50)                                             //Valor inicial por defecto del Slider al iniciar la aplicacion
    ;

  cp5.addIcon("Traking", 10)                                  //Declaracion de Objeto Icon para activar o Desactivar la funcion del punto mas cercano
    .setPosition(650, 120)                                    //Posicion del Objeto
    .setSize(70, 50)                                          //Tamaño del Objeto
    //.setRoundedCorners(20)                                  //Esquinas del objeto Redondeadas
    .setFont(createFont("fontawesome-webfont.ttf", 40))       //Tomar el archivo para generar la fuente del objeto Icon
    .setFontIcons(#00f205, #00f204)                           //Asingnacion de forma del objeto Icon
    .setScale(0.9, 1)                                         //Aumenta o  Disminuye la forma del Objeto Icon
    .setSwitch(true)                                          //Muestra por defecto el Objeto Icon Activado
    .setColorBackground(color(255, 100))                      //Color del fondo del Objeto cuando se activa
    //.hideBackground()                                       //Esconder Fondo Del Objeto Icon
    //.setLabel("Traking");                                   //Mostrar Nombre del Objeto Icon
    ;  

  cp5.addSlider("Volumen Robot")                              //Declaracion de Objeto
    .setPosition(650, 170)                                    //Posicion del Objeto
    .setSize(100, 20)                                         //Tamaño del Objeto
    .setRange(50, 500)                                        //Rango de Desplazamiento del Slider
    .setValue(50)                                             //Valor inicial por defecto del Slider al iniciar la aplicacion
    ;

 
  rect (640, 1, 220, 480);                                  //Creacion de Rectangulo para el area de los controles de la aplicacion
  background(255, 204, 0);                                  //Fondo para el rectangulo de los controles de la aplicacion
  noStroke();                                               //No mostrar borde del rectangulo
}

void draw()                                                  //Metodo Draw
{
  
  //background(0);
  //Kinect.update();
  // get the depth array from the kinect
  //int[] depthValues = Kinect.initDepthMap();
  ValorCercano = 8000;  //Declaracion de objeto             // Se le asigna a la variable ValorCercano valor de 8000 es un valor superior al alcance del kinect
  delay(40);                                                // Tiempo de retardo de imagen en milesimas de segundo
  float VlrX = 0;                                           // Variable VlrX para utilizar en el recorrido de la imagen Filas para detectar el pixel mas cercano
  float VlrY = 0;                                           // Variable Vlry para utilizar en el recorrido de la imagen Columnas para detectar el pixel mas cercano
  int[] depth;                                              // Declaracion de matriz para datos de profundidad
  depth = mikinect.getRawDepth();                           // Asingacion a la matriz depth los valores de profunfdidad del kinect
  image(mikinect.getDepthImage(), 0, 0);                    // Cargue de la imagen de profundidady se asignan valores iniciales de 0 para las coordenadas de x y

  for (int Y = 0; Y < 480; Y++)                             //Recorrido de los datos de las columnas de la matriz con la informacion de profundidad
  {
    for (int X = 0; X < 640; X++)                           //Recorrido de los datos de las columnas de la matriz con la informacion de profundidad
    {
      int i =  X + Y*640;                                   // Asignacon de datos a variable i, para convertir los valores de un pixel de una imagen al valor correspondiente en la matriz
      int rawDepth = depth[i];                              // Variable rawDepth almacena toda la informacion de profundidad detectada por el kinect

      if (rawDepth > 0 && rawDepth  < ValorCercano)         //Condicional para clasificar los valores mayores o menores y determinar el pixel mas cercano
      {
        ValorCercano = rawDepth;                            //Se asigna toda la informacion de profundidad detectada por el kinect a la variable ValorCercano
        VlrX = X;                                           //Se lleva el valor de X de las filas a la variable VlrX para generar coordenadas con el valor de la variable VlrY
        VlrY = Y;                                           //Se lleva el valor de Y de las filas a la variable VlrY para generar coordenadas con el valor de la variable VlrX
        //cont++;
        int milimetros = depth[i];                          //Declaracion de variable milimetros y se le asigna el valor de i correspondiente a la profundidad
        float Pulgadas = (milimetros / 25.4) ;              //Declaracion de variable pulgadas y calculo para generar valores de distancia en pulgadas y calculo para conversion de datos a milimetros
        println("Distacia en Centimetros: " + (milimetros * 0.1) + " ó en Pulgadas: " + (Pulgadas));      //Muestra la distancia e milimetros y en pulgadas
        //ellipse(320, 240, 60, 60); // Area robot
      }
    }
  }
  
  ellipse(VlrX, VlrY, 20, 20);                                //Creacion del punto a mostrar en el pixel mas cercano detectado en las coordenadas formadas por las variables  VlrX y VlrY, con tamaño de 20
  fill (255, 0, 0);                                           //Color de relleno del punto
  noStroke();                                                 //No mostrar borde del punto
  println("Area de mov. del robot: " + VlrX + (VlrY * 640));  // Muestra mensaje si existe pixel mas cercano detectado en el area del robot

  //////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////
  
  
  background(130);                       //Establecer el fondo para mostrar en area de controles de aplicacion en rango 255 (0=negro,  blanco = 255)

                                         //Ejecucion de clase KinectTracker
  tracker.track();                       //LLamado de metodo .track de la clase KinecTracking a traves del objeto tracker
  tracker.setThreshold(GetLimit());      //LLamado de metodo .setThreshold y GetLimit de la clase KinecTracking a traves del objeto tracker
  tracker.display();                     //LLamado de metodo .display de la clase KinecTracking a traves del objeto tracker

 //PVector v0 = new PVector(319.50183, 239.11406, 0);   // limite campo visual para realizar el seguimiento
  PVector v0 = new PVector(640,480, 0);   // limite campo visual para realizar el seguimiento con tamaño de campo visual del kinect de x=640 y=480


  PVector v1 = tracker.getPos();          //Obtener la ubicacion en distancia
  //fill(50, 100, 250, 200);              // Rellenar color
  noStroke();                             // Inactivar contorno figura
  //ellipse(v1.x, v1.y, 20, 20);          //Declaracion de punto que muestra el pixel mas cercano con sus respectivos parametros de tamaño en ejes x,y
  ellipse(VlrX, VlrY, 20, 20);            //Declaracion de punto que muestra el pixel mas cercano con sus respectivos parametros de tamaño en ejes x,y

  //se le setea al umbral el valor seleccionado en el slider
  threshold = cp5.getController("sliderValue").getValue();

  float s1 = cp5.getController("Volumen Robot").getValue();
  fill(255,0,0,127);
  ellipse(320, 240, s1, s1);
  circle2 = s1 + 100;
  circle3 = s1 + 200;
  
  rect(641, 280, 219, 200, 7);

  float point = v0.dist(v1);                           //Asignacion de punto a v0
  if (point <= circle1)
    println("Area de mov. del robot: " + point);       //Muestra alerta si genera movimiento el el area asignada para el volumen del robot
  if (point > circle1 && point <= circle2)
    println("Alerta esta en el anillo 1: " + point);   //Muestra alerta si genera movimiento en el anillo de proximidad 1
  if (point > circle2 && point <= circle3)
    println("Alerta esta en el anillo 2: " + point);   //Muestra alerta si genera movimiento en el anillo de proximidad 2
  if (point > circle3)
    println("Alerta esta en el anillo 3: " + point);   //Muestra alerta si genera movimiento por fuera del anillo de proximidad 2






  // Let's draw the "lerped" location
  //PVector v2 = tracker.getLerpedPos();
  //fill(100, 250, 50, 200);
  //noStroke();
  //ellipse(v2.x, v2.y, 20, 20);

  delay(500);                      // Retardo de imagen en milisegundos
}


//evento al oprimir boton
public void controlEvent(ControlEvent theEvent) {
  println(theEvent.getController().getName());
  showEventButton(theEvent.getController().getName());
}

void showEventButton(String boton) {
  //switch(boton) {
  //  case("Start"):
  //  mikinect.initDepth();
  //  mikinect.initVideo();
  //  break;
  //}
}


void FillMat()
{
  //MATRIZ DE 8 FILAS Y 2 COLUMNAS
  mat[0][0] = 400; 
  mat[0][1] = 50;      //cm
  mat[1][0] = 750; 
  mat[1][1] = 100;     //cm
  mat[2][0] = 860; 
  mat[2][1] = 150;     //cm
  mat[3][0] = 918; 
  mat[3][1] = 200;     //cm
  mat[4][0] = 953; 
  mat[4][1] = 250;     //cm
  mat[5][0] = 976; 
  mat[5][1] = 300;     //cm
  mat[6][0] = 994; 
  mat[6][1] = 350;     //cm
  mat[7][0] = 1006; 
  mat[7][1] = 400;     //cm
}      

int GetLimit()
{
  int response = 0;
  for (int count = 0; count <= 7; count++) //Recorrer matriz de equivalencia
  {
    response = mat[count][0];
    if (threshold <= mat[count][1])     // Condicionador reccorrido de matriz
      break;
  }
  println("Limit: " + response);         //Muestra el threshold asignado segun la matriz de equivalencia en pantalla
  return response;
}   


//tracker.configurarumbral(GetLimit());
//tracker.Pantalla();  
//PVector P0 = new PVector(319.50183, 239.11406, 0);
//image(kinect.getDepthImage(),0, 0);
//PVector P1 = tracker.ObtenerPosicion();
//fill (50, 100, 250, 200);

//float punto = P0.dist(P1);
//if (punto >=  0)
//println("Area de mov. del robot: " + punto); 
//int offset =0;
//int Depth = depth[offset];



void display()
{
  //background(v1);
}

//void style(String theControllerName) 
//{
//  Controller c = cp5.getController(theControllerName);
//  // adjust the height of the controller
//  c.setHeight(15);

//  // add some padding to the caption label background
//  c.getCaptionLabel().getStyle().setPadding(4, 4, 3, 4);

//  // shift the caption label up by 4px
//  c.getCaptionLabel().getStyle().setMargin(-4, 0, 0, 0); 

//  // set the background color of the caption label
//  c.getCaptionLabel().setColorBackground(color(10, 20, 30, 140));
//}

//void keyPressed() 
//{
//  int t = tracker.getThreshold();
//  if (key == CODED) {
//    if (keyCode == UP) {
//      t+=500;
//      tracker.setThreshold(t);
//    } else if (keyCode == DOWN) {
//      t-=500;
//      tracker.setThreshold(t);
//    }
//  }
//}

float ObtenerUmbral() 
{
  return threshold;
}

void configurarumbral(float t) 
{
  threshold =  t;
}