//***********************************Clase personas ***********************************
//Almacena una lista de personas
class People {
  ArrayList<Person> person; // An ArrayList for all the boids
  int i = 30;
  int j = 0;
  People() {
    person = new ArrayList<Person>(); // Initialize the ArrayList
  }

  /*
  Entrada: - 
  Proceso: 
  */
  void run() {
    for (Person b : person) {
      b.run(person);  
    }
    if(j<i){
       int rand = int(random(1,100));
       if(frameCount %  rand == 0){
          person.add(new Person(40,random(30,400)));
          j++;
       }
    }
    
  }

  void addPerson(Person b) {
    person.add(b);
  }
  
  void myDelay(int ms)
{
   try
  {    
    Thread.sleep(ms);
  }
  catch(Exception e){}
}

}
