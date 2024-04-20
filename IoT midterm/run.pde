import processing.serial.*;
import gifAnimation.*;
import ddf.minim.*;
Minim minim;
AudioPlayer deathSound, hurtSound, touchSound;
PImage[] animation;
PImage leftWall, rightWall, gameStart, gameOver;
Serial myPort;
int aa=2, bb=3, cc;
int val;
float lastY; // Assuming the height of the screen is 675
Gif loopingGif, gpig;
Block b1;
Block b2;
Block b3;
spikeBlock sb;
MovingRightBlock mrBlock;
MovingLeftBlock mlBlock;
BounceBlock bBlock;
initialBlock ib;
player p;
PVector moveVector;
float xSpeed = 0;
ArrayList<Block> locs = new ArrayList<Block>();
boolean gameover = false;
boolean start = false;
float ySpeed = 1.5;
int count = 1;
float hp = 50;

void setup() {
  loopingGif = new Gif(this, "C:/Users/Administrator/Desktop/台科/課程/112-2 IoT/IoT Mid/統神下完樓梯開電燈_M11207509_王佑強/NSSHAFT/player_run.gif");
  loopingGif.loop();
  minim = new Minim(this);
  deathSound = minim.loadFile("C:/Users/Administrator/Desktop/台科/課程/112-2 IoT/IoT Mid/統神下完樓梯開電燈_M11207509_王佑強/NSSHAFT/Audios/death.mp3");
  hurtSound = minim.loadFile("C:/Users/Administrator/Desktop/台科/課程/112-2 IoT/IoT Mid/統神下完樓梯開電燈_M11207509_王佑強/NSSHAFT/Audios/hurt.mp3");
  touchSound = minim.loadFile("C:/Users/Administrator/Desktop/台科/課程/112-2 IoT/IoT Mid/統神下完樓梯開電燈_M11207509_王佑強/NSSHAFT/Audios/touch_normal.mp3");
  leftWall = loadImage("C:/Users/Administrator/Desktop/台科/課程/112-2 IoT/IoT Mid/統神下完樓梯開電燈_M11207509_王佑強/NSSHAFT/Wall.png"); // Load the wall image
  leftWall.resize(0, height); // Resize to fit the height of the window
  rightWall = loadImage("C:/Users/Administrator/Desktop/台科/課程/112-2 IoT/IoT Mid/統神下完樓梯開電燈_M11207509_王佑強/NSSHAFT/Wall.png"); // Load the wall image
  rightWall.resize(0, height); // Resize to fit the height of the window
  gameStart = loadImage("C:/Users/Administrator/Desktop/台科/課程/112-2 IoT/IoT Mid/統神下完樓梯開電燈_M11207509_王佑強/NSSHAFT/gamestart.png"); // Load the wall image
  gameStart.resize(0, height); // Resize to fit the height of the window
  gameOver = loadImage("C:/Users/Administrator/Desktop/台科/課程/112-2 IoT/IoT Mid/統神下完樓梯開電燈_M11207509_王佑強/NSSHAFT/gameover Mid.png"); // Load the wall image
  gameOver.resize(0, height); // Resize to fit the height of the window
  String portName ="COM8";
  myPort = new Serial(this, portName, 115200);
  lastY = 675;
  size(450, 675);
  smooth();
  b1 = new Block(0, 100, 0, 100);
  b2 = new Block(100, 200, 100, 200);
  b3 = new Block(200, 300, 200, 300);
  sb = new spikeBlock();
  ib = new initialBlock();
  p = new player();
  mrBlock = new MovingRightBlock();
  mlBlock = new MovingLeftBlock();
  bBlock = new BounceBlock();
  moveVector = new PVector(xSpeed, 1);
  locs.add(b1);
  locs.add(b2);
  locs.add(mrBlock);
  locs.add(mlBlock);
  locs.add(bBlock);
  locs.add(b3);
  locs.add(sb);
  locs.add(ib);
}
void draw() {
  background(0);

 
  if (hp<50) {
    hp+=0.01;
  }
  if (!start && !gameover) {
    //background(200);
    image(gameStart, 0, 0);
  }
  if (start && !gameover) {
    background(0);
    image(leftWall, 0, 0);  // Position at the left boundary
    image(rightWall, width - rightWall.width, 0);  // Position at the right boundary
    fill(200);
    float spikeWidth = 20; // Width of one spike triangle
    float spikeHeight = 20; // Height of one spike triangle

    // Calculate the number of spikes needed to cover the width
    int numSpikes = int(width / spikeWidth);

    float i = 0;
    for (int a = 0; a < numSpikes; a++) {
      // Draw each spike across the width
      triangle(i, 0, i + spikeWidth / 2, spikeHeight, i + spikeWidth, 0);
      i += spikeWidth;
    }
    

    

    //p.update();

    p.drawPlayer();
    b1.makeBlock();
    b2.makeBlock();
    mrBlock.makeBlock();
    mlBlock.makeBlock();
    bBlock.makeBlock();
    b3.makeBlock();
    sb.makeBlock();
    ib.makeBlock();

    if ( myPort.available() > 0) {  // If data is available,
      val = myPort.read();         // read it and store it in val
      aa = val & 3; // 獲取最低位
      bb = (val >> 2) & 3; // 右移一位後獲取最低位
      cc = (val >> 4) & 1; // 右移兩位後獲取最低位
      //println(aa, bb, cc);
    }
    //image(loopingGif, 0, 0);
    // y=110;
    if (aa==0) {
      moveVector.x = -5;
    } else if (aa==1) {
      moveVector.x = 5;
    }
    
        // Update falling speed and GIF animation speed based on bb value
    if (bb == 1) {
       ySpeed = 3; // Increase falling speed
      //loopingGif.speed(1.5);     // Set GIF speed to 1.5x
    }else{
      ySpeed = 1.5;
    }
    
    


    if (p.getLoc().y < 20 || p.getLoc().y > height || hp <= 0) {
      gameover = true;
      start = false;
    }
  }
  if (!start && gameover) {
    if (!deathSound.isPlaying()) {
      deathSound.play();
    }
    background(0);
    image(gameOver, 0, 0);
    textSize(30);
    text("Your Score:" + count, width/2-100, height/2+250);
  }
}
void keyPressed() {

  switch (keyCode) {
  case LEFT:
    moveVector.x = -10;
    break;
  case RIGHT:
    moveVector.x = 10;
    break;
  case ' ':
    p.reset();
    ib.reset();
    b1.reset();
    b2.reset();
    b3.reset();
    sb.reset();
    start = true;
    gameover = false;
    count = 1;
    hp = 50;
    break;
  }
}

class player {
  //i=loopingGif;
  float x = width/2 - 15;
  float y = height/2 - 50;
  PVector loc = new PVector(x, y);
  boolean facingLeft = false;
  public player() {
  }
  void  reset() {
    loc.x = width/2 - 15;
    loc.y = height/2 - 50;
  }
 
  void bounce() {
      loc.y -= 100; // Adjust the bounce magnitude here
      touchSound.play();
  }

  public void drawPlayer() {
    if (facingLeft) {
      pushMatrix();
      translate(loc.x + loopingGif.width, loc.y); // Move matrix to image location
      scale(-1, 1); // Flip horizontally
      image(loopingGif, 0, 0);
      popMatrix();
    } else {
      image(loopingGif, loc.x, loc.y);
    }

    for (Block b : locs) {
      if (isCollision(b)) {
        moveVector.y = -4;
        touchSound.play();
      }
    }

    // Determine the direction of the player
    if (moveVector.x < 0) {
      facingLeft = true;
    } else if (moveVector.x > 0) {
      facingLeft = false;
    }

    // Update the player's location
    loc.add(moveVector);

    // Ensure player does not move outside the screen width
    loc.x = constrain(loc.x, 0, width - loopingGif.width); // Ensure the player's position is within the screen bounds
 
    // Reset movement after applying to prevent sliding
    moveVector.y = 2;
    moveVector.x = 0;
    // Apply the correct image based on the direction
    if (facingLeft) {
      pushMatrix();
      translate(loc.x + loopingGif.width, loc.y);  // Move matrix to image location
      scale(-1, 1);  // Flip horizontally
      image(loopingGif, 0, 0);
      popMatrix();
    } else {
      image(loopingGif, loc.x, loc.y);
    }

    // Reset the movement vector
    moveVector.y = 2;
    moveVector.x = 0;  // It's crucial to reset this here to prevent repeated drawing issues
  }
  public PVector getLoc() {
    return loc;
  }
  public boolean isCollision(Block other) {
    float bx = other.getX();
    float by = other.getY();
    float playerBottomEdgeY = getLoc().y + loopingGif.height;
    //if((playerBottomEdgeY-by <= 12 && playerBottomEdgeY-by >=0) && abs(getLoc().x+12-(bx+25)) <= 26){
    if ((playerBottomEdgeY - by <= 12 && playerBottomEdgeY - by >= 0) && abs(getLoc().x - bx) <= loopingGif.width / 2 + other.getWidth() / 2) {
      return true;
    }
    return false;
  }
  void update() {
    // Check for collisions with all blocks
    boolean onMovingRightBlock = false;
    for (Block b : locs) {
      if (b instanceof MovingRightBlock && p.isCollision(b)) {
        onMovingRightBlock = true;
        break;
      }
    }

    if (!onMovingRightBlock) {
      moveVector.x = 0; // Stop moving right if not on the block
    }

    // Update player location based on moveVector
    loc.add(moveVector);
  }
}

class Block {
  PImage blockImage;
  //color clr = color(0, 0, 255);
  float l, r, u, d;
  float x, y;
  float w = 50 * 1.5;  // Scaled width
  float h = 10 * 1.5;  // Scaled height

  public Block() {
  }
  public Block(float a, float b, float c, float d) {
    this.l = a * 1.5;
    this.r = b * 1.5 - w;  // Adjust to stay within width boundaries
    this.u = c * 1.5;
    this.d = d * 1.5 - h;  // Adjust to stay within height boundaries
    x = random(a, b);
    //y = height - 20 + random(c, d);
    y = max(height - random(u, d), lastY - 150);
    lastY = y;
  }
  void reset() {
    x = random(l, r);
    //y = height + random(u, d) - 20;  // Make sure reset logic matches
    y = max(height + random(u, d), lastY - 150);
    lastY = y;
  }
  float getX() {
    return x;
  }
  float getY() {
    return y;
  }
  float getWidth() {
    return w;
  }

  void makeBlock() {
    if (this.y < 0) {
      x += random(-30, 30);
      y = max(height + random(u, d), lastY - 150);
      lastY = y;
    }
    blockImage = loadImage("C:/Users/Administrator/Desktop/台科/課程/112-2 IoT/IoT Mid/統神下完樓梯開電燈_M11207509_王佑強/NSSHAFT/floor/Normal.png");// Load the block image
    image(blockImage, x, y);
    lastY = y;
    y -= ySpeed;
    count++;
  }
}
class spikeBlock extends Block {
  PImage blockImage; // Image for the moving block
  float l = 0;
  float r = 250;
  float u = 0;
  float d = 100;
  float x = random(l, r);
  float y = height + random(u, d);
  float w = 50*1.5;
  float h = 10*1.5;

  public spikeBlock() {
  }
  public spikeBlock(float a, float b, float c, float d) {
    this.l = a * 1.5;
    this.r = b * 1.5 - w;  // Adjust to stay within width boundaries
    this.u = c * 1.5;
    this.d = d * 1.5 - h;  // Adjust to stay within height boundaries
    x = random(a, b);
    //y = height - 20 + random(c, d);
    y = max(height - random(u, d), lastY - 200);
    lastY = y;
  }
  void reset() {
    x = random(l, r);
    //y = height + random(u, d);
    y = max(height + random(u, d), lastY - 200);
    lastY = y;
  }
  float getX() {
    return x;
  }
  float getY() {
    return y;
  }

  void makeBlock() {
    if (this.y < 0) {
      x += random(-30, 30);
      y = height + random(300);
    }
    blockImage = loadImage("C:/Users/Administrator/Desktop/台科/課程/112-2 IoT/IoT Mid/統神下完樓梯開電燈_M11207509_王佑強/NSSHAFT/floor/Nails.png");// Load the block image
    image(blockImage, x, y);
    y -= ySpeed;
    count++;
    fill(255, 0, 0);
    if (p.isCollision(this)&&hp > 0) {
      hurtSound.play();
      hp -= 0.3;
    }
    rect(0, 20, hp, 20);
  }
}
class MovingRightBlock extends Block {
  PImage blockImage; // Image for the moving block
  float w = 50*1.5; // Set width from image dimensions
  float h = 10*1.5; // Set height from image dimensions
  float l = 0;
  float r = 250;
  float u = 0;
  float d = 100;
  float x = random(l, r);
  float y = height + random(u, d);

  public MovingRightBlock() {
    super();
  }
  void reset() {
    x = random(l, r);
    y = height + random(u, d);
  }
  float getX() {
    return x;
  }
  float getY() {
    return y;
  }

  void makeBlock() {
    if (this.y < 0) {
      x += random(-30, 30);
      y = height + random(300);
    }
    blockImage = loadImage("C:/Users/Administrator/Desktop/台科/課程/112-2 IoT/IoT Mid/統神下完樓梯開電燈_M11207509_王佑強/NSSHAFT/floor/ConveyorRight.png");// Load the block image
    image(blockImage, x, y);
    y -= ySpeed;
    count++;
    if (p.isCollision(this)&&hp > 0) {
      moveVector.x = 10;
    }
  }

  void interact(player p) {
    if (p.isCollision(this)) {
      touchSound.play();
      moveVector.x = 10; // Or whatever the logic needs to be
    }
  }
}

class MovingLeftBlock extends Block {
  PImage blockImage; // Image for the moving block
  float w = 50*1.5; // Set width from image dimensions
  float h = 10*1.5; // Set height from image dimensions
  float l = 0;
  float r = 250;
  float u = 0;
  float d = 100;
  float x = random(l, r);
  float y = height + random(u, d);

  public MovingLeftBlock() {
    super();
  }
  void reset() {
    x = random(l, r);
    y = height + random(u, d);
  }
  float getX() {
    return x;
  }
  float getY() {
    return y;
  }

  void makeBlock() {
    if (this.y < 0) {
      x += random(-30, 30);
      y = height + random(300);
    }
    blockImage = loadImage("C:/Users/Administrator/Desktop/台科/課程/112-2 IoT/IoT Mid/統神下完樓梯開電燈_M11207509_王佑強/NSSHAFT/floor/ConveyorLeft.png");// Load the block image
    image(blockImage, x, y);
    y -= ySpeed;
    count++;
    if (p.isCollision(this)&&hp > 0) {
      moveVector.x = -10;
    }
  }

  void interact(player p) {
    if (p.isCollision(this)) {
      touchSound.play();
      moveVector.x = -10; // Or whatever the logic needs to be
    }
  }
}

class BounceBlock extends Block {
  PImage blockImage; // Image for the moving block
  float w = 50*1.5; // Set width from image dimensions
  float h = 10*1.5; // Set height from image dimensions
  float l = 0;
  float r = 250;
  float u = 0;
  float d = 100;
  float x = random(l, r);
  float y = height + random(u, d);

  public BounceBlock() {
    super();
  }
  void reset() {
    x = random(l, r);
    y = height + random(u, d);
  }
  float getX() {
    return x;
  }
  float getY() {
    return y;
  }

  void makeBlock() {
    if (this.y < 0) {
      x += random(-30, 30);
      y = height + random(300);
    }
    blockImage = loadImage("C:/Users/Administrator/Desktop/台科/課程/112-2 IoT/IoT Mid/統神下完樓梯開電燈_M11207509_王佑強/NSSHAFT/floor/Trampoline.png");// Load the block image
    image(blockImage, x, y);
    y -= ySpeed;
    count++;
    if (p.isCollision(this)&&hp > 0) {
      p.bounce();
    }
  }

  void interact(player p) {
    print("interact");
    if (p.isCollision(this)) {
      //print("isCollision");
      moveVector.y = -100; // Or whatever the logic needs to be
    }
  }
}


class initialBlock extends Block {
  PImage blockImage;
  color clr = color(0, 0, 255);
  float x = (width / 2 - 25) *1.5;
  float y = (height /2 + 50) *1.5;
  float w = 50*1.5;
  float h = 10*1.5;
  public initialBlock() {
  }
  void reset() {
    x = (width / 2 - 25) *1.5;
    y = (height /2 + 50) *1.5;
  }
  float getX() {
    return x;
  }
  float getY() {
    return y;
  }
  void makeBlock() {
    blockImage = loadImage("C:/Users/Administrator/Desktop/台科/課程/112-2 IoT/IoT Mid/統神下完樓梯開電燈_M11207509_王佑強/NSSHAFT/floor/Normal.png");// Load the block image
    image(blockImage, x, y);
    y -= ySpeed;
  }
}