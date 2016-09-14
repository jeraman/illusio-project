
//classe que armazena um evento de dedo!
class FingerCursor
{
  int x;
  int y;
  int id;
  
  //construtor
  public FingerCursor(int id, int x, int y)
  {
    this.x = x;
    this.y = y;
    this.id = id;
  }
  
  //metodo chamado para atualizar a posicao do dedo...
  void update (int x, int y)
  {
    this.x = x;
    this.y = y;
  }
  
  float subtract (FingerCursor f)
  {
    return (sqrt(pow((x -f.x),2) + pow((y -f.y),2))) ;
  }
}
