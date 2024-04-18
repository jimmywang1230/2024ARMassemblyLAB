int JoyStick_X = 0; //x
int JoyStick_Y = 2; //y
// int JoyStick_Z = 10; //key
const int LIGHT_BUTTON_PIN = 5;
const int GAME_BUTTON_PIN = 10;
int gameMode = 0;   // 按鈕的狀態
int A,B,C,D;
int game_buttonState;
int light_buttonState;
int gg;
void setup()
{
  pinMode(13,OUTPUT);
  pinMode(LIGHT_BUTTON_PIN, INPUT); 
  pinMode(GAME_BUTTON_PIN, INPUT); 
  pinMode(7,INPUT);
  pinMode(JoyStick_X, INPUT);
  pinMode(JoyStick_Y, INPUT);
  Serial.begin(115200);
}
int prev=0;
void loop()
{
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
  }

  delay(100);
}