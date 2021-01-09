function x = lab3_parte2(a1, a2, r1, r2)
    A = [-1/(a1*r1), 1/(a1*r1);1/(a2*r1),  ((-1/(a2*r1)) - (1/(a2*r2)))];
    B = [1/a1; 0];
    C = [1, 0; 0, 1];
    D = [0;0];
    x = ss(A,B,C,D);
end
