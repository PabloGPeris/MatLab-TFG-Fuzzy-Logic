function output = Normalizacion(vector, mode, varargin)
%NORMALIZACION(vector, mode, parámetros)
%   Normaliza el vector según el modo:
%   'rango' -> parámetros min, max. Output entre -1 Y 1
%   'normal' -> resta la media y divide por la desviación típica. Output
%   entre -3 y 3 aprox.

if ~isvector(vector)
    error('vector debe ser un vector');
end

if strcmp(mode, 'normal')
    if nargin~=2
        error('debe haber 2 argumentos en modo normal');
    end
    output = (vector - mean(vector))/std(vector);
elseif strcmp(mode, 'rango')
    if nargin~=4
    	error('debe haber 4 argumentos en modo rango');
    end
    min = varargin{1};
    max = varargin{2};
    output = -1 + 2*(vector - min)/(max-min);
else
    error('modo no válido');
end
end

