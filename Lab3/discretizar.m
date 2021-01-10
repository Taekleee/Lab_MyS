%La función recibe como entrada el tiempo de muestreo que se desea utilizar
%y el tipo de discretización, es decir, zoh o foh. 
%retorna los gráficos generados para cada uno de los estanques. 
function [X] = discretizar(t_muestreo, type)
    M = lab3_parte2(2, 4, 0.25, 0.0625);
    M_z = c2d (M , t_muestreo , type)
    step ( M_z );
end