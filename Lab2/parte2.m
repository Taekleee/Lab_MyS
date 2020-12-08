%La implementación que se presenta a continuación corresponde al modelado
%del diagrama de bloques en matlab. 

% s = variable a usar por las funciones de transferencia.
s = tf ('s')

%Hi = representa cada una de las funciones de transferencia, desde H1 hasta
%H6, es decir, cada bloque que aparece en el diagrama. 
H1 =  (8*s)/(4*s + 6)
H2 = 6/(s+5)
H3 = (4*s + 3)/(3*(s^3) + 5*(s^2)+1)
H4 = 6/(7*s + 1)
H5 = (5*s+3)/(5*(s^3) + (s^2)+4)
H6 = (5*s + 1)/((s^3) + 6*(s^2)+5)

%Pi = Corresponde a las divisiones realizadas para lograr obtener la
%función de transferencia final. 

P1 = feedback(H3,1,+1)
P2 = P1*H4
P3 = P1*H5
P4 = (P2 + P3)*H6

% result = es la función de transferencia del sistema
result = H1 + H2 + P4
step(result)
grid on