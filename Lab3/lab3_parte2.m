
%Función que calcula el modelo de estado de los vasos comunicantes
%dado el area del primer vaso (a1), el area del segundo vaso (a2)
%la resistencia de la salida del primer vaso (r1) y la resistencia
%de la salida del segundo vaso (r2)
function x = lab3_parte2(a1, a2, r1, r2)
    %Se calcula la matriz A del modelo de estado
    A = [-1/(a1*r1), 1/(a1*r1);1/(a2*r1),  ((-1/(a2*r1)) - (1/(a2*r2)))];
    
    %Se calcula la matriz B del modelo de estado
    B = [1/a1; 0];
    
    %Se calcula la matriz C del modelo de estado
    C = [1, 0; 0, 1];
    
    %Se calcula la matriz D del modelo de estado
    D = [0;0];
    
    %Se genera el modelo de estado en función de las matrices A, B, C y D
    x = ss(A,B,C,D);
end
