Person person; 
People people;
PVector target = new PVector(600, 239);
PVector target2 = new PVector(600, 261);


void setup() {
  size(700, 500);
  people = new People();
   for (int i = 0; i < 10; i++) {
    people.addPerson(new Person(40,random(100,400)));
    
  }
}

/* Se dibujan las líneas
*/
void draw() {
  background(50);
  line(0, 0, 600, 226);
  line(600,274, 0, 500);
  line(40,100,40,400);
  people.run();
  


}



class Person {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r; //Radio del círculo
  float maxforce;
  float maxspeed;
  float lifespan;

  
  Person(float x, float y) {
    acceleration = new PVector(0,0);
    velocity = new PVector(5,4);
    location = new PVector(x,y);
    r = 10;
    maxspeed = 5;
    maxforce = 0.08;
  }

  void run() {
    arrive(target);
    update();
    borders();
    display();
  }
  
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void borders(){
    if(location.x >= 600+ r) location.x = 0;
    
  }
  
  void arrive(PVector target) {
    PVector desired = PVector.sub(target, location); 
    float d = desired.mag();
    desired.normalize();
    if (d < 100) {
      float m = map(d, 0, 200, 0, maxspeed);
      desired.mult(m);
    } else {
      desired.mult(maxspeed);
    }
    
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);
    applyForce(steer);
  }

  void display() {
    float theta = velocity.heading2D() + PI/2;
    fill(175);
    stroke(0);
    pushMatrix();
    translate(location.x,location.y);
    rotate(theta);
    beginShape();
    ellipse(r,r, r*2, r*2);
    endShape(CLOSE);
    popMatrix();
  }
}

class People {
  ArrayList<Person> person; // An ArrayList for all the boids

  People() {
    person = new ArrayList<Person>(); // Initialize the ArrayList
  }

  void run() {
    for (Person b : person) {
      b.run();  // Passing the entire list of boids to each boid individually
    }
  }

  void addPerson(Person b) {
    person.add(b);
  }

}
