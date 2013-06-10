/*
 * Simple Prgram to drive DC Motor
 * (Seeeduino Mega v1.1)
 */
 
int motorPin = 4;
int inPin1 = 2;
int inPin2 = 3;
int analogModePin = A0; 

void setup()
{
  Serial.begin(9600);
  pinMode(motorPin, OUTPUT);
  pinMode(inPin1, OUTPUT);
  pinMode(inPin2, OUTPUT);
  pinMode(analogModePin, INPUT);
  
  //set motor to forward
  digitalWrite(inPin1, HIGH);
  digitalWrite(inPin2, LOW);
}

int getAnalogMode()
{
  int input, mode;
  input = analogRead(analogModePin);
  if(input > 900)
  {
    mode = 1;
  }
  else if(input < 100)
  {
    mode = 0;
  }
  else
  {
    mode =-1;
  }
  return mode;
}
int getDigitalMode()
{
  int current = Serial.read();
  if(current == 1){
    return 1;
  }else if(current == 0){
    return 0;
  }
}
   
  
  
void freeFlight()
{
  analogWrite(motorPin, 70);
}
void reelIn()
{
  analogWrite(motorPin, 1023);
}



void loop()
{
  static int tMode;
  //tMode = getAnalogMode();
  curr = getDigitalMode();
    if(curr == 0)
    {
      tMode = 0;
    }
    else if(curr == 1)
    {
      tMode = 1;
    }
    if(tMode == 0){
      freeFlight();
    }if(tMode ==1){
      reelIn();
    }

    
    Serial.print("mode = "); Serial.println(tMode);
}
  

  
