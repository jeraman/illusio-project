
int selection  = 0;
int counter_id = 0;


class Button 
{ 
  Stage interno; //stage dentro deste botao
  Vector points; //pontos que compoem este botao

  int x, y;
  int width, height;
  int level = 1;
  int time = 5; //tempo em segundos de duração da rotação
  int start, last; //tempo em mls que o programa comecou!

  int id; //id do botao
  
  int cursorID; //id do dedo que criou o botao

  float resize_x, resize_y; //tamanho em proporcao do resize 
  int bigger_x, lower_x, bigger_y, lower_y; //variaveis usadas para calcular o incremento

  boolean completed;
  boolean mockup;
  boolean recorded;
  int selected;

  int time_o;
  int start_o;
  int effect_mode;
  boolean finished_o;
  boolean bang_o;
  
  //boolean recorded;//recording, recorded;
  int  state;
  
  //variaveis para controlar o movimento!
  boolean moving;
  Point2D first_move;
  Vector  fingers;  
  //int     last_finger;
  //float escala = 0;
  
  FingerManager fm;
  
  //////////////////////////////////
  //contrutor para clonar
  //////////////////////////////////
  Button (Button b)
  {
    this.x         = b.x;
    this.y         = b.y;
    this.width     = b.width;
    this.height    = b.height;
    this.completed = b.completed;
    this.points    = b.points;
    this.level     = b.level+1;
    this.cursorID  = b.cursorID;
    this.bigger_x  = b.bigger_x;
    this.lower_x   = b.lower_x;
    this.bigger_y  = b.bigger_y;
    this.lower_y   = b.lower_y;
    this.selected  = b.selected;
    this.completed = b.completed;
    this.mockup    = false;

    this.points = b.points;
    this.time   = b.time;
    this.start  = b.start;
    this.last   = b.start;

    this.resize_x  = b.resize_x;
    this.resize_y  = b.resize_y;

    this.bigger_x  = b.bigger_x; 
    this.lower_x   = b.lower_x; 
    this.bigger_y  = b.bigger_y;
    this.lower_y   = b.lower_y; 

    this.time_o      = b.time_o;
    this.start_o     = b.start_o;
    this.effect_mode = b.effect_mode;
    this.finished_o  = b.finished_o;
    this.bang_o      = b.bang_o;
    
    this.id = b.id;
   
    this.state = b.state; 
    
    this.moving = b.moving;
    this.first_move  = b.first_move;
    this.fm = new FingerManager();
    this.recorded = b.recorded;
    
    if (b.interno instanceof Waveform)
    {
      this.interno   = new Waveform(this, b.interno);
      ((Waveform)interno).samples = ((Waveform)b.interno).samples; 
    }
    else
      this.interno   = new Stage(this.level+1, b.interno) ;
  }


  //////////////////////////////////
  //construtor para o mouse
  //////////////////////////////////
  Button (int x, int y, int level, Stage s)
  {
    this.x = x;
    this.y = y;
    this.completed = false;
    this.points = new Vector();
    this.level = level;
    this.cursorID = -1;

    this.bigger_x = 0;
    this.lower_x  = 0;
    this.bigger_y = 0;
    this.lower_y  = 0;

    // só pra testes!
    this.selected = -1;
    this.mockup = false;

    this.interno = new Stage(this.level+1, s);
    
    this.id = counter_id;
    counter_id = counter_id+1;
    
    //this.recording = false;
    this.state = State.READY; 
    //this.recorded = false;
    
    this.moving = false;
    this.first_move = new Point2D(0, 0);
    //this.last_finger = -1;
    //this.fingers = new Vector();
    this.fm = new FingerManager();
    this.recorded = false;
  }

  //////////////////////////////////
  //construtor para o multitoque
  //////////////////////////////////
  Button (int x, int y, int level, int id, Stage s)
  {
    this.x = x;
    this.y = y;
    this.completed = false;
    this.points = new Vector();
    this.level = level;
    this.cursorID = id;

    this.bigger_x = 0;
    this.lower_x  = 0;
    this.bigger_y = 0;
    this.lower_y  = 0;

    this.selected = -1;
    this.mockup = false;

    this.interno = new Stage(this.level+1, s);
    
    this.id = counter_id;
    counter_id = counter_id+1;
    
    //this.recording = false;
    this.state = State.READY; 
    //this.recorded = false;
    
    this.moving = false;
    this.first_move = new Point2D(0, 0);
    //this.fingers = new Vector();
    this.fm = new FingerManager();
    //this.last_finger = -1;
    this.recorded = false;
  }


  //////////////////////////////////
  //adiciona o ponto de maneira normalizada!
  //////////////////////////////////
  void add_point(int x, int y)
  {

    Point2D p = new Point2D(x - this.x, y - this.y);

    if (this.bigger_x < p.x)
      this.bigger_x = p.x;
    if (this.lower_x > p.x)
      this.lower_x = p.x;

    if (this.bigger_y < p.y)
      this.bigger_y = p.y;
    if (this.lower_y > p.y)
      this.lower_y = p.y;  

    this.points.add(p);
  }  

  //////////////////////////////////
  //calula o tamanho do botao!
  //////////////////////////////////
  void calculate_size()
  {
    this.width = this.bigger_x - this.lower_x;
    this.height = this.bigger_y - this.lower_y;
  }

  //////////////////////////////////
  //ativa o botão depois de pronto!
  ////////////////////////////////// 
  void ativate ()
  {
      //adiciona o primeiro ponto na última posição
      Point2D f = (Point2D) this.points.get(0);
      this.points.add(f);
      this.completed = true;
      this.calculate_size();
  }

  //////////////////////////////////
  //move um botão!
  ////////////////////////////////// 
  void move (int x, int y)
  {
    if (this.moving)
    {
      int dif_x = x - this.first_move.x;
      int dif_y = y - this.first_move.y;
      this.x += dif_x;// - (width/2);
      this.y += dif_y;// - (height/2);
      this.first_move.set(x, y);
    }  
  }
  //////////////////////////////////
  //funcao auxiliar para remover dedo do botao!
  //////////////////////////////////
  void remove_finger (int id)
  {
    fm.remove_finger(id);
    if (fm.fingers.size() == 1)
      this.moving = true;
  }


  //////////////////////////////////
  //seleciona o botao!
  //////////////////////////////////
  void select (int x, int y, int id) 
  {
    if (this.selected == -1)
    {
      this.moving = true;
      this.selected = selection;
      selection = selection + 1;
      this.first_move.set(x, y);
      fm.add_finger(id, x, y);
      //println(this.id + " moving and selected " + this.selected);
    } else
    
    {
      if (!fm.contains_finger(id)) //se um outro dedo tenta movê-lo!
      {
        fm.add_finger(id, x, y); //adicione ele na lista de dedos em cima do botao 
        this.moving = false;
      }
    }
  }  

  //////////////////////////////////
  //deseleciona o botao!
  //////////////////////////////////  
  void unselect () 
  {
    if (this.selected != -1)
    {
      this.moving = false;
      this.selected = -1;
      selection = selection - 1;
      this.first_move.set(0, 0);
      fm.reinit();
      //this.reinit_last_finger();
      //println(this.id + " not moving and selected " + this.selected);
    }
  }

  //////////////////////////////////
  //retorna stage interno de um botao
  //////////////////////////////////
  Stage get_stage()
  {
    return this.interno;
  }

  //////////////////////////////////
  //desenha um botao!
  //////////////////////////////////
  void draw()
  {
    if (this.completed) draw_button();
    else                pre_draw();
  }

  //////////////////////////////////
  //desenha um botao antes dele ser concluido!
  //////////////////////////////////
  void pre_draw()
  {
    pushMatrix();
    stroke(100);
    noFill();
    beginShape();
    translate(this.x, this.y);
    pushMatrix();
    for (int i = 0; i< this.points.size(); i++)
    {
      Point2D temp = (Point2D) this.points.get(i);
      vertex(temp.x, temp.y);
    }
    popMatrix();
    endShape();
    popMatrix();
  }


  //////////////////////////////////
  //metodo que desenha um botao
  //////////////////////////////////
  void draw_button()
  {
    draw_levels();
    draw_shape();
    draw_metro();

    if (this.bang_o && this.finished_o)
    {
      this.bang_o = false;
    }
  }

  //////////////////////////////////
  //desenha as camadas externas a depender do nível do cara!
  //////////////////////////////////
  void draw_levels ()
  {
    float rx, ry, offx, offy;
    int tlevel = level;
    Point2D temp = null;

    if (selected != -1)
      tlevel++;

    for (int j = tlevel; j > 0; j = j - 1)
    {
      rx = pow(this.resize_x, (2*j));//(float)(this.width+(20*j))/this.width;
      ry = pow(this.resize_y, (2*j));//(float)(this.height+(20*j))/this.height;

      offx = 0;
      if (abs(this.bigger_x) > abs(this.lower_x))
      {
        float nbx = this.bigger_x * rx;
        offx = (nbx - this.bigger_x)/2;
      }
      else
      {
        float nlx = this.lower_x * rx;
        offx = (nlx - this.lower_x)/2;
      }

      offy = 0;
      if (abs(this.bigger_y) > abs(this.lower_y))
      {
        float nby = this.bigger_y * ry;
        offy = (nby - this.bigger_y)/2;
      }
      else
      {
        float nly = this.lower_y * ry;
        offy = (nly - this.lower_y)/2;
      }

      pushMatrix();
      if (edit_mode)
      {
        fill(255);
        stroke(0);
      } else
      {
        fill(0);
        stroke(255);
      }
      strokeWeight(10);
      beginShape();
      translate(this.x-offx, y-offy);

      scale(rx, ry);
      pushMatrix();
      
      
      for (int i = 0; i< this.points.size(); i++)
      {
         Point2D p = (Point2D) this.points.get(i);
         vertex(p.x, p.y);
      }
      
      popMatrix();
      endShape(); 
      popMatrix();
    }
  }


  //////////////////////////////////
  //desenha o formato básico!
  //////////////////////////////////
  void draw_shape()
  {
    pushMatrix();
    this.resize_x = (float)(this.width+(20))/this.width;
    this.resize_y = (float)(this.height+(20))/this.height;

    noStroke();    
    if (edit_mode)
    {
      if (this.mockup)
      {
        fill(255);
        stroke(0);
        strokeWeight(10);
      }
      else
        fill(0);
    } 
    
    else
    {
      if (this.mockup)
      {
        fill(0);
        stroke(255);
        strokeWeight(10);
      }
      else
        fill(255);
    }
  
    beginShape();  
     
    translate(this.x, this.y);
    pushMatrix();
    for (int i = 0; i< this.points.size(); i++)
    {
      Point2D p = (Point2D) this.points.get(i);
      vertex(p.x, p.y);
    }
    popMatrix();
    endShape();

    popMatrix();
  }
  
  
  //////////////////////////////////
  //desenha o metronomo do loop 
  //////////////////////////////////
  int a = 0;
  void draw_metro()
  {  
    int tx = this.lower_x + (this.width/2);
    int ty = this.lower_y + (this.height/2);
    
    /*
    if (this.mockup)
    {
      int qtd = this.interno.how_many_plays();
      if (qtd == 0)
        this.state = State.STOPED;
      else //vendo se vai funcionar!!!!
      {
        time = this.interno.get_bigger_time();
        state = State.PLAYING;
      }
    } 
    */
    update_mockup_status();

    if (state == State.RECORDING) //se o botao está gravando
    {
       last = millis();
       time = last-start;
       //println("t " + time);
    }
    
    if (state == State.STOPED) //se o botao está parado
    {  
       if (edit_mode)
       {
         if (this.mockup)
           fill(0);
         else 
           fill(255);  
       }
       else
       {
         if (this.mockup)
           fill(255);
         else 
           fill(0);
       }
       noStroke(); 
       ellipse(this.x+tx, this.y+ty, 30, 30);
    }
    
    if (state == State.PLAYING) //se o botao está tocando
    {
      int lmt = time;
      if (time != first_time)  
        lmt += (first_time-(time%first_time)); 
      
      if (last-start <= lmt)
        last = millis();
      else
        start = millis();
       
      float i = map ((float)(last-start), 0, lmt, 0, 360);

      if (edit_mode)
      {
        if (this.mockup)
          stroke(0);
        else
          stroke(255);
      }
      
      else
      {
        if (this.mockup)
          stroke(255);
        else
          stroke(0);        
      }
      
      strokeWeight(20);
      pushMatrix();
      translate(this.x+tx, this.y+ty);
      //aqui vai mudar!
      line(0, 0, ((100/2)*cos(radians(i-90))), ((100/2)*sin(radians(i-90))));
      popMatrix();
    }
  }

  //////////////////////////////////
  // hit test para colisoes
  //////////////////////////////////

  boolean hit_test(int x, int y)
  {
    if (!this.completed)
      return false;

    int counter = 0;
    double xinters;
    Point2D p1,p2;
    Point2D p = new Point2D(x - this.x, y - this.y);

    p1 = (Point2D) this.points.get(0);
    for (int i=1; i < this.points.size(); i++)
    {
      p2 = (Point2D) this.points.get(i % this.points.size());
      if (p.y > min(p1.y,p2.y)) {
        if (p.y <= max(p1.y,p2.y)) {
          if (p.x <= max(p1.x,p2.x)) {
            if (p1.y != p2.y) {
              xinters = (p.y-p1.y)*(p2.x-p1.x)/(p2.y-p1.y)+p1.x;
              if (p1.x == p2.x || p.x <= xinters)
                counter++;
            }
          }
        }
      }
      p1 = p2;
    }

    if (counter % 2 == 0)
      return false;
    else
      return true;
    
  }

  //////////////////////////////////
  // limpa um botao
  //////////////////////////////////
  void clear ()
  {
    this.points.clear();
  }


  //////////////////////////////////
  //começar a desenhar abrindo um stage
  //////////////////////////////////
  void open()
  {
    this.bang_o = true;
    this.finished_o = false;
    this.start_o = millis();
    this.effect_mode = 0;
  }

  //////////////////////////////////
  //começar a desenhar fechando um stage
  //////////////////////////////////
  void close()
  {
    this.bang_o = true;
    this.finished_o = false;
    this.start_o = millis();
    this.effect_mode = 1;
  }

  //////////////////////////////////
  //desenhar abrindo/fechando um stage
  //////////////////////////////////
  void draw_animation()
  {
    if (!this.finished_o)
    {
      int last_o = millis();

      if (last_o - start_o >= 500)
        this.finished_o = true;
      
      float i = 0;
      if (effect_mode == 0)
        i = map ((float)(last_o-start_o), 0, 500, 0, 150);
      if (effect_mode == 1)
        i = map ((float)(last_o-start_o), 0, 500, 150, 0);

      //println(i);
      pushMatrix();
      int tx = this.lower_x + (this.width/2);
      int ty = this.lower_y + (this.height/2);
      translate(this.x+tx, this.y+ty);//+ (this.width/2), this.y + (this.height/2));
      strokeWeight(1);
      if (edit_mode)
      {
        stroke(0);
        fill(255);
      }
      else
      {
        stroke(255);
        fill(0);
      }
      //println();
      scale(i, i);
      pushMatrix();
      ellipse(0, 0, 10, 10);
      popMatrix();
      popMatrix();
    }
  }

  //////////////////////////////////
  // incoorporar outro botao dentro deste
  //////////////////////////////////
  void aglomerar (Button b)
  {
    if(!this.mockup)
    {
      Button clone = new Button(this);
      this.interno.add_btn(clone);
      this.mockup = true;
    }
    b.level = b.level + 1;
    b.interno.up = this.interno;
    this.interno.add_btn(b);
  }
  
  
    
  //////////////////////////////////
  //grava um loop para este botao
  //////////////////////////////////
  void record()
  {
    if (this.mockup) //não consigo gravar em mockups
      return;
      
    if (state == State.PLAYING)
      this.stop();
    
    if (state == State.STOPED || state == State.READY )
      state = State.RECORDING;
    else if (state == State.RECORDING)
    {
      state = State.PLAYING;
      recorded = true;
      interno = new Waveform(this, atual);
    } 
    //recording = !recording;
    start = millis();
    send_record(id);
  }
  
  //////////////////////////////////
  //para de tocar o loop deste botao
  //////////////////////////////////
  void stop()
  {
    state = State.STOPED;
    send_stop(id);
    this.interno.stop();
  }
  
  //////////////////////////////////
  //toca o loop deste botao
  //////////////////////////////////
  void play()
  {
    state = State.PLAYING;
    start = millis();
    send_play(id);
    this.interno.play();
  }
  
  //////////////////////////////////
  //toca o loop deste botao
  //////////////////////////////////
  void play_or_stop()
  {
    println("s: " + state);
    if (state==State.PLAYING)
      this.stop();
      //state = State.STOPED;
    else if (state==State.RECORDING || state==State.STOPED)
      this.play();
      //state = State.PLAYING;
    
    //start = millis();
    //send_play_or_stop(id);
    
    /////////////
    // bug aqui!
    //se o cara der play or stop num mockup!
    //this.interno.play();
    ////////////
  }
  
  //////////////////////////////////
  //apaga o loop deste botao
  //////////////////////////////////
  void erase()
  {
    send_erase(id);
    this.interno.erase();
  }
  
  //////////////////////////////////
  //utiliza se este botao é ou não um mockup
  //////////////////////////////////
  void update_mockup_status ()
  {
    if (this.mockup) //atualizando o metronomo
    {
      int qtd = this.interno.how_many_plays();
      if (qtd == 0)
        this.state = State.STOPED;
      else //vendo se vai funcionar!!!!
      {
        time = this.interno.get_bigger_time();
        if (time != -1)
          state = State.PLAYING;
        else
          state = State.STOPED;
      }
    } 
    
    if (this.interno.size()> 0) //atualizando se é mockup
      this.mockup = true;
    else
      this.mockup = false;
  }
  
  
}


