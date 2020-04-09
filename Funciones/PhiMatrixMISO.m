function [Phi, Yr] = PhiMatrixMISO(Y, U, format, Vb)
%PHIMATRIXMISO(Y, [U(1) ... U(N)], format)
%   Matriz X (Phi) del Takagi-Sugeno
%
%   Ecuación del tipo y(k) = a0 + a1y(k-1) + ... + aoy(k-o) + b1u(1)(k-1) +
%   ... + bou(1)(k-o) + ... + b1u(N)(k-1) + ... + bou(N)(k-o), donde o es 
%   el orden del sistema. Y es el vector [y(1) ... y(n)]' y U = [u(1) ... 
%   u(n)]'. 
%   
%   Devuelve la matriz phi formada por los valores [ 1 y(o) y(n-1) 
%   ... y(1) u(1)(o) ... u(1)(1) ... u(N)(o) ...  u(N)(1); 1 y(o+1) y(o) 
%   ... y(2) u(1)(o+1) ... u(1)(2) ... u(N)(o+1) ...  u(N)(2); ... ; 1 
%   y(n-1) y(n-2) ... y(n-o) u(1)(n-1) ... u(1)(n-o) ... u(N)(n-1) ... 
%   u(N)(n-o)], así como el vector de Y real (Yr) para el mínimos 
%   cuadrados.
% 
%   format es una matriz de dimensiones (número de entradas + 1 ) x (orden 
%   máximo) que en cada fila indica cuáles son los parámetros a considerar.
%   La primera fila son a0 a1 ... an, y las siguientes b10 b11 ... b1n, b20
%   b21 ... b2n, etcétera, indicando 1 si se quiere y 0 si no.

%% Inicio
% Y columna, U columna x n
nU = size(U,2);
n = length(Y);
orden = size(format,2) - 1;
format = boolean(format);

%% Comprobación de errores
if isrow(Y)
    Y = Y';
    U = U';
elseif ~iscolumn(Y)
    error('Y debe ser un vector');
end


for i = 1:nU
    if n ~= size(U,1)
        error('Las entradas deben tener la misma longitud que la salida')
    end
end

if size(format,1) ~= nU + 1
    error('format debe ser una matriz de tamaño (número de entradas + 1 ) x (orden máximo)');
end


%% Inicialización

num_columnas = sum(format, 'all');
num_filas = n - orden;

Phi = zeros(num_filas, num_columnas);
Yr = Y(orden + 1:end, 1);
row = zeros(1, num_columnas);

%% Creación de la matriz
for i = 1:num_filas % i = fila
    j = 1; % j = columna
    
    % primero, las y
    if format(1,1) == 1
        row(1) = 1;
        j = j + 1;
    end

    for k = 2:size(format,2) % k = columna de format
        if format(1,k) == 1
            row(j) = Y(orden + i - k + 1);
            j = j + 1;
        end
    end
    
    %ahora, las U 
    
    for l = 2:nU + 1% l = fila de format
        for k = 1:size(format,2)
            if format(l,k) == 1
                row(j) = U(orden + i - k + 1, l - 1);
                j = j + 1;
            end
        end
    end
    
    Phi(i,:) = row;
end

end

