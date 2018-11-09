// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

// Exercise 10-4: The raindrop catching game

class Drop {
  float x, y;   // Variables for location of raindrop
  float speed;  // Speed of raindrop
  color c;
  float r;      // Radius of raindrop

  // New variable to keep track of whether drop is still being used
  boolean finished = false;

  Drop() {
    int easylevel = 1;
    int middlelevel = 5; 
    int difficultlevel = 10;

    if ((millis() / 1000 )%2 == 0 ) {
      //even
      shift = 3;
    } else {
      //odd 
      shift = -3;
    }

    r = 8;                   // All water drops are the same size
    x = width/2 + shift;       // Start with a middle of the x location
    y = -r*4;                // Start a little above the window
    //speed = random(2, 5);    // Pick a random speed
    speed = middlelevel + 1 * level;       // choose easylevel/middlelevel/difficultlevel
    c = color(51, 173, 255);     // Water's Color
  }

  // Move the raindrop down
  void move() {
    // Increment by speed
    y += speed;
  }

  // Check if it hits the bottom
  boolean reachedBottom() {
    // If we go a little beyond the bottom
    if (y > height + r*4) { 
      return true;
    } else {
      return false;
    }
  }

  // Display the raindrop
  void display() {
    // Display the drop
    fill(c);
    noStroke();
    for (int i = 2; i < r; i++) {
      ellipse(x, y - r*4 + random(0, 5) + i*4 + random(0, 5), i*2, i*2);
    }
  }

  // If the drop is caught
  void finished() {
    finished = true;
  }
}