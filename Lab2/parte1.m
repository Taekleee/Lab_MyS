%Se designa a la variable 's' como la variable independiente de la función
%de transferencia
s = tf('s');
%primera ecuación
H1 = 8*s/(6*s+2);

%Se genera el lazo cerrado para la ecuación H1. 
%para el caso de lazo abierto la ecuación se utiliza tal cual está.
lazo1 = feedback(H1,1);

%Se grafica el lazo abierto y el lazo cerrado.
step(H1, lazo1)

%Se obtienen los ceros y las ganancias estáticas para la función
%de lazo abierto y lazo cerrado.
[Z1, gain1] = zero(H1);
[Z2, gain2] = zero(lazo1);
%Se obtienen los polos para la función de lazo abierto y lazo cerrado
pole1 = pole(H1);
pole2 = pole(lazo1);
%Se obtiene la información referente al tiempo de estabilización
%de la función de lazo abierto y cerrado.
stepinfo(H1)
stepinfo(lazo1)

%segunda ecuación
H2 = (5*s^2+7*s+4)/(s^2+6*s+3);
%Se genera el lazo cerrado para la ecuación H2. 
%para el caso de lazo abierto la ecuación se utiliza tal cual está.
lazo2 = feedback(H2,1);

%Se grafica el lazo abierto y el lazo cerrado.
step(H2, lazo2)

%Se obtienen los ceros y las ganancias estáticas para la función
%de lazo abierto y lazo cerrado.
[Z3, gain3] = zero(H2);
[Z4, gain4] = zero(lazo2);

%Se obtienen los polos para la función de lazo abierto y lazo cerrado
pole3 = pole(H2);
pole4 = pole(lazo2);
%Se obtiene la información referente al tiempo de estabilización
%de la función de lazo abierto y cerrado.
stepinfo(H2)
stepinfo(lazo2)


