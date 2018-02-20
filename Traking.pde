import SimpleOpenNI.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

//class KinectTracker{


class Traking
{
int umbral = 800;
PVector localizacion;
PVector LocalizacionActivada;
int[] depth;
PImage pantalla;

Traking(){
  
 depth = mikinect.getRawDepth(); //Obtener profundidad total sin procesar en arreglo depth
 localizacion = new PVector(0, 0);
 LocalizacionActivada = new PVector(0, 0);
  if (depth==null)return;       //si imagen de profundidad es vacio retornar variables en 0
  
  float EjeX = 0;
  float EjeY = 0;
  float Contador = 0;
  
     for (int x = 0; x < mikinect.width; x++) {
      for (int y = 0; y < mikinect.height; y++) {
        // nivalecion = ajuste o calibracion para los ejes xy que recorren el plano
        int nivelacion = x + y*mikinect.width;
        // proftot = Tomando la profundidad en su valor completo
        int proftot = depth[nivelacion];
        // Prueba vs umbral
        if (proftot < umbral){
          EjeX += x;
          EjeY += y;
          Contador++;
       }
      }
     }
     //Si existen datos en xy, asignarlos al vector locacalizacion 
     if (Contador !=0){
     localizacion = new PVector (EjeX/Contador, EjeY/Contador);
     }
     
    LocalizacionActivada.x = PApplet.lerp(LocalizacionActivada.x, localizacion.x, 0.3f);
    LocalizacionActivada.y = PApplet.lerp(LocalizacionActivada.y, localizacion.y, 0.3f);
     
}
PVector ActivarObtenerPosicion()
{
return LocalizacionActivada;
}

PVector ObtenerPosicion()
{
return localizacion;
}
void Pantalla()
{
PImage ImgProf = mikinect.getDepthImage();

if (depth == null || ImgProf == null )

for (int x = 0; x < mikinect.width; x++) {
      for (int y = 0; y < mikinect.height; y++) {
        int umbral = x + y * mikinect.width;
        // nivalecion = ajuste o calibracion para los ejes xy que recorren el plano
        int pix = x + y*pantalla.width;
        // proftot = Tomando la profundidad en su valor completo
        int proftot = depth[umbral];
        // Prueba vs umbral
        if (proftot < umbral){
          pantalla.pixels[pix] = color (114,149,50);
        } else{
          pantalla.pixels[pix] = ImgProf.pixels[umbral];
        }
      }
}
pantalla.updatePixels();
image(pantalla, 0 , 0);


}
    int ObtenerUmbral(){
    return umbral;
    }
    
    void configurarumbral (int umb){
    umbral = umb;
    }
}