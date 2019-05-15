/**
  @overview Representation of a genotype.
  @specfield: alleles : float // All the genes values.
  @derivedfield: size : int // The size of the genotype.
  Genotype is immutable.
*/
class Genotype
{
  ArrayList<Float> genes;
  
  /*
    @requires All value must be normalized
  */
  Genotype(ArrayList<Float> genes)
  {
   this.genes = genes;
  }
  
  Genotype(int size)
  {
    genes = new ArrayList<Float>();
   for(int locus = 0; locus < size; locus++)
   {
     genes.add(random(0, 1));
   }
  }
  
  /**
    @return a copy of this genotype.
  */
  public Genotype clone()
  {
   ArrayList<Float> clonedGenes = new ArrayList<Float>();
   Iterator<Float> iterator = genes.iterator();
   while(iterator.hasNext())
   {
    clonedGenes.add(iterator.next()); 
   }
   return new Genotype(clonedGenes); 
  }
  
  /**
    @return a mutated copy of this genotype.
  */
  public Genotype mutate()
  {
   ArrayList<Float> mGenes = new ArrayList<Float>();
   Iterator<Float> iterator = genes.iterator();
   while(iterator.hasNext())
   {
    float mGene = iterator.next() + randomGaussian() * mutationSD;
    mGene = min(max(0, mGene), 1);
    mGenes.add(mGene); 
   }
   return new Genotype(mGenes);
  }
  
  /**
    @return the string representation of this genotype.
  */
  public String toString()
  {
    String toString = "[";
    for (int locus = 0; locus < genes.size() - 1; locus++)
    {
      toString += String.format("%.2f|", genes.get(locus));
    }
   return toString + String.format("%.2f]", genes.get(genes.size() - 1)); 
  }
  
  /**
    @return the size of the genotype.
  */
  public int size()
  {
   return genes.size(); 
  }
  
  public float getAllele(int locus)
  {
   return genes.get(locus); 
  }
  
  public Iterator<Float> alleles()
  {
    return genes.iterator();
  }
  
  
}
