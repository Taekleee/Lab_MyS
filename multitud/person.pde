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
    arrive(target, target2);
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
      
      PVector sepSup = separateWall(person, "sup");
      PVector corSup = corporalWall(person, "sup");
      PVector fricSup = friccionWall(person, "sup");
      
      PVector sepInf = separateWall(person, "inf");
      PVector corInf = corporalWall(person, "inf");
      PVector fricInf = friccionWall(person, "inf");
      
      // Arbitrarily weight these forces
      sep.mult(1.2);
      cor.mult(1.2);
      fric.mult(1.2);
      
      sepSup.mult(1.4);
      corSup.mult(1.4);
      fricSup.mult(1.4);      
      sepInf.mult(1.4);
      corInf.mult(1.4);
      fricInf.mult(1.4);
      
      // Add the force vectors to acceleration
      applyForce(sep);
      applyForce(cor);
      applyForce(fric);
      
      applyForce(sepSup);
      applyForce(corSup);
      applyForce(fricSup);      
      applyForce(sepInf);
      applyForce(corInf);
      applyForce(fricInf);
    }
    //**********************************************************************
    //                         FUERZAS ENTRE PERSONAS
    //**********************************************************************
    PVector separate (ArrayList<Person> person) {
    float desiredseparation = 60.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    float rij = 20;
    for (Person other : person) {
      float dij = PVector.dist(location, other.location);
      if ((dij > 0) && (dij < desiredseparation)) {     
        PVector nij = PVector.sub(location, other.location);
        nij.div(dij);
        float exponente = (-(dij- rij))/B;
        if(exponente > 0) exponente = -exponente;        
        float mult = exp(exponente)*A;
        nij.mult(mult);
        nij.normalize();
        steer.add(nij);
        count++;    }
    }
      if (count > 0) steer.div((float)count);
      return steer;
    }

   //**********************************************************************
    // Fuerzaz corporal
    PVector corporal (ArrayList<Person> person) {
    float rij = 20.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    for (Person other : person) {
      float dij = PVector.dist(location, other.location);
      if ((dij > 0) && (dij < rij)) {
        PVector nij = PVector.sub(location, other.location);
        nij.div(dij);
        nij.mult(2*kMin*(rij - dij));
        nij.normalize();
        steer.add(nij);
        count++;    }
    }
      if (count > 0) steer.div((float)count);
      return steer;
    }

   //**********************************************************************
    // Fuerza de fricción
    PVector friccion (ArrayList<Person> person) {
    float rij = 20.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    for (Person other : person) {
      float dij = PVector.dist(location, other.location);
      if ((dij > 0) && (dij < rij)) {
        PVector nij = PVector.sub(location, other.location);
        nij.div(dij);
        PVector vij = PVector.sub(velocity, other.velocity);
        PVector tij =new PVector(-nij.x, nij.y);
        vij.dot(tij);
        vij.mult(kMay*(rij - dij));
        vij.cross(tij);
        vij.normalize();
        steer.add(vij);
        count++;  }
    }
      if (count > 0) steer.div((float)count);
      return steer;
    }

 //**********************************************************************
 //                         FUERZAS PAREDES 
 //**********************************************************************    
PVector separateWall (ArrayList<Person> person, String wall) {
    float desiredseparation = 60.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    for (Person other : person) {
      PVector point = new PVector(0,0,0);
      float dij = 100;
      float j;
      for(int i = 0; i < 600; i++){
        if(wall == "sup") j =(i*226/600); 
        else j = (-i*226/600) + 500; 
        PVector other2 = new PVector(i,j);
        float dif = PVector.dist(location, other2);
        if(dif  < dij){
           dij = dif;
           point = new PVector(i,j);   
        }
      }
      if((dij > 0) && (dij < desiredseparation)) {
        line(point.x, point.y, location.x, location.y);
        float rij = 20;
        PVector nij = PVector.sub(location, point);
        nij.div(dij);
        float exponente = (-(dij- rij))/B;
        if(exponente > 0) exponente = -exponente;
        float mult = exp(exponente)*A;
        nij.mult(mult);
        nij.normalize();
        steer.add(nij);
        count++;}   
      }
      if (count > 0) steer.div((float)count);
      return steer;
    }

  PVector corporalWall (ArrayList<Person> person, String wall) {
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    float rij = 20;
    for (Person other : person) {
      PVector point = new PVector(0,0,0);
      float dij = 100;
      float j;
      for(int i = 0; i < 600; i++){
        if(wall == "sup") j =(i*226/600); 
        else j = (-i*226/600) + 500; 
        PVector other2 = new PVector(i,j);
        float dif = PVector.dist(location, other2);
        if(dif  < dij){
           dij = dif;
           point = new PVector(i,j);   
        }
      }
      if((dij > 0) && (dij < rij)) {
        PVector nij = PVector.sub(location, point);
        nij.div(dij);
        nij.div(dij);
        nij.mult(2*kMin*(rij - dij));
        nij.normalize();
        steer.add(nij);
        count++; }
    }
      if (count > 0) steer.div((float)count);
      return steer;
    }

PVector friccionWall (ArrayList<Person> person, String wall) {
    float rij = 20.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    for (Person other : person) {
      PVector point = new PVector(0,0,0);
      float dij = 100;
      float j;
      for(int i = 0; i < 600; i++){
        if(wall == "sup") j =(i*226/600); 
        else j = (-i*226/600) + 500; 
        PVector other2 = new PVector(i,j);
        float dif = PVector.dist(location, other2);
        if(dif  < dij){
           dij = dif;
           point = new PVector(i,j);   
        }
      }
      if((dij > 0) && (dij < rij)) {
        PVector nij = PVector.sub(location, point);
        nij.div(dij);
        PVector velocityP = new PVector(0,0,0);
        PVector vij = PVector.sub(velocity, velocityP);
        PVector tij =new PVector(-nij.x, nij.y);
        vij.dot(tij);
        vij.mult(kMay*(rij - dij));
        vij.cross(tij);
        vij.normalize();
        steer.add(vij);
        count++;      }
    }
    if (count > 0)  steer.div((float)count);
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
  void arrive(PVector target, PVector target2) {
    PVector desired =   new PVector(0,0,0);
    float desired2 = PVector.dist(target, location); 
    float desired3 = PVector.dist(target2, location);
    
    if(desired2 < desired3) desired = PVector.sub(target, location); 
    else desired = PVector.sub(target2, location); 
    float d = desired.mag();
    desired.normalize();
    if (d < 100) {
      float m = map(d, 0, 200, 0, maxspeed);
      desired.mult(m);
    } else desired.mult(maxspeed);
    
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
