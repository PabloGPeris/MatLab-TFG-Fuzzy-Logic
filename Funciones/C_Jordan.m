function [A, B, C, D, ax, ay] = C_Jordan(a, b, a0, b0)
%C_CONTROLABLE Crea las matrices del modelo de estados de la forma de
%Jordan
%
%Se tiene en cuenta que a1 se corresponde con Yz^(n-1), a2 con Yz^(n-2),
%... an con Y, y lo mismo para bi. No se consideran polos múltiples.


if size(a) ~= size(b)
    err('a y b deben coincidir en dimensión');
    return
elseif ~isscalar(a0)
    err('a0 debe ser un escalar (Considere introducir un 0)');
elseif ~isscalar(b0)
    err('b0 debe ser un escalar (Considere introducir un 0)');
end

if iscolumn(a)
    a = a';
    b = b';
elseif ~isrow(a)
    error('a y b deben ser vectores');
end

n = length(a);



[rho, ~, ~] = residue([b0 b],[1 -a]);
[res, polos, ~] = residue([a0 zeros(1, n)],[1 -a]);


A = diag(polos);
B = rho;
C = ones(1,n);
D = b0;

% Términos independientes
ay = a0;
ax = res;

end

