function [param, phi, Yr] = Takagi_SugenoMISO(Y, U, format, Vb, FSet, c, linearparam)
%TAKAGI_SUGENOMISO({Y1, ..., Yn}, {[U(1) ... U(N)]1, ..., {[U(1) ... U(N)]n}, format, {[Vb1 ... VbN]1 ... {[Vb1 ... VbN)n}, c, parámetros lineales)
%  	Takagi de un sistema discreto de una ecuación en diferencias
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
%   Devuelve los parámetros a0, a1 ... ao,  b1, b2 ... bo (param).
%   Y devuelve la matriz phi (x) formada por los valores [ beta1...1(1 y(o) 
%   y(n-1) ... y(1) u(o) ... u(1)) beta1...2(1 y(o) y(n-1) ... y(1) u(o) 
%   ... u(1))]; 1 y(o+1) y(o) ... y(2) u(o) ... u(2); ... ; 1 y(n-1) y(n-2)
%   ... y(n - o) u(n-1) ... u(n-o). Se considera en este caso que beta = w 
%   (peso).

%% Inicio

format = boolean(format);
orden = size(format,2) - 1;

%% Errores

if ~iscell(Y)
    [phi, Yr] = FuzzyPhiMatrixMISO(Y, U, format, Vb, FSet);
    
    if isrow(Y)
        Vb = Vb';
    end
    
    nV = size(Vb,2);
    num_pesos = 1;
    for i = 1:nV
        num_pesos = num_pesos * FSet(i).FSLength; 
    end
    
    gamma_2 = c*norm(phi'*Yr) / norm(linearparam);
    param = (phi'*phi + gamma_2*eye(size(phi,2)))\(phi'*Yr + gamma_2*repmat(linearparam,num_pesos,1));
%     param = phi\Yr;
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

if isrow(Y{1})
    Y{1} = Y{1}';
    U{1} = U{1}';
    Vb{1} = Vb{1}';
elseif ~iscolumn(Y{1})
    error('Y debe ser un vector');
end

nV = size(Vb{1},2);

%% Inicialización

widthphi = sum(format, 'all');
heightphi = 0;
num_pesos = 1;
for i = 1:nV
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
    %Zona final de gamma
    


%% Fin

    gamma_2 = c*norm(phi'*Yr) / norm(linearparam);
    param = (phi'*phi + gamma_2*eye(widthphi))\(phi'*Yr + gamma_2*repmat(linearparam,num_pesos,1));
    
%     param = phi\Yr;
    
%     err = Yr - phi * param;
%     fprintf('Error = %d\n', sqrt(mse(err)));
end
