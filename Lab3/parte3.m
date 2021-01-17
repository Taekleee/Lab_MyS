%Se llama a la función discretizar, variando el tiempo de muestreo y el
%tipo de discretización que se quiera, en donde: 
%zof = zero order hold
%foh = first order hold

discretizar(2, 'zoh')
discretizar(2, 'foh')
discretizar(0.1, 'zoh')
discretizar(0.1, 'foh')
discretizar(0.001, 'zoh')
discretizar(0.001, 'foh')