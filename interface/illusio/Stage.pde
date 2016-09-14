
class Stage
{
  private FingerManager fm;
  private Vector        btns;
  private Stage         up;
  private int           depth;
  private color         bkg;

  //////////////////////////////////
  //contrutor
  //////////////////////////////////
  public Stage ()
  {
    this.btns  = new Vector();
    this.up    = null;
    this.depth = 0;
    this.bkg   = color(255, 255, 255);
    this.fm    = new FingerManager();
  }

  //////////////////////////////////
  //contrutor
  //////////////////////////////////
  public Stage (int depth, Stage up)
  {
    this.btns  = new Vector();
    this.up    = up;
    this.depth = depth;
    this.bkg   = color(255);//max(0, 255 - (127*this.depth)));
    this.fm    = new FingerManager();
  }

  //////////////////////////////////
  //retorna o tamanho do stage
  //////////////////////////////////
  int size()
  {
    return this.btns.size();
  }

  ////////////////////////////////// 
  //retorna a cor do stage
  ////////////////////////////////// 
  color get_color()
  {
    return this.bkg;
  }

  ////////////////////////////////// 
  //retorna o stage up
  ////////////////////////////////// 
  Stage get_up()
  {
    return this.up;
  }

  ////////////////////////////////// 
  //retorna o depth
  ////////////////////////////////// 
  int get_depth()
  {
    return this.depth;
  }

  ////////////////////////////////// 
  //limpa os buttons do stage
  ////////////////////////////////// 
  void clear()
  {
    this.btns.clear();
  }

  //////////////////////////////////
  //inserir botao
  //////////////////////////////////
  void add_btn (Button b)
  {
    btns.add(b);
  }

  //////////////////////////////////
  //get botao
  //////////////////////////////////
  Button get_btn (int i)
  {
    return (Button) this.btns.get(i);
  }

  //////////////////////////////////
  //remove button
  //////////////////////////////////
  void rmv_btn (int i)
  {
    this.btns.remove(i);
  }

  //////////////////////////////////
  //desenhar todos os stages
  //////////////////////////////////
  void draw()
  {
    if (edit_mode)
      bkg = color(255, 255, 255);
    else
      bkg = color(0, 0, 0);
      
    background(this.bkg);

    for (int i = 0; i < btns.size(); i++)
    {
      Button b = (Button) btns.get(i);
      b.draw();
    }
  }

  //////////////////////////////////
  //funcao que retorna todos os botoes selecionados do stage
  /////////////////////////////////
  Vector get_selected()
  {
    Vector ret = new Vector();
    for (int i = 0; i < btns.size(); i++)
    {
      Button b = (Button) btns.get(i);
      if (b.selected!=-1)
        ret.add(b);
    }
    return ret;
  }
  
  
  //////////////////////////////////
  //funcao que retorna quantos botoes estao tocando dentro deste stage
  //////////////////////////////////
  int how_many_plays()
  {
    Vector ret = new Vector();
    for (int i = 0; i < btns.size(); i++)
    {
      Button b = (Button) btns.get(i);
      if (b.state == State.PLAYING)
        ret.add(b);
    }
    return ret.size();
  }

  //////////////////////////////////
  //insere um botao dentro deste stage
  //////////////////////////////////
  void aglomerar(int i, int j)
  {
    Button b = this.get_btn(i);
    b.aglomerar(this.get_btn(j));
    this.rmv_btn(j);
  }
  
  
  //////////////////////////////////
  //para de tocar todos o botoes desse stage
  //////////////////////////////////
  void stop()
  {
    for (int i = 0; i < btns.size(); i++)
    {
      Button b = (Button) btns.get(i);
      b.stop();
    }
  }
  
  //////////////////////////////////
  //toca todos o botoes desse stage
  //////////////////////////////////
  void play()
  {
    for (int i = 0; i < btns.size(); i++)
    {
      Button b = (Button) btns.get(i);
      b.play();
    }
  }
  
  //////////////////////////////////
  //apaga todos o botoes desse stage
  //////////////////////////////////
  void erase()
  {
    for (int i = 0; i < btns.size(); i++)
    {
      Button b = (Button) btns.get(i);
      b.erase();
    }
    btns.clear();
  }


  //////////////////////////////////
  //toca todos o botoes desse stage
  //////////////////////////////////
  void erase_uncompleted()
  {
    for (int i = btns.size()-1; i >= 0; i--)
    {
      Button b = (Button) btns.get(i);
      if (b.completed == false)
      {
        b.erase();
        btns.remove(i);
      }
    }
  }
  
  //////////////////////////////////
  //retorna a duração do loop mais longo deste stage
  //////////////////////////////////
  int get_bigger_time ()
  {
    int retorno = -1;
    for (int i = 0; i < btns.size(); i++) //para cada botao
    {
      Button b = (Button) btns.get(i);
      if (b.state == State.PLAYING && b.time > retorno) //se ele esta tocando e possui um time maior que os anteriores
        retorno = b.time; //update
    }
    return retorno; //retorne
  }
  
  boolean block_touch_events()
  {
    return false;
  }
  
}


