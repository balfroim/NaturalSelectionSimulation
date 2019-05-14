/**
  @overview use to mesure time.
*/
class Timer
{
  private float startFrameTime;
  private float lastFrameTime;
  private float currentFrameTime;
 
  Timer()
  {
   startFrameTime = millis();
   lastFrameTime = 0;
   currentFrameTime = 0;
  }
  
  public void update()
  {
    lastFrameTime = currentFrameTime;
    currentFrameTime = millis();
  }
  
  public void restart()
  {
    startFrameTime = millis();
    lastFrameTime = 0;
    currentFrameTime = 0;
  }
  
  /**
    @return the time since the (re)start of the Timer.
  */
  public float giveTime()
  {
   return currentFrameTime - startFrameTime; 
  }
  
  /**
    @return the time between the current frame and the last one.
  */
  public float deltaTime()
  {
   return currentFrameTime - lastFrameTime;
  }
}
