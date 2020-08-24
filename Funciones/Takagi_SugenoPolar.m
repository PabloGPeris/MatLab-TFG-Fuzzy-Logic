function [param, phi, Yr] = Takagi_SugenoPolar(Y, U, format, Vb, FSetArg, FSetMod, c, linearparam)
%TAKAGI_SUGENOMISO({Y1, ..., Yn}, {[U(1) ... U(N)]1, ..., {[U(1) ... U(N)]n}, format, Vb, FSetArg, FSetMod, c, par�metros lineales)
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
%   Devuelve los par�metros a0, a1 ... ao,  b1, b2 ... bo (param).
%   Y devuelve la matriz phi (x) formada por los valores [ beta1...1(1 y(o) 
%   y(n-1) ... y(1) u(o) ... u(1)) beta1...2(1 y(o) y(n-1) ... y(1) u(o) 
%   ... u(1))]; 1 y(o+1) y(o) ... y(2) u(o) ... u(2); ... ; 1 y(n-1) y(n-2)
%   ... y(n - o) u(n-1) ... u(n-o). Se considera en este caso que beta = w 
%   (peso).
%
%   format es una matriz de dimensiones (n�mero de entradas + 1 ) x (orden 
%   m�ximo) que en cada fila indica cu�les son los par�metros a considerar.
%   La primera fila son a0 a1 ... an, y las siguientes b10 b11 ... b1n, b20
%   b21 ... b2n, etc�tera, indicando 1 si se quiere y 0 si no.
%
%   Vb es el vector (o vectores, en modo matricial) o cell de vectores de 
%   variables borrosas [argumento, m�dulo].
%
%   FSetArg es el vector de FuzzySetArgumento, de longitud la misma que
%   FSetMod (el FuzzySet del m�dulo).
%
%   c es el par�metro de la norma, para evitar matrices de determinante 0.
%% Inicio

format = boolean(format);
orden = size(format,2) - 1;



if ~iscell(Y)
    %% Si solo se ha hecho una simulaci�n
    [phi, Yr] = FuzzyPhiMatrixPolar(Y, U, format, Vb, FSetArg, FSetMod);
    
%     if isrow(Y)
%         Vb = Vb';
%     end
    
    num_pesos = 0;
    for i = 1:FSLength(FSetMod)
       num_pesos = num_pesos + FSetArg(i).FSLength; 
    end
    
    gamma_2 = c*norm(phi'*Yr) / norm(linearparam);
    param = (phi'*phi + gamma_2*eye(size(phi,2)))\(phi'*Yr + gamma_2*repmat(linearparam,num_pesos,1));
%     param = phi\Yr;
    return;
    
    
elseif ~iscell(U)
    error('U debe pasarse en el mismo formato que Y');
end

%% Errores
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

% nV = size(Vb{1},2);

%% Inicializaci�n

widthphi = sum(format, 'all');
heightphi = 0;
num_pesos = 0;
for i = 1:FSLength(FSetMod)
   num_pesos = num_pesos + FSetArg(i).FSLength; 
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
    
    [phi(k1:k2,:), Yr(k1:k2,:)] = FuzzyPhiMatrixPolar(Y{i}, U{i}, format, Vb{i}, FSetArg, FSetMod);
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
