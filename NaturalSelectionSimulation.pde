import java.util.TreeSet;
import java.util.Iterator;
import java.util.HashSet;
import java.util.Random;
import java.text.DecimalFormat;

// List all the generations.
ArrayList<Generation> generations;
// List all the plants.
ArrayList<Plant> plants;
// Use to indicate a pause between two generations.
boolean pausing = false;
// Index of the current generation.
int currentGen = 0;
// Format float to have a + sign when positive and a negative sign when negative.
final DecimalFormat DELTAFMT = new DecimalFormat("+#,##0.00;-#");
// Use to mesure time.
final Timer TIME = new Timer();
// Use to generate randomness.
final Random RANDOM = new Random();
// Use to debug (like drawing a red circle around blobs to see their sight size).
final boolean DEBUG = false;
// The duration of a generation in seconds.
final float genDuration = 10;
// The duration of a pause between two generations in seconds.
final float pauseDuration = 5;
// The initial number of blobs.
final int initBlobsNb = 20;
// The initial number of plants.
final int initPlantsNb = 100;
// Mutation standard deviation
final float mutationSD = 0.05;
final int textSize = 32;
final int plantSize = 8;


/**
  Generate a random position and clamp it between the edges.
*/
PVector rdmPos(float halfSize)
{
  float x = RANDOM.nextFloat() * width;
  x = min(max(halfSize, x), width - halfSize);
  float y = RANDOM.nextFloat() * height;
  y = min(max(textSize + halfSize, y), height - halfSize);
  return new PVector(x, y);
}

void generatePlants()
{
  plants.clear();
  for(int i = 0; i < initPlantsNb; i++)
  {
    PVector position = rdmPos(plantSize / 2);
    Plant p = new Plant(position);
    plants.add(p);
  }
}

void setup() 
{
  size(512, 512);
  generations = new ArrayList<Generation>();
  generations.add(new Generation(initBlobsNb));
  plants = new ArrayList<Plant>();
  generatePlants();
}

void draw() 
{
  TIME.update();
  background(255);
  
  if(!pausing)
  {
    // End of a generation
    if(TIME.giveTime() > genDuration * 1000)
    {
      // Respawn new plants
      generatePlants();
      
      // Next generation
      generations.add(generations.get(currentGen).nextGeneration());
      
      pausing = true;
      TIME.restart();
    }
    // Simulation screen
    else
    {
      // Display the current generation.
      textSize(textSize);
      textAlign(CENTER);
      text(String.format("Generation %d", currentGen), width / 2, textSize);
      
      // Display all the plants.
      for(Plant p : plants)
      {
       p.display(); 
      } 
      
      // Display and update all the blobs.
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
    // End of pause
    if (TIME.giveTime() > pauseDuration * 1000)
    {
      pausing = false;
      TIME.restart();
      currentGen++;
    }
    // Pause screen
    else
    {
      textAlign(CENTER);
      textSize(textSize);
      text(String.format("Summary generation %s", currentGen), width / 2, height / 2);
      textSize(textSize/2);
      Generation previousGen = (currentGen > 0) ? generations.get(currentGen - 1) : null;
      Generation gen = generations.get(currentGen);
      text(gen.showWorst(previousGen), width / 2, height / 2 + textSize);
      text(gen.showAverage(previousGen), width / 2, height / 2 + 3 * textSize / 2);
      text(gen.showBest(previousGen), width / 2, height / 2 + 2 * textSize);
      text(gen.showSurvivors(), width / 2, height / 2 + 5 * textSize / 2);
      Generation nextGen = generations.get(currentGen + 1);
      text(String.format("Next generation: %d blobs", nextGen.getSize()), width / 2, height / 2 + 3 * textSize);
    }
    
  }
  
  
  
  
}
