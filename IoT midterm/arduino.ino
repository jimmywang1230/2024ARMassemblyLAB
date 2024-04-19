#include <Servo.h>
#include <stdbool.h>
#include <SoftwareSerial.h>

Servo myServo;  // create a servo object
SoftwareSerial btSerial(3, 4); // TX, RX

const int sensorPin = A1;
const int redLEDPin = 7; 

int sensorValue;
bool lightsPower;

int angle; // variable to hold the angle for the servo motor
int potVal; // variable to read the value from the analog pin
// 以下是game的
int JoyStick_X = 0; //x
int JoyStick_Y = 2; //y
const int LIGHT_BUTTON_PIN = 5;
const int GAME_BUTTON_PIN = 10;
int gameMode = 0;   // 按鈕的狀態
int A,B,C,D;
int game_buttonState;
int light_buttonState;
void setup()
{
  pinMode(13,OUTPUT);
  pinMode(LIGHT_BUTTON_PIN, INPUT); 
  pinMode(GAME_BUTTON_PIN, INPUT); 
  pinMode(7,INPUT);
  pinMode(JoyStick_X, INPUT);
  pinMode(JoyStick_Y, INPUT);
  Serial.begin(115200);
    // put your setup code here, to run once:
  myServo.attach(8); // attaches the servo on pin 9 to the servo object
  // Serial.begin(38400); // open a serial connection to your computer
  btSerial.begin(9600); 
  myServo.write(90);

  pinMode(redLEDPin,OUTPUT);

  lightsPower = 0;
}
int prev=0;
void loop()
{
  // 藍芽控制電燈
  if (btSerial.available()){  //如果藍牙有傳資料過來
    int i = btSerial.read();  //把讀到的資料丟給i
    Serial.println(i);
    if(i == 1){    //如果是1，亮燈
      Serial.println("Led On");
      digitalWrite(7,HIGH);
      myServo.write(20);
    }
    if(i == 2){    //如果是2，熄燈
      Serial.println("Led Off");
      myServo.write(20);
      digitalWrite(7,LOW);
    }
  }

  game_buttonState = digitalRead(GAME_BUTTON_PIN);  //讀取按鍵的狀態
  light_buttonState = digitalRead(LIGHT_BUTTON_PIN);  //讀取按鍵的狀態
  // Serial.print(light_buttonState);
  // Serial.println(game_buttonState);
  if(game_buttonState == HIGH){          //如果按鍵按了
    gameMode=1;
    Serial.println("game");  
  }else if(light_buttonState == HIGH){                           //如果按鍵是未按下
    gameMode = 0;
    Serial.println("LIGHT"); 
  }
  delay(150);

  if (gameMode ==1) {
    int x,y,z; 
    x=analogRead(JoyStick_X); 
    y=analogRead(JoyStick_Y); 
    // Serial.print(x ,DEC); Serial.print(",");
    // Serial.println(y ,DEC); 
    if(x<=100) {
      B=0;
    }else if(x>900){
      B=1;
    } else if(x>400 && x<600){
      B=2;
    }
    if(y<=150) {
      A=0;
    }else if(y>850){
      A=1;
    } else if(x>400 && x<600){
      A=2;
    }
    C=1;
    D=1;
    int result =(D<<5)| (C << 4) | (B << 2) | A;
    // 顯示結果到串行監視器
    // Serial.print(result,BIN);
    // Serial.println(result);
    // Serial.print(A); Serial.print(",");
    // Serial.print(B); Serial.print(",");
    // Serial.print(C); Serial.print(",");
    // Serial.println(D); 
    Serial.write(result); // 以二進制形式顯示
  } else if(gameMode == 0) {
    sensorValue = analogRead(sensorPin);
    delay(5);
    // Serial.print("\nsensor Values \t : ");
    // Serial.println(sensorValue);

    if(sensorValue > 500 && lightsPower==1) {
      myServo.write(20);
      digitalWrite(7, LOW);
      lightsPower = 0;
      delay(3000); 
    } else if (sensorValue > 500 && lightsPower==0) {
      myServo.write(180);
      digitalWrite(7, HIGH);
      lightsPower = 1;
      delay(3000); 
    } 
  }

  delay(100);
}