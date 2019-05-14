class Generation
{
  ArrayList<Blob> blobs;
  final float avgSpeed;
  final float avgSize;
  final float avgSense;
  
  Generation()
  {
    this.blobs = new ArrayList<Blob>();
    float sumSpeed = 0;
    float sumSize = 0;
    float sumSense = 0;
    for(int i = 0; i < nbBlobs; i++)
    {
      // Create a new Blob
      Genotype genotype = new Genotype(3);
      PVector position = rdmPos(genotype.getAllele(0) * 100); //new PVector(random(width), random(32, height));
      Blob b = new Blob(position, genotype);
      blobs.add(b);
      
      sumSpeed += genotype.getAllele(0);
      sumSize += genotype.getAllele(1);
      sumSense += genotype.getAllele(2);
    }
    
    avgSpeed = sumSpeed / nbBlobs;
    avgSize = sumSize / nbBlobs;
    avgSense = sumSense / nbBlobs;
  }
  
  Generation(ArrayList<Blob> blobs)
  {
    this.blobs = blobs;
    float sumSpeed = 0;
    float sumSize = 0;
    float sumSense = 0;
    for(Blob b : blobs)
    {
      Genotype genotype =  b.getGenotype();
      sumSpeed += genotype.getAllele(0);
      sumSize += genotype.getAllele(1);
      sumSense += genotype.getAllele(2);
    }
    avgSpeed = sumSpeed / nbBlobs;
    avgSize = sumSize / nbBlobs;
    avgSense = sumSense / nbBlobs;
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
  public TreeSet<Blob> bestof(int bestof)
  {
    TreeSet<Blob> bestBlobs = new TreeSet<Blob>();
    
    for(Blob b : blobs)
    {
     if(!b.isDead() && b.getEatCount() > 2)
     {
       if(bestBlobs.size() < bestof)
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
    }
    return bestBlobs;
  }
  
  /**
    @return the next generation based on the best genes of the previous generation.
  */
  public Generation next()
  {
    ArrayList<Blob> nextPopulation = new ArrayList<Blob>();
    Iterator<Blob> survivors = getLivingBlobs();
    while(survivors.hasNext())
    {
     Blob b = survivors.next();
     // The blobs that eat at least one piece of food survived.
     if(b.getEatCount() >= 1)
       nextPopulation.add(b.clone());
     
     // The blobs that eat at least two pieces replicate.
     for(int i = 0; i < b.getEatCount() - 1;i++)
       nextPopulation.add(b.mutate());
    }
   
    return new Generation(nextPopulation); //<>//
  }
  
  private String avgGenotype()
  {
   return String.format("[%.2f|%.2f|%.2f]", avgSpeed, avgSize, avgSense); 
  }
  
  public String showAverage()
  {
    float sumFitness = 0;
    for(Blob b : blobs)
    {
      sumFitness += b.fitness();
    }
    return String.format("Average fitness = %.2f --> %s", sumFitness / nbBlobs, avgGenotype());
  }
  
  public String showBest()
  {
    float bestFitness = 0;
    Genotype bestGenotype = null;
    for(Blob b : blobs)
    {
      if(b.fitness() > bestFitness)
      {
         bestFitness = b.fitness();
         bestGenotype = b.getGenotype();
      }
    }
    return String.format("Best fitness = %.2f --> %s", bestFitness, bestGenotype);
  }
  
  public String showWorst()
  {
    float worstFitness = 10000000000.0;
    Genotype worstGenotype = null;
    for(Blob b : blobs)
    {
      if(b.fitness() < worstFitness)
      {
        worstFitness = b.fitness();
        worstGenotype = b.getGenotype();
      }
       
    }
    return String.format("Worst fitness = %.2f --> %s", worstFitness, worstGenotype);
    
  }
  
  public String showSurvivors()
  {
   int countSurvivor = 0;
   for(Blob b : blobs)
   {
    if(!b.isDead() && b.getEatCount() >= 1)
       countSurvivor++;
   }
   return String.format("%d survived the next day out of %d", countSurvivor, blobs.size());
  }
  
  
}
