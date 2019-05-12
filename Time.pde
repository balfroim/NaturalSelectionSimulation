class Time
{
  private float lastFrameTime;
  private float currentFrameTime;
 
  Time()
  {
   lastFrameTime = 0;
   currentFrameTime = 0;
  }
  
  public void update()
  {
    lastFrameTime = currentFrameTime;
    currentFrameTime = millis();
  }

  public float deltaTime()
  {
   return currentFrameTime - lastFrameTime;
  }
}
