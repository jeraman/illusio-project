

/*******************************************************
********************************************************
** ILLUSIO *********************************************
********************************************************
** software in beta stage developed by jeraman, 2011 ***
** http://jeraman.info *********************************
********************************************************
********************************************************/

//////////////////////////////
// imports ///////////////////
//////////////////////////////
import TUIO.*;
import oscP5.*;
import netP5.*;
//import fullscreen.*;

//////////////////////////////
// setup /////////////////////
//////////////////////////////   
void setup()
{                                  
  setup_interface();
  //setup_ess();
}

//////////////////////////////
// draw //////////////////////
//////////////////////////////
void draw()
{
  update_key();
  draw_interface();
}

/*
void close()
{
  close_ess();
}*/

//////////////////////////////
// funcoes de teclado ////////
//////////////////////////////
void keyPressed()
{
  if (key=='-')
    clear_stage();
  if (key=='o')
    open_stage();
  if (key=='c')
    close_stage();
  if (key==65535)
    change_mode();
  
}


//////////////////////////////
// funcoes de mouse //////////
//////////////////////////////
//enquanto estiver criando o botao
void mouseDragged()
{
  aux_mouseDragged(mouseX, mouseY);
}
void mouseReleased()
{
  aux_mouseReleased(mouseX, mouseY);
}
void mousePressed()
{
  aux_mousePressed(mouseX, mouseY);
}




