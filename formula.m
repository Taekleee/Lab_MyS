n = input('Ingrese el tamaño del vector: ');
i = 1;
while i <= n 
    vector(1,i) = input(sprintf('Ingrese valor de la posición %d: ', i));
    i = i+1;
end


if (any(vector<0))
   error('El vector contiene valores negativos') 
end
if (length(vector)<4)
    error('El vector debe ser de almenos tamaño 4')
end
vector = sort(vector);
lowest = vector(1:4);
highest = vector(length(vector)-3:end);

value = sqrt(sum(highest)) - sqrt(sum(lowest));

sprintf('El resultado es: %d', value)

