%Primero se reciben los valores de las funciones de transferencia que tiene
%el sistema y se calculan las matrices con la función bam
[A,B,C,D] = bam(1,2,3,2,5,-1)
%Luego son ingresadas las matrices a la función mab y se calcula la función
%de transferencia que describe a todo el sistema 
 H = mab(A,B,C,D)