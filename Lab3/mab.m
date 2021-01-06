function [H] = mab(A,B,C,D)

s = tf ('s')
ident = [1 0; 0 1]

part1 = (s*ident - A)
part2 = C*part1
part3 = part2*B
H = part3 + D

end