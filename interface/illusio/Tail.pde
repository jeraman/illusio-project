
class Tail
{
  //variaveis
  ArrayList points;
  boolean   removed;
  int   id;
  
  //construtor
  public Tail (int id)
  {
    this.points = new ArrayList();
    this.id = id;
    removed = false;
  }
  
  //draw
  void draw()
  {
    Point2D last = new Point2D(0, 0);  
    
    for (int i = 0; i < points.size(); i++)
    {
      color c = color(255, 0, 0);//, map(i, 0, points.size(), 0, 100));
      float thin = map(i, 0, points.size(), 20, 0);
      strokeWeight(25 - thin);
      stroke(c);
      Point2D p = (Point2D) points.get(i);
      if (i > 0)
        line(p.x, p.y, last.x, last.y);
      last = p;
    }
    
    this.pop();  
  }
  
  void remove ()
  {
    removed = true;
  }
  
  boolean finished ()
  {
    return (removed && points.size() == 0);
  }
  
  void push (int x, int y)
  {
    if (points.size() > 30)
      points.remove(0);
    points.add(new Point2D(x, y));
  }
 
  void pop ()
  {
    if (removed && points.size() > 0)
      points.remove(0); 
  }
}
