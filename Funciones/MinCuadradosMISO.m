function [param, phi, Yr] = MinCuadradosMISO(Y, U, format)
%MINCUADRADOSMISO({Y1, ..., Yn}, {[U(1) ... U(N)]1, ..., {[U(1) ... U(N)]n}, format)
%   Mínimos cuadrados de un sistema discreto de una ecuación en diferencias
%
%   Ecuación del tipo y(k) = a0 + a1y(k-1) + ... + aoy(k-o) + b1u(k-1) +
%   ... + bou(k-o), donde o es el orden del sistema. Y es el vector [y(1)
%   ... y(n)]' y U = [u(1) ... u(n)]'. Devuelve los parámetros a0, a1
%   ... ao,  b1, b2 ... bo (param), así como la matriz phi formada por
%   los valores [ 1 y(o) y(n-1) ... y(1) u(o) ... u(1) ; 1 y(o+1) y(o) ...
%   y(2) u(o) ... u(2); ... ; 1 y(n-1) y(n-2) ... y(n - o) u(n-1) ...
%   u(n-o)]. También devuelve el vector de salidas Yr formado por [y(o+1)
%   y(o+2) ... y(n)]'.
%
%   Se diferencia en que ejecuta los mínimos cuadrados de varias partes
%   inconexas del experimento, o varias (n) de ellos, representados en Y1, 
%   U1, Y2, U2, ..., Yn, Un.

%% Inicio

format = boolean(format);
orden = size(format,2) - 1;

%% Errores

if ~iscell(Y)
    [phi, Yr] = PhiMatrixMISO(Y, U, format);
    param = phi\Yr;
    return;
elseif ~iscell(U)
    error('U debe pasarse en el mismo formato que Y');
end

if size(Y) ~= size(U)
        error('U e Y deben tener el mismo tamaño');
end

if isrow(Y)
    Y = Y';
    U = U';
elseif ~iscolumn(Y)
    error('Y debe ser vector');
end

%% Inicialización

widthphi = sum(format, 'all');
heightphi = 0;

for i = 1:length(U)
    if length(Y{i}) > orden
        heightphi = heightphi + length(U{i}) - orden;
    end
end

phi = zeros(heightphi, widthphi);
Yr = zeros(heightphi, 1);
n = length(Y);

%% Bucle de phi y anidador de Y real

k1 = 1;
for i = 1:n
    if length(U{i}) <= orden
        continue;
    end
    k2 = k1 + length(U{i}) - orden - 1;
    
    [phi(k1:k2,:), Yr(k1:k2,:)] = PhiMatrixMISO(Y{i}, U{i}, format);
    k1 = k2 + 1;
end

    param = phi\Yr;
%     err = Yr - phi * param;
%     fprintf('Error = %d\n', sqrt(mse(err)));
end
