//***********************************Clase personas ***********************************
//Almacena una lista de personas
class People {
  ArrayList<Person> person; // An ArrayList for all the boids

  People() {
    person = new ArrayList<Person>(); // Initialize the ArrayList
  }

  void run() {
    for (Person b : person) {
      b.run(person);  // Passing the entire list of boids to each boid individually
    }
  }

  void addPerson(Person b) {
    person.add(b);
  }

}
