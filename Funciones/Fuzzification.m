function mu = Fuzzification(x, px)
%FUZZIFICATION(x, px) 
% Definida una función de pertenencia mu sobre una variable x, con
% parámetros px, devuelve el vector de pertenencia de la variable x a cada
% una de las etiquetas linguísticas

if iscolumn(px)
    px = px';
elseif ~isrow(px)
    error('px debe ser un vector');
end

if ~isscalar(x)
    error('x debe ser escalar');
end

mu = zeros(size(px)); 

N = length(px);

if x <= px(1)
    mu(1) = 1;
elseif x >= px(N)
    mu(N) = 1;
else
    i = 1;
    while(1)
        if x >= px(i) && x < px(i + 1)
            mu(i + 1) = (x - px(i))/(px(i + 1) - px(i));
            mu(i) = 1 - mu(i + 1);
            return;
        end
        i = i + 1;
    end
end

end

