class Person {
  PVector location; //Posición en la que se encuentra la persona
  PVector velocity; //Velocidad de movimiento de la persona
  PVector acceleration; //Aceleración de la persona
  float r; //Radio del círculo que representa a la persona
  float maxforce; //Máxima fuerza que se puede ejercer
  float maxspeed; //Máxima velocidad que se puede estar

  /*
  Entrada: Posición X y posición Y de la persona en la simulación
  Se instancia a la persona en la posición indicada.
  */
  Person(float x, float y) {
    acceleration = new PVector(0,0);
    velocity = new PVector(5,4);
    location = new PVector(x,y);
    r = 10;
    maxspeed = 1.3;
    maxforce = 3.0;
  }

/* Entrada: lista con las personas
   Proceso: se establece el target más cercano, luego se calculan las fuerzas, se actualizan, se limitan los bordes y
   finalmente se despliega.
*/
  void run(ArrayList<Person> person) {
    arrive(target, target2, target3);
    people(person);
    update();
    borders();
    display();
  }
  /* Entrada: -
   Proceso: se actualiza la velocidad y locación y se limita la velocidad.
*/
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
  
  /* Entrada: lista con las personas
   Proceso: Se calculan todas las fuerzas que afectan a las personas y luego se multiplican para asignar una 
   magnitud a cada fuerza.
*/
  void people(ArrayList<Person> person) {
      PVector sep = separate(person);// Fuerza de separación
      PVector cor = corporal(person);// Fuerza corporal 
      PVector fric = friccion(person);// Fuerza de fricción
      
      PVector sepSup = separateWall(person, "sup");//Fuerza de separación pared superior
      PVector corSup = corporalWall(person, "sup");// Fuerza corporal pared superior
      PVector fricSup = friccionWall(person, "sup");// Fuerza de fricción pared superior
      
      PVector sepInf = separateWall(person, "inf");//Fuerza de separación pared inferior
      PVector corInf = corporalWall(person, "inf");//Fuerza corporal pared inferior
      PVector fricInf = friccionWall(person, "inf");//Fuerza de fricción pared inferior
      
     
      //Fuerzas entre personas       
      sep.mult(10.0);
      cor.mult(5.0);
      fric.mult(2.0);
      
      //Fuerzas pared superior
      sepSup.mult(5.0);
      corSup.mult(0.5);
      fricSup.mult(0.5);      
      
      //Fuerzas pared inferior
      sepInf.mult(5.0);
      corInf.mult(0.5);
      fricInf.mult(0.5);
      
      
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
    /* Entrada: lista con las personas
     Proceso: Se compara a cada persona con todas las demás y si la distancia entre ellas es menor a R se calcula la
     fuerza de repulsión.
*/
    PVector separate (ArrayList<Person> person) {
    float desiredseparation = 60.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    float rij = 20.0f;
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
        else{ 
          PVector cero = new PVector(0,0,0);
          steer.add(cero);
        }
    }
      if (count > 0) steer.div((float)count);
      return steer;
    }

   //**********************************************************************
    // Fuerzaz corporal
    /* Entrada: lista con las personas
     Proceso: Se calcula la fuerza que se produce cuando dos personas chocan, para ellos se calcula la
     distancia entre cada persona y el resto, y de ser mayor al radio de acción se calcula la fuerza.
*/
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
        else{ 
          PVector cero = new PVector(0,0,0);
          steer.add(cero);
      }
    }
      if (count > 0) steer.div((float)count);
      return steer;
    }

   //**********************************************************************
    // Fuerza de fricción
    /* Entrada: lista con las personas
   Proceso: Cuando la distancia entre dos personas es mejor a rij significa que chocan, por lo
   tanto se calcula la fuerza de fricción, de lo contrario el valor de esta fuerza es 0.
*/
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
          else{ 
            PVector cero = new PVector(0,0,0);
            steer.add(cero);
          }
    }
      if (count > 0) steer.div((float)count);
      return steer;
    }

 //**********************************************************************
 //                         FUERZAS PAREDES 
 //**********************************************************************    
 /* Para el caso de las paredes ocurre lo mismo que entre las personas, es decir,
 se aplican la fuerza de separación entre la persona y la pared y en caso de chocar con
 ella se calculan las fuerzas de fricción y corporal
 */
 
PVector separateWall (ArrayList<Person> person, String wall) {
    float desiredseparation = 60.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    for (Person other : person) {
      PVector point = new PVector(0,0,0);
      float dij = 100;
      float j;
      for(int i = 0; i < 600; i++){
        if(wall == "sup"){ j =(i*113/300) - 20;} 
        else j = (-i*113/300) + 500; 
        PVector other2 = new PVector(i,j);
        float dif = PVector.dist(location, other2);
        if(dif  < dij){
           dij = dif;
           point = new PVector(i,j);   
        }
      }
      if((dij > 0) && (dij < desiredseparation)) {
        float rij = 20.0f;
        PVector nij = PVector.sub(location, point);
        nij.div(dij);
        float exponente = (-(dij- rij))/B;
        if(exponente > 0) exponente = -exponente;
        float mult = exp(exponente)*A;
        nij.mult(mult);
        nij.normalize();
        steer.add(nij);
        count++;} 
      else{ 
          PVector cero = new PVector(0,0,0);
          steer.add(cero);}
      }
      if (count > 0) steer.div((float)count);
      return steer;
    }

  PVector corporalWall (ArrayList<Person> person, String wall) {
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    float rij = 20.0f;
    for (Person other : person) {
      PVector point = new PVector(0,0,0);
      float dij = 100;
      float j;
      for(int i = 0; i < 600; i++){
        if(wall == "sup") j =(i*113/300) - 20; 
        else j = (-i*113/300) + 500; 
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
       else{ 
          PVector cero = new PVector(0,0,0);
          steer.add(cero);
      }
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
        if(wall == "sup") j =(i*113/300)- 20; 
        else j = (-i*113/300) + 500; 
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
        else{ 
          PVector cero = new PVector(0,0,0);
          steer.add(cero);
      }
    }
    if (count > 0)  steer.div((float)count);
      return steer;
    }

    
  
 //**********************************************************************
 //Si se llega al objetivo la persona vuelve a entrar por el extremo izquierdo
 
  void borders(){
    if(location.x >= 600 ) location.x = 0;
  }
  
  //**********************************************************************
  /* Entrada: Puntos objetivos
   Proceso: Se calcula la distancia entre cada persona y los tres objetivos existentes (dependiendo si se encuentra de
   frente a la salida, en la parte superior o inferior), luego se establece como objetivo aquella que se encuentre más 
   cercana y finalmente se calcula la fuerza ejercida.
*/
  void arrive(PVector target, PVector target2, PVector target3) {
    PVector desired =   new PVector(0,0,0);
    float desired2 = PVector.dist(target, location); 
    float desired3 = PVector.dist(target2, location);
    float desired4 = PVector.dist(target3,location);
    if(desired2 < desired3 & desired2 < desired4) {
      desired = PVector.sub(target, location); 
    }
    else if(desired3 < desired2 & desired3 < desired4){
      desired = PVector.sub(target2, location); 
    }
    else{desired = PVector.sub(target3, location);
    }
    float d = desired.mag();
    desired.normalize();
    desired.mult(maxspeed);
    
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
    circle(r,r, 2*r);
    endShape(CLOSE);
    popMatrix();
  }
}
