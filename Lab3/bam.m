%La función bam permite obtener las matrices del modelo de estado a partir de los coeficientes que acompañan
%a las funciones de transferencia del diagrama de bloque
%Entradas: 
%a: Corresponde al numerador de la primera función de transefrencia
%b: Corresponde al primer término del denominador de la primera función de
%transferencia
%c: Corresponde al segundo término del denominador de la primera función de
%transferencia. 
%d: Corresponde al numerador de la segunda función de transefrencia
%e: Corresponde al primer término del denominador de la segunda función de
%transferencia
%f: Corresponde al segundo término del denominador de la segunda función de
%transferencia. 

function [A,B,C,D] = bam(a,b,c,d,e,f)
%Debido a los despejes que se realizan para obtener las matrices, es que
%los valores de A (1,1), (1,2) y (2,2) deben ser multiplicados por -1
A = [c/b*-1 a/b*-1; d/e f/e*-1];
B = [a/b; 0];
C = [1 0];
D = [0;0];

end