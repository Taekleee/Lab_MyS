%Se calcula el modelo de estado dada una entrada predeterminada.
%a1 = 2
%a2 = 4
%r1 = 0.25
%r2 = 0.0625
H = lab3_parte2(2, 4, 0.25, 0.0625);

%Se genera un conjunto de 5000 puntos t entre 0 a 12pi.
t = linspace(0,12*pi,5000);
%Se genera una función de entrada u sinusoidal con los puntos t
u = 100*sin(t/4);
%Se vuelve 0 todos los valores negativos de u
u(u<0) = 0.;

%se evalua el modelo de estado con un escalon
step(H)

%se evalua el modelo de estado con un impulso
impulse(H)

%se evalua el modelo de estado con la funcion u
lsim(H,u,t)