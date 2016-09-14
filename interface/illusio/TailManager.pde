  
class TailManager
{
  Vector tails;
  
  public TailManager()
  {
    tails = new Vector();
  }
  
  
  void draw()
  {
    for (int i = 0 ; i < tails.size(); i++)
    {
      Tail t = (Tail) tails.get(i);
      t.draw();
      if (t.finished())
        tails.remove(i);
    }  
  }
  
  void createTail (int id, int x, int y)
  {
    tails.add(new Tail(id));
  }
  
  void removeTail (int id)
  {
    int i = this.searchTail(id);
    if (i!=-1)
    {
      Tail t = (Tail) tails.get(i);
      t.remove();
    }
  }
  
  void updateTail (int id, int x, int y)
  {
    int i = this.searchTail(id);
    if (i!=-1)
    {
      Tail t = (Tail) tails.get(i);
      t.push(x, y);
    }  
}
  
  int searchTail(int id)
  {
    int retorno = -1;
    for (int i = 0 ; i < tails.size(); i++)
    {
      Tail t = (Tail) tails.get(i);
      if (t.id == id)
        retorno = i;
    }
    return retorno;  
  }
}
