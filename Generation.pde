class Generation
{
  ArrayList<Blob> blobs;
  final int size;
  final float avgSpeed;
  final float avgSize;
  final float avgSense;
  Genotype worstGenotype;
  Genotype bestGenotype;
  
  Generation(int size)
  {
    this.blobs = new ArrayList<Blob>();
    this.size = size;
    float sumSpeed = 0;
    float sumSize = 0;
    float sumSense = 0;
    for(int i = 0; i < size; i++)
    {
      // Create a new Blob
      Genotype genotype = new Genotype(3);
      PVector position = rdmPos(genotype.getAllele(0) * 50);
      Blob b = new Blob(position, genotype);
      blobs.add(b);
      
      sumSpeed += genotype.getAllele(0);
      sumSize += genotype.getAllele(1);
      sumSense += genotype.getAllele(2);
    }
    
    avgSpeed = sumSpeed / size;
    avgSize = sumSize / size;
    avgSense = sumSense / size;
  }
  
  Generation(ArrayList<Blob> blobs)
  {
    this.blobs = blobs;
    this.size = blobs.size();
    float sumSpeed = 0;
    float sumSize = 0;
    float sumSense = 0;
    for(Blob b : blobs)
    {
      Genotype genotype =  b.getGenotype().clone();
      sumSpeed += genotype.getAllele(0);
      sumSize += genotype.getAllele(1);
      sumSense += genotype.getAllele(2);
    }
    avgSpeed = sumSpeed / size;
    avgSize = sumSize /  size;
    avgSense = sumSense /  size;
  }
  
  /**
    @return an iterator of all the living blobs.
  */
  public Iterator<Blob> getLivingBlobs()
  {
   ArrayList<Blob> livingBlobs = new ArrayList<Blob>();
   for(Blob b : blobs)
   {
    if(!b.isDead())
       livingBlobs.add(b);
   }
   return livingBlobs.iterator(); 
  }
  
  /**
    @return all the blobs of this generation.
  */
  public Iterator<Blob> getBlobs()
  {
   return blobs.iterator(); 
  }
  
  /**
    @return the best blobs of this generation.
  */
  public TreeSet<Blob> bestof(float percentage)
  {
    TreeSet<Blob> bestBlobs = new TreeSet<Blob>();
    Iterator<Blob> livings = getLivingBlobs();
    int count = 0;
    while(livings.hasNext() && count <= size * percentage)
    {
     Blob b = livings.next();
     if(bestBlobs.size() < size * percentage)
         bestBlobs.add(b);
     else
     {
       if(b.compareTo(bestBlobs.first()) == 1)
       {
         bestBlobs.pollFirst();
         bestBlobs.add(b);
       }
     }
    }
  return bestBlobs;
  }
  
  /**
    @return the next generation based on the best genes of the previous generation.
  */
  public Generation nextGeneration()
  {
    ArrayList<Blob> nextPopulation = new ArrayList<Blob>();
    // Take only the top 10%
    TreeSet<Blob> bestBlobs = bestof(0.1);
    for(Blob b : bestBlobs)
    {
     for(int i = 0; i < b.getFoodAmount();i++)
       nextPopulation.add(b.mutate());
    }
 
    return new Generation(nextPopulation);
  }
  
  private String avgGenotype()
  {
   return String.format("[%.2f|%.2f|%.2f]", avgSpeed, avgSize, avgSense); 
  }
  
  public float getAverage()
  {
    float sumFitness = 0;
    for(Blob b : blobs)
    {
      sumFitness += b.fitness();
    }
    return sumFitness / getSize();
  }
  
  public String showAverage(Generation previousGen)
  {
    if(previousGen != null)
    {
      float deltaAverage = getAverage() - previousGen.getAverage();
       return String.format("Average fitness = %.2f (%s) --> %s", getAverage(), DELTAFMT.format(deltaAverage), avgGenotype());
    }
    else
    {
      return String.format("Average fitness = %.2f --> %s", getAverage(), avgGenotype());
    }
  }
  
  public float getBest()
  {
    float bestFitness = 0;
    for(Blob b : blobs)
    {
      if(b.fitness() > bestFitness)
      {
         bestFitness = b.fitness();
         bestGenotype = b.getGenotype();
      }
    }
    return bestFitness;
  }
  
  public String showBest(Generation previousGen)
  {
    float bestFitness = getBest();
    if(previousGen != null)
    {
      float deltaBest = bestFitness - previousGen.getBest(); 
      return String.format("Best fitness = %.2f (%s) --> %s", bestFitness, DELTAFMT.format(deltaBest), bestGenotype);
    }
    else
    {
      return String.format("Best fitness = %.2f --> %s", bestFitness, bestGenotype);
    }
    
  }
  
  public float getWorst()
  {
    float worstFitness = 1000000000000000.0;
    for(Blob b : blobs)
    {
      if(b.fitness() < worstFitness)
      {
        worstFitness = b.fitness();
        worstGenotype = b.getGenotype();
      } 
    }
    return worstFitness;
  }
  
  public String showWorst(Generation previousGen)
  {
    float worstFitness = getWorst();
    if(previousGen != null)
    {
      float deltaBest = worstFitness - previousGen.getWorst(); 
      return String.format("Worst fitness = %.2f (%s) --> %s", worstFitness, DELTAFMT.format(deltaBest), worstGenotype);
    }
    else
    {
      return String.format("Worst fitness = %.2f --> %s", worstFitness, worstGenotype);
    }
    
  }
  
  public String showSurvivors()
  {
   int countSurvivor = 0;
   for(Blob b : blobs)
   {
    if(!b.isDead() && b.getFoodAmount() >= 1)
       countSurvivor++;
   }
   return String.format("%d survived the next day out of %d", countSurvivor, blobs.size());
  }
  
  public int getSize()
  {
   return size; 
  }
  
  
}
