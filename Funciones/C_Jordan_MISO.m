function [A, B, C, D, ax, ay] = C_Jordan_MISO(a, b, a0, b0)
%C_CONTROLABLE Crea las matrices del modelo de estados de la forma de
%Jordan
%
%Se tiene en cuenta que a1 se corresponde con Yz^(n-1), a2 con Yz^(n-2),
%... an con Y, y lo mismo para bi. No se consideran polos múltiples.


%% Comprobación de errores

if length(a) ~= length (b)
    err('a y b deben coincidir en dimensión');
    return
elseif ~isscalar(a0)
    err('a0 debe ser un escalar (Considere introducir un 0)');
end

if isrow(a)
    a = a';
    b = b';
    b0 = b0';
elseif ~iscolumn(a)
    error('a debe ser vector');
end

%% Creación de matrices

n = length(a);
m = size(b,2);

rho = zeros(n,m);
for i = 1:m
    [rho(:,i), ~, ~] = residue([b0(i) b(:,i)'],[1 -a']);
end
[res, polos, ~] = residue([a0 zeros(1, n)],[1 -a']);


A = diag(polos);
B = rho;
C = ones(1,n);
D = b0;

%% Términos independientes
ay = a0;
ax = res;

end

