function [param, phi, Yr] = MinCuadradosMultiple(orden, U, Y)
%MINCUADRADOSMULTIPLE(orden, {U1, ..., Un}, {Y1, ..., Yn})
%   M�nimos cuadrados de un sistema discreto de una ecuaci�n en diferencias
%
%   Ecuaci�n del tipo y(k) = a0 + a1y(k-1) + ... + aoy(k-o) + b1u(k-1) +
%   ... + bou(k-o), donde o es el orden del sistema. Y es el vector [y(1)
%   ... y(n)]' y U = [u(1) ... u(n)]'. Devuelve los par�metros a0, a1
%   ... ao,  b1, b2 ... bo (param), as� como la matriz phi formada por
%   los valores [ 1 y(o) y(n-1) ... y(1) u(o) ... u(1) ; 1 y(o+1) y(o) ...
%   y(2) u(o) ... u(2); ... ; 1 y(n-1) y(n-2) ... y(n - o) u(n-1) ...
%   u(n-o)]. Tambi�n devuelve el vector de salidas Yr formado por [y(o+1)
%   y(o+2) ... y(n)]'.
%
%   Se diferencia en que ejecuta los m�nimos cuadrados de varias partes
%   inconexas del experimento, o varias (n) de ellos, representados en Y1, 
%   U1, Y2, U2, ..., Yn, Un.

%% Errores

if ~iscell(Y)
    error('Y debe pasarse en formato cell');
elseif ~iscell(U)
    error('U debe pasarse en formato cell');
end

if size(Y) ~= size(U)
        error('U e Y deben tener el msimo tama�o');
end

if isrow(Y)
    Y = Y';
    U = U';
elseif ~iscolumn(Y)
    error('Y debe ser vector');
end


heightphi = 0;
for i = 1:length(U)
    if length(U{i}) > orden
        heightphi = heightphi + length(U{i}) - orden;
    end
end

phi = zeros(heightphi, 2*orden + 1);
Yr = zeros(heightphi, 1);
n = length(Y);

%% Bucle de phi y anidador de Y real

k1 = 1;
for i = 1:n
    if length(U{i}) <= orden
        continue;
    elseif size(Y{i}) ~= size(U{i}) 
        error('U{i} e Y{i} deben tener el msimo tama�o');
    elseif isrow(Y)
        Y = Y';
        U = U';
    elseif ~iscolumn(Y)
        error('Y{i} y U{i} deben ser vectores');
    end
    k2 = k1 + length(U{i}) - orden - 1;
    % Mejorable
    phi(k1:k2,:) = PhiMatrix(U{i}, Y{i}, orden);
    Yr(k1:k2,:) = Y{i}(orden + 1 : end);
    k1 = k2 + 1;
end
    param = phi\Yr;
    err = Yr - phi * param;
    fprintf('Error = %d\n', sqrt(mse(err)));
end
