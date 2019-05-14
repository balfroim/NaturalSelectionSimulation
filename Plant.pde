class Plant implements Living
{
  private PVector pos;
  private boolean eaten;
  
  Plant(PVector pos)
  {
   this.pos = pos;
   eaten = false;
  }
  
  public float dis(PVector opos)
  {
   return pos.dist(opos);
  }
  
  public PVector pos()
  {
   return new PVector(pos.x, pos.y); 
  }
  
  public void eat()
  {
   eaten = true; 
  }
  
  public boolean isDead()
  {
   return eaten; 
  }
  
  public void display()
  {
    if(!eaten)
    {
      fill(0, 255, 0);
      ellipse(pos.x, pos.y, plantSize, plantSize);
    }
    
  }
  
  public String toString()
  {
    return String.format("<Plant (%.1f;%.1f)>", pos.x, pos.y);
  }
}
