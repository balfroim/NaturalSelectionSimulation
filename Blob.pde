/**
  @overview a creature that can live, eat and reproduce.
*/
class Blob implements Living, Comparable
{
  private PVector pos;
  private PVector dir;
  private final Genotype genotype;
  private boolean dead;
  // If true the blobs try to reach the target point, otherwise it avoid it.
  private boolean chase;
  private int eatCount;
  private Living target;
  // Position of the screen's center, use as a target when the blobs doesn't find any.
  private final PVector center;
  
  //-------------------------------------------------------------------------------------------------
  //------------------------------------------ CONSTRUCTOR ------------------------------------------
  //-------------------------------------------------------------------------------------------------
  
  Blob(PVector position, Genotype genotype)
  {
    this.pos = position;
    this.genotype = genotype;
    dead = false;
    chase = false;
    eatCount = 0;
    center = new PVector(width / 2, height / 2);
    dir = PVector.sub(center, pos).normalize();
  }
  
  //------------------------------------------------------------------------------------------------
  //------------------------------------------ PHENOTYPES ------------------------------------------
  //------------------------------------------------------------------------------------------------
  
  /**
    @return the blob's speed (in px/s).
  */
  public float getSpeed()
  {
    return genotype.getAllele(0) * 100;
  }
  
  /**
    @return the blob's size (in px).
  */
  public float getSize()
  {
   return genotype.getAllele(1) * 10 + 10;
  }
  
  /**
    @return the blob's sense.
  */
  public float getSense()
  {
   return genotype.getAllele(2) * 256;
  }
  
  //----------------------------------------------------------------------------------------------------------
  //------------------------------------------ LIVING INTERFACE ----------------------------------------------
  //----------------------------------------------------------------------------------------------------------
  
  /**
    @return the distance between this and the other position.
  */
  public float dis(PVector opos)
  {
   return pos.dist(opos);
  }
  
  /**
    @return a copy of the position
  */
  public PVector pos()
  {
   return new PVector(pos.x, pos.y); 
  }
  
  public void eat()
  {
    println("aaargh");
    dead = true;
  }
  
  public boolean isDead()
  {
   return dead; 
  }
  
  //--------------------------------------------------------------------------------------------------------------
  //------------------------------------------ COMPARABLE INTERFACE ----------------------------------------------
  //--------------------------------------------------------------------------------------------------------------
  
  /**
    @requires o is an instance of Blob
  */
  public int compareTo(Object o)
  {
    return ( (Float)fitness() ).compareTo( ( (Blob)o ).fitness());
  }
  
  //-------------------------------------------------------------------------------------------------
  //------------------------------------------ DISPLAY ----------------------------------------------
  //-------------------------------------------------------------------------------------------------
  
  public void display()
  {
    if(!dead)
    {
      if(DEBUG)
      {
        // Show the sight.
        noFill();
        stroke(255, 0, 0);
        circle(pos.x, pos.y, getSense() * 2);
      }
      
      stroke(0, 0, 0);
      fill(0);
      circle(pos.x, pos.y, getSize());
    }
    
  }
  
  private void move()
  {
    // Aim the target or the screen's center if there is no target.
    if(target != null)
      dir = (chase) ? PVector.sub(target.pos(), pos).normalize() : PVector.sub(pos, target.pos()).normalize();
    else
      dir = PVector.sub(center, pos).normalize();
    
    // Move the blob in the choosen direction
    dir.mult(getSpeed() * TIME.deltaTime() / 1000);
    pos.add(dir);
    // Clamp the position between the edges
    float halfSize = getSize() / 2;
    pos.x = min(max(pos.x, halfSize), width - halfSize);
    pos.y = min(max(pos.y, 32 + halfSize), height - halfSize);
    
  }
  
  public void update()
  {
    if(!dead)
    {
      // Try to find the closest living target.
      Iterator<Blob> alives = generations.get(currentGen).getLivingBlobs();
      while(alives.hasNext())
      {
        Blob b  = alives.next();
        boolean notMe = b != this;
        boolean withinSight = dis(b.pos()) <= getSense();
        boolean closerTarget = (target == null || dis(target.pos()) > dis(b.pos()));
        
        if(notMe && withinSight && closerTarget)
        {
            target = b;
            chase = (b.getSize() <= getSize()) ? true : false;
        }
      }
      for(Plant p : plants)
      {
        boolean notAlreadyEaten = !p.isDead();
        boolean withinSight = dis(p.pos()) <= getSense();
        boolean closerTarget = (target == null || dis(target.pos()) > dis(p.pos()));
        
        if(notAlreadyEaten && withinSight && closerTarget)
        {
          target = p;
          chase = true;
        }
      }
      
      // Move toward the target
      move();
      
      // When the target is reached eat it.
      if(target != null && chase && dis(target.pos()) <= getSize() / 2)
      {
        target.eat();
        target = null;
        eatCount++;
      }
    }
  }
  
  public String toString()
  {
    return "<Blob " 
           + String.format("(%.1f;%.1f)", pos.x, pos.y)
           + ": " + genotype + ">";
  }
  
  /**
     fitness = speed ^ 3 * size ^ 2 + sense
     @return the fitness score of this blob.
  */
  public float fitness()
  {
   float cubeSpeed = genotype.getAllele(0) * genotype.getAllele(0) * genotype.getAllele(0);
   float squareSize = genotype.getAllele(1) * genotype.getAllele(1);
   float sense = genotype.getAllele(2);
   float energy = cubeSpeed * squareSize + sense;
   float log2EatCount = log(eatCount+1) / log(2);
   return log2EatCount - energy;
  }
  
  public Genotype getGenotype()
  {
    return genotype;
  }
  
  public int getEatCount()
  {
   return eatCount; 
  }
  
  public Blob clone()
  {
    Genotype newGenotype = genotype.clone();
    float halfSize = getSize() / 2;
    PVector newPos = rdmPos(halfSize);
    return new Blob(newPos, newGenotype);
  }
  
  public Blob mutate()
  {
    Genotype newGenotype = genotype.mutate();
    float halfSize = getSize() / 2;
    PVector newPos = rdmPos(halfSize);
    return new Blob(newPos, newGenotype);
  }
}

interface Living
{
  public PVector pos();
  public float dis(PVector opos);
  public void eat();
  public boolean isDead();
}