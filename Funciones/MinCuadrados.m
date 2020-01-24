function [param, phi, Yr] = MinCuadrados(orden, Y, U)
%MINCUADRADOS(orden, Y, U)
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

%Comprobaci�n de errores
if size(Y) ~= size(U) 
    error('Tama�os de Y y U distintos');
end
if isrow(Y)
    Y = Y';
    U = U';
elseif ~iscolumn(Y)
    error('Y y U deben ser vectores');
end
if size(Y,1)<= orden
    error('La longitud del vector debe ser mayor que el orden');
end

%Hacer la matriz phi y los par�metros
n = size(Y, 1);
phi = PhiMatrix(Y, U, orden);
Yr = Y(orden + 1 : n);

param = phi\Yr;

%pinv = (phi' * phi)\phi';

%param = pinv * Y(orden + 1 : n);


end
