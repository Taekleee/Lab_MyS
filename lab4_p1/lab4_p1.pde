Flock flock;
PVector target = new PVector(200, 20);
float targetradius = 10;

void setup() {
  size(640, 640);
  flock = new Flock();
  circle(target.x, target.y, targetradius);
  // Add an initial set of boids into the system
  for (int i = 0; i < 150; i++) {
    flock.addBoid(new Boid(random(500),random(500)));
  }
}

/* Se dibuja un círculo de radio 140, centrado en el punto (300,300)
lo cual equivale al centro de la pantalla desplegada
*/
void draw() {
  background(50);
  circle(300, 300, 140);
  flock.run();
}

// Add a new boid into the System
void mousePressed() {
  flock.addBoid(new Boid(mouseX,mouseY));
}



// The Flock (a list of Boid objects)

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }

  void run() {
    for (Boid b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }

}




// The Boid class

class Boid {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

    Boid(float x, float y) {
    acceleration = new PVector(0, 0);

    // This is a new PVector method not yet implemented in JS
    // velocity = PVector.random2D();

    // Leaving the code temporarily this way so that this example runs in JS
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));

    position = new PVector(x, y);
    r = 2.0;
    maxspeed = 2;
    maxforce = 0.03;
  }

  void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    borders();
    render();
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  /*
  ##############################################################################################################################################
  ##############################################################################################################################################
  ##############################################################################################################################################
  
  Debido a que existe una nueva fuerza de separación, y que es realizada por 
  el pilar hacia los pájaros, es que es necesario agregarla a la sumatoria de fuerza
  quedando: 
  
  F = sep + ali + coh + sep2
  
  en donde: 
  
  sep: Fuerza de separación entre los pájaros
  ali: Fuerza de alineación entre los pájaros
  coh: Fuerza de cohesión entre los pájaros
  sep2: Fuerza de separación o "repulsión" entre cada uno de los pájaros y el pilar
  
  También es necesario multiplicar a cada una de las fuerzas con el peso. En el caso de 
  sep2, debido a que los pájaros no deben chocar con el pilar, se le asigna un valor mayor
  al resto.
  Finalmente se aplica la fuerza y se actualiza a cada uno de los pájaros. 
  
  ##############################################################################################################################################
  ##############################################################################################################################################
  ##############################################################################################################################################
  */
  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   // Separation
    PVector sep2= separate2(boids);
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(1.5);
    sep2.mult(1.8);
    ali.mult(1.0);
    coh.mult(1.0);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(sep2);
    applyForce(ali);
    applyForce(coh);
  }

  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);

    // Above two lines of code below could be condensed with new PVector setMag() method
    // Not using this method until Processing.js catches up
    // desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    
    fill(200, 100);
    stroke(255);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (position.x < -r) position.x = width+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    if (position.y > height+r) position.y = -r;
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }
/*
##############################################################################################################################################
##############################################################################################################################################
##############################################################################################################################################

Se crea un método llamado separate2.
Lo que se hace es generar dos radios, uno para el pilar (desiredseparation) y otro más grande,
además de dos vectores que simbolizan la magnitud de la fuerza de estos radios (a y b respectivamente). 
El algoritmo se desarrolla para cada pájaro: 
- Primero compara si el pájaro se encuentra dentro del radio mayor definido, de ser así calcula la fuerza 
de repulsión que debe ser aplicada. De esta manera, el pájaro desde antes de chocar con el pilar se comienza a desviar.
- Si debido a la velocidad el pájaro entra en el radio del pilar, se aplica una fuerza con una magnitud mayor a la anterior,
con el fin de desviarlo totalmente. 


De esta forma se simula el vuelo de los pájaros, ya que desde que ven el objeto a la distancia comienzan de a poco a cambiar
su rumbo. 
En el caso de que se comenzara a desviar justo cuando choca con el pilar, el pájaro daría media vuelta y se iría por el camino que venía.

##############################################################################################################################################
##############################################################################################################################################
##############################################################################################################################################
*/
  PVector separate2 (ArrayList<Boid> boids) {
    float desiredseparation = 125.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    PVector a = new PVector(300,300);
    PVector b = new PVector(175,175);
    // For every boid in the system, check if it's too close
    
    for (Boid other : boids) {
      float d = PVector.dist(position, a);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation + 60)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, b);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, a);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // sum.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } 
    else {
      return new PVector(0, 0);
    }
  }
}
