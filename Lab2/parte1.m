s = tf('s');
%primera ecuación
H1 = 8*s/(6*s+2);
lazo1 = feedback(H1,1);

%gráficos
step(H1, lazo1)

%info
[Z1, gain1] = zero(H1);
[Z2, gain2] = zero(lazo1);
pole1 = pole(H1);
pole2 = pole(lazo1);
stepinfo(H1)
stepinfo(lazo1)

%segunda ecuación
H2 = (5*s^2+7*s+4)/(s^2+6*s+3);
lazo2 = feedback(H2,1);

%gráficos
step(H2, lazo2)

%info
[Z3, gain3] = zero(H2);
[Z4, gain4] = zero(lazo2);
pole3 = pole(H2);
pole4 = pole(lazo2);
stepinfo(H2)
stepinfo(lazo2)


