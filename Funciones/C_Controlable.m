function [A, B, C, D, ax, ay] = C_Controlable(a, b, a0, b0)
%C_CONTROLABLE Crea las matrices del modelo de estados de la forma canónica
%controlable
%
%Se tiene en cuenta que a1 se corresponde con Yz^(n-1), a2 con Yz^(n-2),
%... an con Y, y lo mismo para bi.
%No está implementada la funcionalidad con a0
if size(a) ~= size(b)
    error('a y b deben coincidir en dimensión');
%elseif ~isscalar(a0)
%    err('a0 debe ser un escalar (Considere introducir un 0)');
elseif ~isscalar(b0)
    error('b0 debe ser un escalar (Considere introducir un 0)');
end


if iscolumn(a)
    a = a';
    b = b';
elseif ~isrow(a)
    error('a y b deben ser vectores');
end

n = length(a);

A = [ a;
    eye(n-1) zeros(n-1,1)];

 
B = eye(n,1);
  
C = b + b0*a;

D = b0;

ax = zeros(n,1);
ay = 0;
end
