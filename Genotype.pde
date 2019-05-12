import java.util.Iterator;

/**
  @overview Representing a genotype that can be cloned and mutated.
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
  
  public Genotype mutate(float sd)
  {
   ArrayList<Float> mGenes = new ArrayList<Float>();
   Iterator<Float> iterator = genes.iterator();
   while(iterator.hasNext())
   {
     // Use a gaussian distribution with a mean of 0 and a standard deviation given as a parameter.
    float mGene = iterator.next() + randomGaussian() * sd;
    mGene = min(max(0, mGene), 1);
    mGenes.add(mGene); 
   }
   return new Genotype(mGenes);
  }
  
  public String toString()
  {
    String toString = "[";
    for (int locus = 0; locus < genes.size() - 1; locus++)
    {
      toString += String.format("%.2f|", genes.get(locus));
    }
   return toString + String.format("%.2f]", genes.get(genes.size() - 1)); 
  }
  
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
