function [Yo,Uo] = Recortador(Yi, Ui, eq, var)
%RECORTADOR(Yi, Ui, eq, var)
%   Recorta los valores del vector Yi y Ui en torno al punto de equilibrio.
%
%   Ecuación del tipo y(k) = f(u(k), ...). Yi es el vector [y(1) ... y(n)]'
%   y Ui = [u(1) ... u(n)]'. Recorta los valores de la salida Yi y la entrada
%   Ui para que los valores de Yi sean todos en torno al equilibrio con una
%   desviación máxima de la variación, es decir, eq +- var. Yi pasa a ser
%   Yo; y Ui, Uo.

if size(Yi) ~= size(Ui) 
    error('Tamaños de Yi y Ui distintos');
end

if ~isvector(Yi)
    error('Los vectores deben ser vectores');
end
contador = 0;
for i = 1:length(Yi)
    if abs(Yi(i) - eq) <= var
        contador = contador + 1;
    else
       Yo = Yi(1:contador);
       Uo = Ui(1:contador);
       break;
    end
end
end

