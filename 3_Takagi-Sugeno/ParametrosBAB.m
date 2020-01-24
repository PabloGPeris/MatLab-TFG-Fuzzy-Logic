function [a, b] = ParametrosBAB(m, g, r, Ib, Iw, bfr, K, l)
%PARAMETROSBAB



a(1) = m + Ib / r^2;
a(2) = (m * r^2 + Ib) / r;
a(3) = m*g;

b(1) = Ib + Iw;
b(2) = 2 * m;
b(3) = bfr * l^2;
b(4) = K * l^2;
b(5) = a(2);
b(6) = a(3);

end

