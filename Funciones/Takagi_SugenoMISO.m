function [param, phi, Yr] = Takagi_SugenoMISO(Y, U, format, Vb, FSet)
%TAKAGI_SUGENOMISO({Y1, ..., Yn}, {[U(1) ... U(N)]1, ..., {[U(1) ... U(N)]n}, format)
%  	Takagi de un sistema discreto de una ecuaci�n en diferencias
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

%% Inicio

format = boolean(format);
orden = size(format,2) - 1;

%% Errores

if ~iscell(Y)
    [phi, Yr] = FuzzyPhiMatrixMISO(Y, U, format, Vb, FSet);
    param = phi\Yr;
    return;
elseif ~iscell(U)
    error('U debe pasarse en el mismo formato que Y');
end

if size(Y) ~= size(U)
        error('U e Y deben tener el mismo tama�o');
end

if isrow(Y)
    Y = Y';
    U = U';
elseif ~iscolumn(Y)
    error('Y debe ser vector');
end

if isrow(Y{1})
    Y{1} = Y{1}';
    U{1} = U{1}';
    Vb{1} = Vb{1}';
elseif ~iscolumn(Y{1})
    error('Y debe ser un vector');
end

nV = size(Vb{1},2);

%% Inicializaci�n

widthphi = sum(format, 'all');
heightphi = 0;
num_pesos = 1;
for i = 1:nV + 1
   num_pesos = num_pesos * FSet(i).FSLength; 
end
widthphi = widthphi * num_pesos;


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
    
    [phi(k1:k2,:), Yr(k1:k2,:)] = FuzzyPhiMatrixMISO(Y{i}, U{i}, format, Vb{i}, FSet);
    k1 = k2 + 1;
end

    param = phi\Yr;
    
    % Falta gamma, c
%     err = Yr - phi * param;
%     fprintf('Error = %d\n', sqrt(mse(err)));
end
