 H = lab3_parte2(2, 4, 0.25, 0.0625);
 t = linspace(0,12*pi,5000);
 u = 100*sin(t/4);
 u(u<0) = 0.;
 
 step(H)
 impulse(H)
 lsim(H,u,t)