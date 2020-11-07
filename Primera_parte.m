%Rango de valores
x = 0:0.01:15*pi;

%Función 1

f1 = 8*(log(4*x + 12)/log(5));

%Función 2

f2 = sin((6)*((log(x+9)/log(2)))) + cos(7*(log(4*x+32)/log(6)));


%Gráfico función 1
plot(x,f1, 'r *')
title('Gráfico función a(x)')
xlabel('x')
ylabel('a(x)')

%Gráfico función 2
plot(x,f2, 'g +')
title('Gráfico función b(x)')
xlabel('x')
ylabel('b(x)')


%Gráfico en conjunto

hold on 

plot(x,f1, 'r *')
plot(x,f2, 'g +')
title('Gráfico a(x) y b(x)')
xlabel('x')
ylabel('y(x)')
legend('a(x)','b(x)')

hold off

%Función 3

x2 = -10:0.05:10;
f3 = 6*exp(x2+18);

%Gráfico normal f3 
plot(x2,f3, 'b .')
title('Gráfico función c(x)')
xlabel('x')
ylabel('c(x)')


%Gráfico función 3 escala logarítmica 
semilogy(x2,f3, 'b .')
title ( 'Gráfico función c(x) en escala logarítmica' )
xlabel('x')
ylabel('c(x)')