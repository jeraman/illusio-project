
//////////////////////////////////
// Finder Manager Class //////////
//////////////////////////////////

class FingerManager
{
  //////////////////////////////////
  //variaveis
  //////////////////////////////////
  Vector fingers;
  float  escala;
  
  //////////////////////////////////
  //construtor
  //////////////////////////////////
  public FingerManager ()
  {
    fingers = new Vector();
    escala  = 0;
  }
  
  void reinit() 
  {
    this.fingers.clear();
    escala = 0;
  }
  
  //////////////////////////////////
  //calcula a distância entre os dedos deste botão
  //////////////////////////////////
  float calculate_fingers_distance ()
  {
    float retorno = 0;
    if (fingers.size() > 0)
    {
      FingerCursor f0 = (FingerCursor) fingers.get(0);
      FingerCursor f1 = (FingerCursor) fingers.get(fingers.size()-1);
      retorno = f0.subtract(f1);
      if (escala == 0)
        escala = retorno;
    }
    return retorno;
  }
  
  //////////////////////////////////
  //adiciona um dedo que está dentro deste botao
  //////////////////////////////////
  void add_finger (int id, int x, int y)
  {
    fingers.add(new FingerCursor(id, x, y));
  }
  
  //////////////////////////////////
  //atualiza a posição dos dedos deste botão
  //////////////////////////////////
  void update_finger (int id, int x, int y)
  {
    for (int i = 0; i < this.fingers.size(); i++)
    {
      FingerCursor f = (FingerCursor) fingers.get(i);
      if (f.id == id)
        f.update(x, y);
    }
  }
  
  //////////////////////////////////
  //remove um dedo que está dentro deste botao
  //////////////////////////////////
  void remove_finger (int id)
  {
    for (int i = 0; i < this.fingers.size(); i++)
    {
      FingerCursor f = (FingerCursor) fingers.get(i);
      if (f.id == id)
        fingers.remove(i);
    } 
    
   //if (this.fingers.size() == 1)
   //   this.moving = true;
    
    if (this.fingers.size() <= 1)
      escala = 0;
  }

  //////////////////////////////////
  //verifica se um dedo está dentro deste botao
  //////////////////////////////////
  boolean contains_finger (int id)
  {
    for (int i = 0; i < this.fingers.size(); i++)
    {
      FingerCursor f = (FingerCursor) fingers.get(i);
      if (f.id == id)
        return true;
    } 
    return false;
  } 
  
}
