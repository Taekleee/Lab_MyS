%La función mab recibe como entradas las matrices del modelo de estado y
%retorna la función de transferencia del sistema. 
%Entradas: 
%A: primera matriz, en este caso de 2x2, correspondiente a la ecuación de
%las variables (\dot X = Ax + B)
%B: segunda matriz de la ecuación de las variables de entrada (\dot X = Ax + B)
%C: primera matriz de la ecuación de las salidas del sistema (Y = CX + DU)
%D: segunda matriz de la ecuación de las salidas del sistema (Y = CX + DU)
function [H] = mab(A,B,C,D)

s = tf ('s')
ident = [1 0; 0 1]
%En base a lo obtenido del desarrollo algebraico, la función de
%transferencia se calcula como: H = C*[(s*I-A)^(-1)]*B+D
part1 = (s*ident - A)
part2 = C*inv(part1)
part3 = part2*B
H = part3 + D

end