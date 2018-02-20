// Daniel Shiffman
// Tracking the average location beyond a given depth threshold
// Thanks to Dan O'Sullivan

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/
import org.openkinect.freenect.*;
import org.openkinect.processing.*;
class KinectTracker {

  // Depth threshold -         Umbral de profundidad 
  int threshold = 800;

  // Raw location  -           Ubicacion Encontrada
  PVector loc;

  // Interpolated location -   Ubicacion interpolada
  PVector lerpedLoc;

  // Depth data -              Datos de profundidad
  int[] depth;
  
  // What we'll show the user- Mostrar imagen
  PImage display;
   
  KinectTracker() {
    // This is an awkard use of a global variable here - Uso incierto de variable por simplicidad
    // But doing it this way for simplicity
    //mikinect.initDepth();       //   Iniciar servicio de imagen de profundidad
    //mikinect.enableMirror(true);//   Iniciar servicio de espejo Activado
    // Make a blank image     //   Crear imagen en Blanco 
    display = createImage(mikinect.width, mikinect.height, RGB);
    // Set up the vectors -        Configuracion de los Vectores
    loc = new PVector(0, 0);
    lerpedLoc = new PVector(0, 0);
  }

  void track() {
    // Get the raw depth as array of integers - Obtener matriz de profundidad
    depth = mikinect.getRawDepth();

    // Being overly cautious here
    if (depth == null) return;

    float sumX = 0;
    float sumY = 0;
    float count = 0;

    for (int x = 0; x < mikinect.width; x++) {
      for (int y = 0; y < mikinect.height; y++) {
        
        int offset =  x + y*mikinect.width;
        // Grabbing the raw depth
        int rawDepth = depth[offset];

        // Testing against threshold
        if (rawDepth < threshold) {
          sumX += x;
          sumY += y;
          count++;
        }
      }
    }
    // As long as we found something
    if (count != 0) {
      loc = new PVector(sumX/count, sumY/count);
    }

    // Interpolating the location, doing it arbitrarily for now
    lerpedLoc.x = PApplet.lerp(lerpedLoc.x, loc.x, 0.3f);
    lerpedLoc.y = PApplet.lerp(lerpedLoc.y, loc.y, 0.3f);
  }

  PVector getLerpedPos() {
    return lerpedLoc;
  }

  PVector getPos() {
    return loc;
  }

  void display() {
    PImage img = mikinect.getDepthImage();

    // Being overly cautious here
    if (depth == null || img == null) return;

    // Going to rewrite the depth image to show which pixels are in threshold
    // A lot of this is redundant, but this is just for demonstration purposes
    display.loadPixels();
    for (int x = 0; x < mikinect.width; x++) {
      for (int y = 0; y < mikinect.height; y++) {

        int offset = x + y * mikinect.width;
        // Raw depth
        int rawDepth = depth[offset];
        int pix = x + y * display.width;
        if (rawDepth < threshold) {
          // A red color instead
          display.pixels[pix] = color(114, 149, 50);
        } else {
          display.pixels[pix] = img.pixels[offset];
        }
      }
    }
    display.updatePixels();

    // Draw the image
    
    image(display, 0, 0);
    
    
  }

  int getThreshold() {
    return threshold;
  }

  void setThreshold(int t) {
    threshold =  t;
  }
}