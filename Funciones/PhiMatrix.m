function phi = PhiMatrix(Y, U, orden)
%PHIMATRIX(Y, U, orden)
%   Matriz Phi de los mínimos cuadrados
%
%   Ecuación del tipo y(k) = a0 + a1y(k-1) + ... + aoy(k-o) + b1u(k-1) +
%   ... + bou(k-o), donde o es el orden del sistema. Y es el vector [y(1)
%   ... y(n)]' y U = [u(1) ... u(n)]'. Devuelve la matriz phi formada por
%   los valores [ 1 y(o) y(n-1) ... y(1) u(o) ... u(1) ; 1 y(o+1) y(o) ...
%   y(2) u(o) ... u(2); ... ; 1 y(n-1) y(n-2) ... y(n - o) u(n-1) ...
%   u(n-o). No tiene sistema de seguridad, se da por hecho en la fucnión
%   MinCuadrados o similar.

n = length(Y);
m = n - orden;

phi1 = zeros(m,orden);
for i = 1:orden
phi1(:,i) = Y(orden + 1 - i : n  - i);
end

phi2 = zeros(m,orden);
for i = 1:orden
phi2(:,i) = U(orden + 1 - i : n  - i);
end

phi = [ones(m, 1) phi1 phi2];
end

