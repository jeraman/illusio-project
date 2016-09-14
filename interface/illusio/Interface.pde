       


  //////////////////////////////////
  //variaveis principais
  //////////////////////////////////
  //FullScreen  fs;
  Stage       atual;
  Stack       stack;
  TailManager tm;
  Button      aux;
  int         first_time;

  int hold_time = 2; 
  boolean is_ctrl_done  = false; 
  boolean is_space_done = false;
  int   ctrl_start  = -1;
  int   space_start = -1;

  boolean edit_mode = true;
  
  //modification in jan 18th 2016
  int displayWidth = 1280;
  int displayHeight = 800;
  

  //////////////////////////////////
  //setup
  ////////////////////////////////
  void setup_interface()
  {
    atual = new Stage();
    stack = new Stack();
    first_time = 0;
    aux = null;
    frameRate(30);
    //size(1024, 768);
    size(displayWidth, displayHeight);
    setup_multitouch();
    setup_communication();
    tm = new TailManager();
    //fs = new FullScreen(this);
    ///////////////
    //FULLSCREEN //
    //fs.enter(); ///
    ///////////////
    //noCursor();
  }

  //////////////////////////////////
  //draw
  ////////////////////////////////
  void draw_interface()
  {
    smooth();
    strokeWeight(15);
    stroke(100);
    update_selection();
    update_first_time();
    atual.draw();
    update_stage();
    tm.draw();
  }
  
  ////////////////////////////////
  // update a duração central do loop...
  // update o visual externo de um mockup
  ////////////////////////////////
  void update_first_time ()
  {  
    for (int i = 0; i < atual.size(); i++)
    {
      Button b = (Button) atual.get_btn(i);
      if (b.state == State.PLAYING || b.state == State.STOPED) //pegando o primeiro que tenha algo gravado
      {
         first_time = b.time;
         //println(first_time);
         return;  
      } 
    }
  }
  
  ////////////////////////////////
  // aglomerar botoes selecionados
  ////////////////////////////////  
  void agrupar ()
  {
    Vector bs = new Vector();
    int base = 0;
    int menor_selected = 10000000;

    for (int i = 0; i < atual.size(); i++) //pegando os botoes selecionados
    {
      Button b =  atual.get_btn(i);
      if (b.selected != -1) //se está selecionado
      {
        if (b.selected < menor_selected) //caso b seja o novo mais antigo
        {
          base = i;
          menor_selected = b.selected;
        }

        bs.add(new Integer(i));
      }
    }

    //println(base);
    //println(bs.size());
    //for (int j = bs.size()-1; j >= 0; j--)
    //  println((Integer)bs.get(j));

    if (bs.size() > 0) //se for mais que 1 botao selecionado
      for (int j = bs.size()-1; j >= 0; j--) //aglomera para cada botao fora o primeiro
      {
        //println( (Integer) bs.get(j));
        int t = (Integer) bs.get(j);
        if (t != base)
          atual.aglomerar(base, t);
      }
  }
  
  
  ////////////////////////////////
  // abre o stage do botao selecionado
  //////////////////////////////// 
    void open_stage ()
  {
    Vector s = atual.get_selected(); //pega os selecionados
    if (s.size() > 0) //caso exista selecionados
    {
      Button b = (Button) s.get(0);
      b.open();
      aux = b;
      stack.push(b);
    }
  }
  
  ////////////////////////////////
  // fecha o stage atual
  //////////////////////////////// 
  void close_stage()
  {
    if (stack.size() > 0)
    {
      aux = (Button) stack.pop();
      if (!(atual instanceof Waveform))
        atual.erase_uncompleted();
      atual = atual.get_up();//aux.get_stage().get_up();      
      aux.close();
    }
  }
  
  //////////////////////////////////
  //função para auxiliar no desenho dos efeitos de abertura e fechamento
  ////////////////////////////////
  void update_stage()
  {
    // verificando se é necessário abrir algum botao...
    for (int i = 0; i < atual.size(); i++) //pegando os botoes selecionados
    {
      Button b =  atual.get_btn(i);
      if (b.fm.fingers.size() > 1) //se é pra abrir...
      {
        float diff = b.fm.calculate_fingers_distance() - b.fm.escala;
        if (diff > 100 && b.bang_o == false)
        {
          b.fm.reinit();
          //atual.fm.reinit();
          open_stage();
          return;
        } 
      } 
    }
   
    //verificando se deve fechar um stage
    if (atual.fm.fingers.size() > 1) //se é pra fechar...
    {
      float diff = atual.fm.calculate_fingers_distance() - atual.fm.escala;
      if (diff < -100)
      {
        atual.fm.reinit();
        close_stage();
        return;
      }
    }
    
    
    if (aux!=null)
    {
      if (aux.bang_o) //se ele foi apertado
          aux.draw_animation();

      if (aux.finished_o) //se terminou a animação...
        if (aux.effect_mode==0)//e era de crescer...  
          atual = aux.get_stage(); //autualizar o stage
    }
  }
          
  ////////////////////////////////
  // que limpa a interface!
  ////////////////////////////////  
  void clear_stage ()
  {
    while (atual.size()>0)
    {
      Button b = (Button) atual.get_btn(0);
      b.erase();
      atual.btns.remove(b);
    }
  }
  
  ////////////////////////////////
  // comando que grava
  //////////////////////////////  
  void record ()
  {
    Vector s = atual.get_selected();
    if (s.size() > 0) //caso exista selecionados
    {
       Button b = (Button) s.get(0);
       //if (b.state == State.STOPED)
       //  b.play();
       b.record();
       //println(b);
    }
  }
  
  ////////////////////////////////
  // comando que dá play num loop
  //////////////////////////////    
  void play()
  {
    Vector s = atual.get_selected();
    for(int i = 0; i < s.size(); i++) //caso exista selecionados
    {
       Button b = (Button) s.get(i);
       b.play();
    }
  }
  
  ////////////////////////////////
  // comando que dá play or stop num loop
  //////////////////////////////    
  void play_or_stop()
  {
    Vector s = atual.get_selected();
    for(int i = 0; i < s.size(); i++) //caso exista selecionados
    {
       Button b = (Button) s.get(i);
       b.play_or_stop();
    }
  }
  
  ////////////////////////////////
  // comando que para de tocar os loops
  //////////////////////////////     
  void stop ()
  {
    Vector s = atual.get_selected();
    while (s.size()>0)
    {
       Button b = (Button) s.get(0);
       b.stop();
       s.remove(b);
    }
  }
  
  ////////////////////////////////
  // comando que deleta loops
  //////////////////////////////  
  void delete()
  {
    Vector s = atual.get_selected();
    while (s.size()>0)
    {
      Button b = (Button) s.get(0);
      b.erase();
      atual.btns.remove(b);
      s.remove(b);
    }
  }
  
  ////////////////////////////////
  // comandop que trata do teclado!
  //////////////////////////////  
  void update_key()
  {
    int last = millis();
    
    if (keyPressed)
      switch(key)
      {      
      case 32: //se apertou espaço...
         if (!is_ctrl_done)
           if (ctrl_start == -1) //se tá començando
           {
             println("grava!");
             this.record();
             ctrl_start = millis();
           } 
           else if (last - ctrl_start > hold_time*1000) //se terminou
           {
             println("deleta!");
             this.record();
             this.delete();
             is_ctrl_done = true;
           }
         break;
      
      case 10:
         if (!is_space_done)
           if (space_start == -1) //se tá començando
           {
             println("toca!");
             this.play_or_stop();             
             space_start = millis();
           } 
           else if (last - space_start > hold_time*1000) //se terminou
           {
             println("agrupa!");
             this.agrupar();
             is_space_done = true;
           }
         break;
      }
    else
    {
      is_ctrl_done  = false;
      is_space_done = false;
      ctrl_start  = -1;
      space_start = -1;         
    }
  }
  
  
  ////////////////////////////////
  // funcao auxiliar para brincar com o mouse
  ////////////////////////////////
  void aux_mouseDragged(int x, int y)
  {
     Button b =  atual.get_btn(atual.size()-1);//btns.get(btns.size()-1);
    if (!b.completed)
    {
      b.add_point(x, y);
      b.completed = false;
    } 
    
    else // se não tá criando botão, pode estar movendo...
    {
      for (int i = 0; i < atual.size(); i++) 
      {
        b = (Button) atual.get_btn(i);
        if (b.moving && b.fm.contains_finger(b.cursorID));//b.last_finger == b.cursorID) //se ele deve mover
          b.move(x, y); //mova!
      }
    }
  }
  
  ////////////////////////////////
  // funcao auxiliar para brincar com o mouse
  ////////////////////////////////
  void aux_mouseReleased(int x, int y)
  {
    Button b =  atual.get_btn(atual.size()-1);//btns.get(btns.size()-1);
  
    //transformar isso aqui num método terminar botao
    if (!b.completed)
    {
      if (b.points.size() < 35) 
      {  
        b.clear();
        atual.rmv_btn(atual.size()-1);
      }
      else   
        b.ativate();
    }
  }
  
  ////////////////////////////////
  // funcao auxiliar para brincar com o mouse
  ////////////////////////////////  
  void aux_mousePressed(int x, int y)
  {
    //verificando se colidiu com algum botao!
    boolean hit = false;
    int n_hits = 0;
    
    for (int i = 0; i < atual.size(); i++)
    {
      Button b = (Button) atual.get_btn(i);
      //if (!hit) //ainda nao atingiu alguem, continue tentando
      hit = b.hit_test(x, y);
      //else //se ja atingiu, continue apenas para atualizar a selecao
      
      if (hit)
      {
        b.select(x, y, -1);
        n_hits++;
      }
      else if (!keyPressed)
        if (key!=65535)
          b.unselect();
    }
    
    if (n_hits==0) //não atingiu nenhum botão!
      atual.add_btn(new Button(x, y, atual.get_depth(), atual));
  }
  
  
  ////////////////////////////////
  // funcoes que gerenciam o run/editmode
  ////////////////////////////////  
  void edit_mode ()
  {
    edit_mode = true;
  }
  void run_mode ()
  {
    edit_mode = false;
  }
  void change_mode()
  {
    edit_mode=!edit_mode;
  }






