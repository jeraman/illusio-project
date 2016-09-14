




//////////////////////////////////
//variaveis da classe multitoque
//////////////////////////////////
TuioProcessing tuioClient;
boolean clear_selection = false;
boolean debug = false;

//////////////////////////////////
//setup que configura a classe multitoque
//////////////////////////////////
void setup_multitouch ()
{
  tuioClient  = new TuioProcessing(this);
}

//////////////////////////////////
//update na selecao dos botoes
//////////////////////////////////
void update_selection ()
{
  Vector tuioCursorList = tuioClient.getTuioCursors();

  //limpando a memoria
  if (clear_selection)
  {
    clear_selection = false;
    for (int j = 0; j < atual.size(); j++)
    {
      Button b = atual.get_btn(j);
      b.unselect();
    }
  }

  //realizando os hit tests
  for (int i=0;i<tuioCursorList.size();i++)
  {
    TuioCursor tcur = (TuioCursor)tuioCursorList.elementAt(i);
    int nx = (int) (tcur.getX() * width);
    int ny = (int) (tcur.getY() * height);

    //para cada botao!
    for (int j = 0; j < atual.size(); j++)
    {
      Button b = atual.get_btn(j);
      boolean hit = b.hit_test(nx, ny);
      if (hit)
        b.select(nx, ny, tcur.getCursorID());
    }
  }
}


//////////////////////////////////
// called when a cursor is added to the scene
//////////////////////////////////
void addTuioCursor(TuioCursor tcur) 
{
  int nx = (int) (tcur.getX() * width);
  int ny = (int) (tcur.getY() * height);
  int hit = 0;  
  
  tm.createTail(tcur.getCursorID(), nx, ny);
  clear_selection = true;

  if (debug)
    println("add "+tcur.getCursorID() +" " + nx + " " + ny);
    
  if (atual.block_touch_events())
  //if (atual instanceof Waveform)//se for um waveform
  {
    ((Waveform)atual).check_editing(nx, ny);//tente editar a onda!
    if (!((Waveform)atual).is_editing()) //caso não esteja editando
      atual.fm.add_finger(tcur.getCursorID(), nx, ny); //adicionar evento de controle de open/close
    return;
  }  

  //verificando se colidiu com algum botao!
  for (int i = 0; i < atual.size(); i++)
  {
    Button b = atual.get_btn(i);
    boolean hitou = b.hit_test(nx, ny);
    if (hitou)
    {
      hit+=1;
      if (!edit_mode & b.recorded)
        b.play();
    }
  }
   
  //se não colidiu, desenhe!
  if (hit==0)
  {
    atual.add_btn(new Button(nx, ny, atual.get_depth(), tcur.getCursorID(), atual));
    atual.fm.add_finger(tcur.getCursorID(), nx, ny);
  }
}


//////////////////////////////////
// called when a cursor is moved
//////////////////////////////////
void updateTuioCursor (TuioCursor tcur) 
{
  int nx = (int) (tcur.getX() * width);
  int ny = (int) (tcur.getY() * height);
  
  tm.updateTail(tcur.getCursorID(), nx, ny);
  
  if (debug)
    println("mov "+tcur.getCursorID() +" " + nx + " " + ny);
    
  if (atual.block_touch_events())
  //if (atual instanceof Waveform)//se for um waveform
  {
    if (!((Waveform)atual).is_editing()) //caso não esteja editando
      atual.fm.update_finger(tcur.getCursorID(), nx, ny); //atualizando a posição do dedo!
    else //caso contrário
      ((Waveform)atual).update(nx, ny); //autualiza a wave!
    return;
  } 

  //procurando por botoes não completados
  for (int i = 0; i < atual.size(); i++)
  {
    Button b = atual.get_btn(i);
    if (!b.completed) //se não for um botao terminado
    {
      if(b.cursorID == tcur.getCursorID()) //se o autor for o mesmo dedo que esta desenhando
      {
        b.add_point(nx, ny); //acrescente o ponto no botao
        b.completed = false;
        atual.fm.update_finger(tcur.getCursorID(), nx, ny); //atualizando a posição do dedo!
      }
    } else // se não tá criando botão, pode estar movendo...
    {
      if (edit_mode && b.moving && b.fm.contains_finger(tcur.getCursorID()))//tcur.getCursorID() == b.last_finger ) //se ele deve mover
         b.move(nx, ny); //mova! 
      if (b.fm.fingers.size() > 1) //se deve mudar a escala(para abrir botao)!
         b.fm.update_finger(tcur.getCursorID(), nx, ny);
      
    } 
  }
  
}

//////////////////////////////////
// called when a cursor is removed from the scene
//////////////////////////////////
void removeTuioCursor(TuioCursor tcur) 
{
  int nx = (int) (tcur.getX() * width);
  int ny = (int) (tcur.getY() * height);
  
  tm.removeTail(tcur.getCursorID());
  
   //removendo dedo do fingermanager...
  atual.fm.remove_finger(tcur.getCursorID());
  
  if (debug)
    println("rem "+tcur.getCursorID() +" " + nx + " " + ny);
    
  if (atual.block_touch_events())
  //if (atual instanceof Waveform)//não faça mais nada se for um waveform
  {  
    ((Waveform)atual).stop_editing();
    return;  
  }
  if (tuioClient.getTuioCursors().size() > 1)
    clear_selection = true;

  for (int i = 0; i < atual.size(); i++)
  {
    Button b = atual.get_btn(i);
    if (!b.completed) //se não for um botao terminado
    {
      if(b.cursorID == tcur.getCursorID()) //se o autor for o mesmo dedo que esta desenhando
      {
        if (b.points.size() < 35) 
        {  
          b.clear();
          atual.rmv_btn((atual.size()-1));
        }
        else   
          b.ativate();
      }
    } else //se está completo
    {
       if (b.moving && b.fm.contains_finger(tcur.getCursorID()))//tcur.getCursorID() == b.last_finger) //se ele largou um botao que estava movendo...
         b.remove_finger(tcur.getCursorID());
    }
  }
}

//////////////////////////////////
// called after each message bundle
// representing the end of an image frame
//////////////////////////////////
void refresh(TuioTime bundleTime) { 
  redraw();
}

/////////////////////////////////
//trash methods
/////////////////////////////////
void addTuioObject(TuioObject tobj) {}

void removeTuioObject(TuioObject tobj) {}

void updateTuioObject(TuioObject tobj) {}



