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

  void run(ArrayList<Person> person) {
    arrive(target);
    people(person);
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
  
  //**********************************************************************
  // Se suman las fuerzas
  
  void people(ArrayList<Person> person) {
      PVector sep = separate(person);   // Separation
      PVector cor = corporal(person);
      PVector fric = friccion(person);
      // Arbitrarily weight these forces
      sep.mult(1.5);
      cor.mult(1.5);
      fric.mult(1.5);
      
      // Add the force vectors to acceleration
      applyForce(sep);
      applyForce(cor);
      applyForce(fric);
    }
    
    //**********************************************************************
    // Separation
    // Method checks for nearby boids and steers away
    PVector separate (ArrayList<Person> person) {
    float desiredseparation = 60.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Person other : person) {
      float dij = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((dij > 0) && (dij < desiredseparation)) {
        float rij = 20;
        PVector nij = PVector.sub(location, other.location);
        nij.div(dij);
        float exponente = (-(dij- rij))/B;
        float exp = exp(exponente);
        float mult = exp*A;
        nij.mult(mult);
        nij.normalize();
        steer.add(nij);
        //print(steer);
        count++;

    }
    }
      if (count > 0) {
        steer.div((float)count);
      }
  
      // As long as the vector is greater than 0
      if (steer.mag() > 0) {
        // First two lines of code below could be condensed with new PVector setMag() method
        // Not using this method until Processing.js catches up
        // steer.setMag(maxspeed);
        // Implement Reynolds: Steering = Desired - Velocity
      }
      return steer;
    }



   //**********************************************************************
    // Fuerzaz corporal
    // Method checks for nearby boids and steers away
    PVector corporal (ArrayList<Person> person) {
    float rij = 20.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Person other : person) {
      float dij = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((dij > 0) && (dij < rij)) {
        float p1 = 2*kMin*(rij - dij);
        PVector nij = PVector.sub(location, other.location);
        nij.div(dij);
        nij.mult(p1);
        nij.normalize();
        steer.add(nij);
        //print(steer);
        count++;

    }
    }
      if (count > 0) {
        steer.div((float)count);
      }
      return steer;
    }


   //**********************************************************************
    // Fuerzaz de fricción
    // Method checks for nearby boids and steers away
    PVector friccion (ArrayList<Person> person) {
    float rij = 20.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Person other : person) {
      float dij = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((dij > 0) && (dij < rij)) {
        
        PVector nij = PVector.sub(location, other.location);
        nij.div(dij);
        PVector vij = PVector.sub(velocity, other.velocity);
        PVector tij =new PVector(-nij.x, nij.y);
        vij.dot(tij);
        print(vij);
        float p1 = kMay*(rij - dij);
        vij.mult(p1);
        vij.cross(tij);
        
        vij.normalize();
        steer.add(vij);
        //print(steer);
        count++;

    }
    }
      if (count > 0) {
        steer.div((float)count);
      }
      return steer;
    }


 //**********************************************************************
 //Si se llega al objetivo la persona vuelve a entrar por el extremo izquierdo
 // Arreglar 
  void borders(){
   // if(location.x >= 600 && location.y <= 261 && location.y >= 239) location.x = 0;
    if(location.x >= 600 + r) location.x = 0;
  }
  //**********************************************************************
  //Genera que cada persona llegue al punto objetivo
  
  
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
