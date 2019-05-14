import java.util.TreeSet;
import java.util.Iterator;
import java.util.HashSet;

ArrayList<Generation> generations;
ArrayList<Plant> plants;


final Timer TIME = new Timer();
final boolean DEBUG = false;
final float genDuration = 10;
final float pauseDuration = 5;
final int nbBlobs = 100;
final int nbPlants = 100;
final int nbBestBlobs = 10;
// Mutation standard deviation
final float mutationSD = 0.05;
final int textSize = 32;
final int plantSize = 8;

boolean pausing = false;
int currentGen = 0;

PVector rdmPos(float halfSize)
{
  float x = random(1) * width;
  x = min(max(halfSize, x), width - halfSize);
  float y = random(1) * height;
  y = min(max(textSize + halfSize, y), height - halfSize);
  return new PVector(x, y);
}

void generatePlants()
{
  plants.clear();
  for(int i = 0; i < nbPlants; i++)
  {
    PVector position = rdmPos(plantSize / 2);// new PVector(random(1) * width, random(1) * (height-32) + 32);
    Plant p = new Plant(position);
    plants.add(p);
  }
}

void setup() 
{
  size(512, 512);
  generations = new ArrayList<Generation>();
  generations.add(new Generation());
  
  plants = new ArrayList<Plant>();
  generatePlants();
}

void draw() 
{
  TIME.update();
  background(255);
  
  if(!pausing)
  {
    if(TIME.giveTime() > genDuration * 1000)
    {
      // Respawn new plants
      generatePlants();
      
      // Next generation
      generations.add(generations.get(currentGen).next());
      
      pausing = true;
      TIME.restart();
    }
    else
    {
      textSize(textSize);
      textAlign(CENTER);
      text(String.format("Generation %d", currentGen), width / 2, textSize);
      
      for(Plant p : plants)
      {
       p.display(); 
      } 
      
      Iterator<Blob> blobs = generations.get(currentGen).getBlobs();
      while(blobs.hasNext())
      {
        Blob b = blobs.next();
        b.update();
        b.display();
      }
    }
  }
  else
  { 
    if (TIME.giveTime() > pauseDuration * 1000)
    {
      pausing = false;
      TIME.restart();
      currentGen++;
    }
    else
    {
      textAlign(CENTER);
      textSize(textSize);
      text(String.format("Summary generation %s", currentGen), width / 2, height / 2);
      textSize(textSize/2);
      Generation gen = generations.get(currentGen);
      text(gen.showWorst(), width / 2, height / 2 + textSize);
      text(gen.showAverage(), width / 2, height / 2 + 3 * textSize / 2);
      text(gen.showBest(), width / 2, height / 2 + 2 * textSize);
      text(gen.showSurvivors(), width / 2, height / 2 + 5 * textSize / 2);
    }
    
  }
  
  
  
  
}
