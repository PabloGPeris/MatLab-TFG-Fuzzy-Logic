function [A, B, C, D, ax, ay] = C_Observable(a, b, a0, b0)
%C_CONTROLABLE(a, b, a0, b0) Crea las matrices del modelo de estados de la 
%forma canónica observable
%
%Se tiene en cuenta que a1 se corresponde con Yz^(n-1), a2 con Yz^(n-2),
%... an con Y, y lo mismo para bi.

%% Comprobación de errores

if size(a) ~= size(b)
    err('a y b deben coincidir en dimensión');
    return
elseif ~isscalar(a0)
    err('a0 debe ser un escalar (Considere introducir un 0)');
elseif ~isscalar(b0)
    err('b0 debe ser un escalar (Considere introducir un 0)');
end

if isrow(a)
    a = a';
    b = b';
elseif ~iscolumn(a)
    error('a y b deben ser vectores');
end

%% Creación de matrices

n = length(a);



A = [a [ eye(n - 1) ; 
        zeros(1, n-1)]];
                 
                   
B = b + a*b0;

C = eye(1, n);

D = b0;


%% Términos independientes
ax = a*a0;

ay = a0;

end

