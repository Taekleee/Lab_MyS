function value = formula(vector)

if (any(vector<0))
   error('El vector contiene valores negativos') 
end
if (length(vector)<4)
    error('El vector debe ser de almenos tamaño 4')
end
vector = sort(vector);
lowest = vector(1:4);
highest = vector(length(vector)-3:end);

value = sqrt(sum(highest)) - sqrt(sum(lowest))

end