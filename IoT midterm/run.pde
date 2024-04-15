import processing.serial.*;
import gifAnimation.*;
import ddf.minim.*;
PImage[] animation;
Gif loopingGif,gpig;
Block b1;
Block b2;
Block b3;
spikeBlock sb;
initialBlock ib;
player p;
PVector moveVector;
float xSpeed = 0;
ArrayList<Block> locs = new ArrayList<Block>();
boolean gameover = false;
boolean start = false;
final float ySpeed = 2;
int count = 1;
float hp = 50;

void setup() {
  loopingGif = new Gif(this, "C:/Users/Administrator/Downloads/Angrybird_recourse/NSSHAFT/player_run.gif");
  loopingGif.loop();
  size(450, 675);
  smooth();
  b1 = new Block(0,100,0,100);
  b2 = new Block(100,200,100,200);
  b3 = new Block(200,300,200,300);
  sb = new spikeBlock();
  ib = new initialBlock();
  p = new player();
  moveVector = new PVector(xSpeed,1);
  locs.add(b1);
  locs.add(b2);
  locs.add(b3);
  locs.add(sb);
  locs.add(ib);

}
void draw() {
    if(hp<50){
    hp+=0.01;
  }
  if(!start && !gameover){
    background(200);
    textSize(10);
    fill(0,0,255);
    text("Control:",0,20);
    text("use left and right keys to control",10,35);
    text("Lose:",0,50);
    text("1)hit by the ceiling",10,65);
    text("2)drop,which is get out of the screen",10,80);
    text("3)hp=0,you lost your hp when you are ",10,95);
    text("on the block with spikes",20,110);
    textSize(15);
    text("if you are ready to die",width/2-100,height/2-50);
    text("press space",width/2-100,height/2-30);
   
    
  }
  if (start && !gameover) {
      background(0);
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

      p.drawPlayer();
      b1.makeBlock();
      b2.makeBlock();
      b3.makeBlock();
      sb.makeBlock();
      ib.makeBlock();

      if (p.getLoc().y < 20 || p.getLoc().y > height || hp <= 0) {
          gameover = true;
          start = false;
      }
  }
  if(!start && gameover){
    background(200);
    text("gameover",width/2-100,height/2-100);
    text("Your Score:" + count , width/2-100,height/2-70);
    text("Press space to try again",width/2-100,height/2-40);
    
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

class player{
  //i=loopingGif;
  float x = width/2 - 15;
  float y = height/2 - 50;
  PVector loc = new PVector(x,y);
  boolean facingLeft = false;
  public player(){
  }
  void  reset(){
    loc.x = width/2 - 15;
    loc.y = height/2 - 50;
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
  public PVector getLoc(){
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
}

class Block{
  color clr = color(0, 0, 255);
  float l, r, u, d;
  float x, y;
  float w = 50 * 1.5;  // Scaled width
  float h = 10 * 1.5;  // Scaled height
  public Block(){
  }
  public Block(float a,float b,float c,float d){
    this.l = a * 1.5;
    this.r = b * 1.5 - w;  // Adjust to stay within width boundaries
    this.u = c * 1.5;
    this.d = d * 1.5 - h;  // Adjust to stay within height boundaries
    x = random(a, b);
    y = height - 20 + random(c, d); 
  }
  void reset(){
    x = random(l, r);
    y = height + random(u, d) - 20;  // Make sure reset logic matches
  }
  float getX(){
    return x;
  }
  float getY(){
    return y;
  }
  float getWidth() {
    return w;
  }
   
  void makeBlock(){    
    if(this.y < 0){
      x += random(-30,30);
      y = height + random(50);
    }
    fill(clr);
    rect(x, y, w, h);
    y -= ySpeed;
    count++;
  }
  
}
class spikeBlock extends Block{
  color clr = color(0,0,255);
  float l = 0;
  float r = 250;
  float u = 0;
  float d = 100;
  float x = random(l,r);
  float y = height + random(u,d);
  float w = 50*1.5;
  float h = 10*1.5;
  public spikeBlock(){
  }
  void reset(){
    x = random(l,r);
    y = height + random(u,d);   
  }
  float getX(){
    return x;
  }
  float getY(){
    return y;
  }
   
  void makeBlock(){    
    if(this.y < 0){
      x += random(-30,30);
      y = height + random(300);
    }
    fill(200);
    triangle(x, y, x + 5 * 1.5, y - 10 * 1.5, x + 10 * 1.5, y);
    triangle(x + 10 * 1.5, y, x + 15 * 1.5, y - 10 * 1.5, x + 20 * 1.5, y);
    triangle(x + 20 * 1.5, y, x + 25 * 1.5, y - 10 * 1.5, x + 30 * 1.5, y);
    triangle(x + 30 * 1.5, y, x + 35 * 1.5, y - 10 * 1.5, x + 40 * 1.5, y);
    triangle(x + 40 * 1.5, y, x + 45 * 1.5, y - 10 * 1.5, x + 50 * 1.5, y);
    fill(clr);
    rect(x,y,w,h);  
    y -= ySpeed;
    count++;
    fill(255,0,0);
    if(p.isCollision(this)&&hp > 0){
      hp -= 0.3;
    }
    rect(0,20,hp,20);
  }
  
}
class initialBlock extends Block{
  color clr = color(0,0,255);
  float x = (width / 2 - 25) *1.5;
  float y = (height /2 + 50) *1.5;
  float w = 50*1.5;
  float h = 10*1.5;
  public initialBlock(){
  }
  void reset(){
    x = (width / 2 - 25) *1.5;
    y = (height /2 + 50) *1.5;
  }
  float getX(){
    return x;
  }
  float getY(){
    return y;
  }
  void makeBlock(){
    fill(clr);
    rect(x,y,w,h);  
    y -= ySpeed;
    
    
  }
}
