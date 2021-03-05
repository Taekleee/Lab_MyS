Person person; 
People people;
long lastTime = 0;
//CONSTANTES

float A  = 25;
float B = 0.08;
float kMay = 750;
float kMin = 3000;
float v0 = 5;
float t = 0.5;


PVector target = new PVector(600, 239);
PVector target2 = new PVector(600, 261);
void myDelay(int ms)
{
   try
  {    
    Thread.sleep(ms);
  }
  catch(Exception e){}
}

void setup() {
  size(700, 500);
  lastTime = millis();
  people = new People();
  //**********************************************************************
  // Se generan las personas
  
  people.addPerson(new Person(40,30));
  /*people.addPerson(new Person(40,130));
  people.addPerson(new Person(40,160));
  people.addPerson(new Person(40,190));
  people.addPerson(new Person(40,210));
  people.addPerson(new Person(40,240));
  people.addPerson(new Person(40,270));
  people.addPerson(new Person(40,300));
  people.addPerson(new Person(40,330));
  people.addPerson(new Person(40,360));
  people.addPerson(new Person(40,390));
  */
  

  
}

/* Se dibujan las líneas
*/
void draw() {
  background(50);
  line(0, 0, 600, 226);
  line(600,274, 0, 500);
  line(40,100,40,400);
 // delay(200);
  people.run();
  


}
