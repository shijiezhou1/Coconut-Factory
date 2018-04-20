// Learning Processing
// Reference Author: Daniel Shiffman
// http://www.learningprocessing.com
// Exercise 10-4: The raindrop catching game
import processing.sound.*;
//import all the stuffs from the import package
import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;

///////////////////////////////sound //////
//reference from nature relax music

SoundFile file;
SoundFile backgroundsong; 

Catcher catcher;    // One catcher object
Catcher catcher2;
Catcher catcher3;
Catcher catcher4;

Mouse catcher5;   // cathcer 5 and 6 are the mouse 
Mouse catcher6;   // cathcer 5 and 6 are the mouse 

Timer timer;        // One timer object
Drop[] drops;       // An array of drop objects
int totalDrops = 0; // totalDrops

// A boolean to let us know if the game is over
boolean gameOver = false;

// A boolean to keep track the how long the button is being press
boolean wasButtonPressed = false;
boolean waterhit = false;
int lastTimeButtonPressed = 0; 
boolean buttonPressed; 

// Variables to keep track of score, level, lives left
int score = 0;      // User's score
int level = 1;      // What level are we on
int lives = 10;     // 10 lives per level (10 raindrops can hit the bottom)
int levelCounter = 0;  //Keep track of the level of the game 

int cupx = 0; 
int cupx2 = 0;
int cupx3 = 0;
int cupx4 = 0;
int cupx5 = 0;
int cupx6 = 0;

/////////////////// coconut image x and y/////////////////
float cocox = 0;
float cocoy = 0;
float ww = 0; 
float hh = 0;
//////////////////////////////////////////////////////////

//////////////////////cups image /////////////////////

PFont f;
PImage cups; 
PImage coconutbackground; 
PImage midco0, midco1, midco2, midco3;
PImage mouse1, mouse2;

int shift = 0;
int pin7 = 7;
Arduino arduino;
int mySwitch = 2; //switch at pin2
Info newinfor = new Info();


float r ;
int rr;
int rrr;
int rrrr;
int rrrrr;


void setup() {
  size(800, 600);
  //fullScreen();
 
  ww = 100;
  hh = 100;

  //println(Arduino.list());
  //String arduinoUSBDeviceName = "/dev/cu.usbmodem14131";
  arduino = new Arduino(this, Arduino.list()[1], 57600);
  arduino.pinMode(mySwitch, Arduino.INPUT);
  arduino.pinMode(pin7, Arduino.OUTPUT);

  catcher6 = new Mouse(32);   //create the catcher6
  catcher5 = new Mouse(32);   //create the catcher5
  catcher4 = new Catcher(32);  //create the catcher4 with a radius of 32
  catcher3 = new Catcher(32);  //create the catcher3 with a radius of 32
  catcher2 = new Catcher(32);  //create the catcher2 with a radius of 32
  catcher = new Catcher(32);   // Create the catcher with a radius of 32
  drops = new Drop[30];        // Create 50 spots in the array (each level now just has 25 drops)
  timer = new Timer(500);      // Create a timer that goes off every 300 milliseconds
  timer.start();               // Starting the timer

  f = createFont("ArialHebrew-Bold", 12, true); // A font to write text on the screen
  cups = loadImage("Mike.png");
  coconutbackground = loadImage("machineline.png");
  //coconutbackground = loadImage("snow.jpg");
  coconutbackground.resize(width, height); //resize before you update image 

  mouse1 = loadImage("no jump copy.png");
  mouse2 = loadImage("jump copy.png");

  midco0 = loadImage("coco0.png");
  midco1 = loadImage("coco1.png");
  midco2 = loadImage("coco2.png");
  midco3 = loadImage("coco3.png");

  ///////////////////////////
  font = createFont("Serif", 50);
  ///////////////////////////

  ///////////////////////////////
  lastTimeButtonPressed = millis();
  arduino.digitalWrite(pin7, Arduino.LOW);

  cocox = width/2 - ww/2;
  cocoy = 0;
  ///////////////////////////////
  backgroundsong = new SoundFile(this, "backgroundsong.mp3");
  backgroundsong.play();
  ///////////////////////////////

  r = (int)random(4, 6); //4 or 5
  //println(r);
  if (r == 4) {
    rr = 300;
    rrr = 400;
    rrrr = 200;
    rrrrr = 100;
  } else if (r == 5) {
    rr = 400;
    rrr = 300;
    rrrr = 100;
    rrrrr = 200;
  }
}

void draw() {
  //////////////////////////////////coconut image change base on the water drops

  background(coconutbackground); 

  //information would disppear at 10 seconds 
  if (millis() < 10000) {
    newinfor.info();
  }

  if (cupx == width) {
    cupx = 0; //reset the position
  }

  cupx5 = cupx + (-1) *100;
  cupx = cupx + 2; 
  cupx2 = cupx + 100;
  cupx3 = cupx + 200;
  //cupx4 = cupx + 300;
  //cupx6 = cupx + 400;

  cupx4 = cupx + rr;
  cupx6 = cupx + rrr;

  // If the game is over
  if (gameOver) {
    textFont(f, 70);
    textAlign(CENTER);
    fill(239, 94, 51);
    text("GAME OVER!", width/2, height/2);
    arduino.digitalWrite(pin7, Arduino.LOW);
  } else {

    // Set catcher location
    catcher.setLocation(cupx, height-30); 
    catcher2.setLocation(cupx2, height-30);
    catcher3.setLocation(cupx3, height-30);
    catcher4.setLocation(cupx4, height-30);
    catcher5.setLocation(cupx5, height-30);
    catcher6.setLocation(cupx6, height-30);

    // Display the catcher
    catcher.display(); 
    catcher2.display();
    catcher3.display();
    catcher4.display();
    catcher5.display();
    catcher6.display();

    buttonPressed = (arduino.digitalRead(mySwitch)==Arduino.HIGH);

    // Check the timer
    if (buttonPressed == true || keyPressed == true) { //the button is hitted
      arduino.digitalWrite(pin7, Arduino.HIGH);

      // Deal with coconut drops
      // Initialize one drop
      if (wasButtonPressed == false) {

        file = new SoundFile(this, "crack.mp3");
        file.play();


        wasButtonPressed = true; //set to true immediately
        if (totalDrops < drops.length) {
          drops[totalDrops] = new Drop();
          // Increment totalDrops
          totalDrops = totalDrops + 1;
        }
        lastTimeButtonPressed = millis(); //update lastTimeButton pressed
      } else {
        if (millis() - lastTimeButtonPressed > 500) { // 500 is the speed each drop generate 


          file = new SoundFile(this, "crack.mp3");
          file.play();


          if (totalDrops < drops.length) {
            drops[totalDrops] = new Drop();
            // Increment totalDrops
            totalDrops = totalDrops + 1;
          }
          lastTimeButtonPressed = millis(); //update lastTimeButton pressed if the last time with this time is long tha 500 ms
        }
      }
    } else { //the button is not hitted
      wasButtonPressed = false; //set it back to false
      arduino.digitalWrite(pin7, Arduino.LOW);
    }

    // Move and display all drops
    for (int i = 0; i < totalDrops; i++ ) {
      if (!drops[i].finished) {
        drops[i].move();
        drops[i].display();
        if (drops[i].reachedBottom()) {
          levelCounter++;
          drops[i].finished(); 
          // If the drop reaches the bottom a live is lost
          lives--;
          // If lives reach 0 the game is over
          if (lives <= 0) {
            gameOver = true;
            arduino.digitalWrite(pin7, Arduino.LOW);
          }
        } 

        ////////////////all the catcher//////////////////////////////////////
        // Everytime you catch a drop, the score goes up
        if (catcher.intersect(drops[i])) {
          drops[i].finished();
          levelCounter++;
          score++;
        }

        // Everytime you catch2 another drop, the score goes up
        if (catcher2.intersect(drops[i])) {
          drops[i].finished();
          levelCounter++;
          score++;
        }

        // Everytime you catch3 another drop, the score goes up
        if (catcher3.intersect(drops[i])) {
          drops[i].finished();
          levelCounter++;
          score++;
        }

        // Everytime you catch4 another drop, the score goes up
        if (catcher4.intersect(drops[i])) {
          drops[i].finished();
          levelCounter++;
          score++;
        }
        ///////////////////////////////////////////////////////////////

        // Everytime you catcher5 another drop, the score goes up
        if (catcher5.intersect(drops[i])) {
          drops[i].finished();
          levelCounter++;
          score--;
          println(score);
        }

        if (catcher6.intersect(drops[i])) {
          drops[i].finished();
          levelCounter++;
          score--;
        }

        /////////////////////////////////////////////////////
      }
    }
    //println(totalDrops); //

    // If all the drops are done, that level is over!
    if (levelCounter >= drops.length) {
      // Go up a level
      level++;
      // Reset all game elements
      levelCounter = 0;
      lives = 10;
      timer.setTime(constrain(300-level*25, 0, 300));
      totalDrops = 0;
    }

    // Display number of lives left
    int morex = 10;
    int morey = 10;
    textFont(f, 24);
    fill(165, 121, 100);
    text("LIVES LEFT: " + lives, 20+morex, 30+morey);
    rect(20+morex, 34+morey, lives*10, 10);

    text("LEVEL: " + level, width-150, 30+morey);
    text("WATER: " + score, width-150, 50+morey);
  }


  switch((totalDrops/10)%4) {
  case 0: 
    image(midco0, cocox, cocoy, ww, hh);
    break;
  case 1:
    image(midco1, cocox, cocoy, ww, hh);
    break;
  case 2:
    image(midco2, cocox, cocoy, ww, hh);
    break;
  case 3:
    image(midco3, cocox, cocoy, ww, hh);
    break;
  }
}
