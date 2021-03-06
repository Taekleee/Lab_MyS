//***********************************Clase personas ***********************************
//Almacena una lista de personas
class People {
  ArrayList<Person> person; // An ArrayList for all the boids
  int total_persons = 10; //Cantidad de personas a generar
  int iterator = 0; 
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
    
    
    if(iterator<total_persons){
       int rand = int(random(1,100));
       /*Para simular que las personas aparecen en tiempos distintos sin detener el programa completo,
         se van generando nuevas personas según el frame en el que se encuentra. Si el frame del programa
         es múltiplo del valor almacenado en la variable rand, se agrega la nueva persona, si no, se espera
         a que el programa pase al frame siguiente para realizar este proceso.
        */
       if(frameCount %  rand == 0){
          person.add(new Person(40,random(30,400)));
          iterator++;
       }
    }
    
  }

  void addPerson(Person b) {
    person.add(b);
  }
  

}
