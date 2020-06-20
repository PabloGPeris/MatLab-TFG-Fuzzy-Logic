function [A, B, C, D, ax, ay] = C_Observable_MISO(a, b, a0, b0)
%C_OBSERVABLE_MISO(a, b, a0, b0) Crea las matrices del modelo de estados de la 
%forma can�nica observable
%
%Se tiene en cuenta que a1 se corresponde con Yz^(n-1), a2 con Yz^(n-2),
%... an con Y, y lo mismo para bi.
%Ahora vale para MISO (no probado en todos los casos)

%% Comprobaci�n de errores

if length(a) ~= length (b)
    err('a y b deben coincidir en dimensi�n');
    return7
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

%% Creaci�n de matrices

n = length(a);


A = [a [ eye(n - 1) ; 
        zeros(1, n-1)]];
                 
                   
B = b + kron(a, b0); %No s� si esto est� bien (si se usa D, habr�a que mirarlo)

C = eye(1, length(A));


D = b0;


%% T�rminos independientes
ax = a*a0;

ay = a0;

end

