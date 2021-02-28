Person person; 
People people;

//CONSTANTES

float A  = 25;
float B = 0.08;
float kMay = 750;
float kMin = 3000;
float v0 = 5;
float t = 0.5;


PVector target = new PVector(600, 239);
PVector target2 = new PVector(600, 261);


void setup() {
  size(700, 500);
  people = new People();
  //**********************************************************************
  // Se generan las personas
  
  people.addPerson(new Person(40,30));
  people.addPerson(new Person(40,130));
  people.addPerson(new Person(40,160));
  people.addPerson(new Person(40,190));
  people.addPerson(new Person(40,210));
  people.addPerson(new Person(40,240));
  people.addPerson(new Person(40,270));
  people.addPerson(new Person(40,300));
  people.addPerson(new Person(40,330));
  people.addPerson(new Person(40,360));
  people.addPerson(new Person(40,390));
  
  /*
   for (int i = 0; i < 10; i++) {
    people.addPerson(new Person(40,random(100,400)));  
  }
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
