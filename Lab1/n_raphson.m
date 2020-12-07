function resultado = n_raphson(pol,p0,n,err)

p = p0 - polyval(pol,p0)/polyval(polyder(pol),p0);
e = abs((p - polyval(pol,p0))/polyval(polyder(pol),p));

if n > 0 && err < e
    p0 = n_raphson(pol,p,n-1,err);
else
    resultado = p0;  
end
resultado = p0;
end

