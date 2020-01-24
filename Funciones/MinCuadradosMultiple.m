function [param, phi, Yr] = MinCuadradosMultiple(orden, varargin)
%MINCUADRADOSMULTIPLE(orden, Y1, U1, ..., Yn, Un)
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

if mod(length(varargin), 2) == 1
    error('Debe pasarse un número par de argumentos Y U');
end

phi = [];
Yr = [];

%BUCLE DE PHI Y ANIDADOR DE Y
for j = 1:length(varargin)/2
    Y = varargin{2 * j - 1};
    U = varargin{2 * j};
    if size(Y) ~= size(U) 
        error('Tamaños de Y y U distintos');
    elseif isrow(Y)
        Y = Y';
        U = U';
    elseif ~iscolumn(Y)
        error('Y y U deben ser vectores');
    end
    
    if length(Y) <= orden
        error('La longitud del vector debe ser mayor que el orden');
    else
        n = length(Y);
        % Mejorable
        phi = [phi; PhiMatrix(Y, U, orden)];
        Yr = [Yr; Y(orden + 1 : n)];
    end
end
    param = phi\Yr;
end
