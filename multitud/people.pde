//***********************************Clase People ***********************************
//Almacena una lista de personas
class People {
  ArrayList<Person> person; // ArrayList con las personas de la simulación
  int NumeroPersonas = 30; //Cantidad de personas a generar
  int iterator = 0; //Variable auxiliar que indica la cantidad actual de personas en el arreglo de personas
  People() {
    person = new ArrayList<Person>(); // Se inicializa el ArrayList con personas
  }

  /*
  Entrada: - 
  Proceso: Se encarga de ir generando las personas en frames aleatorios, y se ejecutan las personas en la simulación
           de processing.
  */
  void run() {
    for (Person b : person) {
      b.run(person);  
    }
    if(iterator<NumeroPersonas){
       int rand = int(random(1,100));
       /*Para simular que las personas aparecen en tiempos distintos sin detener el programa completo,
         se van generando nuevas personas según el frame en el que se encuentra. Si el frame del programa
         es múltiplo del valor almacenado en la variable rand, se agrega la nueva persona, si no, se espera
         a que el programa pase al frame siguiente para realizar este proceso.
        */
       if(frameCount %  rand == 0){
          person.add(new Person(40,random(100,400)));
          iterator++;
       }
    }
    
  }

  void addPerson(Person b) {
    person.add(b);
  }
  

}
