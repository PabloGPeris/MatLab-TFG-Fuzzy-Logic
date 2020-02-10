function [param, phi, yr] = Takagi_Sugeno_c(orden, c, linearparam, fp, U, varargin)
%TAKAGI_SUGENO(orden, gamma, linearparam, {fpY fp1 ... fpm}, {U1 ... Un}, {Y1 ... Yn}, {Vb11 ... Vb1n}, ..., {Vbm1 ... Vbmn})
%   M�nimos cuadrados de un sistema discreto Ball and Beam de una ecuaci�n
%   en diferencias
%
%   m es el n�mero de variables borrosas sin contar la salida
%
%   Ecuaci�n del tipo y(k) = a0 + a1y(k-1) + ... + aoy(k-o) + b1u(k-1) +
%   ... + bou(k-o), donde o es el orden del sistema. Y es el vector [y(1)
%   ... y(n)]' y U = [u(1) ... u(n)]'. fpY define la funci�n de pertenencia
%   de la variable borrosa Y. Vb1, Vb2, ... Vbm son las otras variables
%   borrosas a considerar, en vectores [vbi(1) ... vbi(n)]', definidas en
%   funciones de pertenencia seg�n fp1, fp2, ..., fpm.
%   Devuelve los par�metros a0, a1 ... ao,  b1, b2 ... bo (param).
%   Y devuelve la matriz phi (x) formada por los valores [ beta1...1(1 y(o) 
%   y(n-1) ... y(1) u(o) ... u(1)) beta1...2(1 y(o) y(n-1) ... y(1) u(o) 
%   ... u(1))]; 1 y(o+1) y(o) ... y(2) u(o) ... u(2); ... ; 1 y(n-1) y(n-2)
%   ... y(n - o) u(n-1) ... u(n-o). Se considera en este caso que beta = w 
%   (peso).
%   linearparam son los par�metros lineales anteriores.
%   c es la constante para el c�lculo de gamma

%% Comprobaci�n de errores
if ~iscell(fp)
    error('Deben pasarse los valores que definen las funciones de pertenencia en formato cell');
elseif ~iscell(U)
    error('U debe pasarse en formato cell');
end

if length(varargin) ~= length(fp)
    error('El n�mero de funciones de pertenencia no coincide con el de variables borrosas');
elseif isempty(varargin)
    error('Debe introducirse m�nimo la variable borrosa Y');
end

for i=1:length(varargin)
    if length(varargin{i}) ~= length(U)
        error('Debe haber el mismo n�mero de vectores de U y las variables borrosas');
    end
end


if isrow(linearparam)
    linearparam = linearparam';
elseif ~iscolumn(linearparam)
    error('linearparam debe ser vector');
end

if length(linearparam) ~= 2*orden + 1
    error('La longitud de linearparam debe ser 2*orden + 1');
end

%% Inicializaci�n de variables

% C�lculo de tama�os
widthphi1 = 1; %variable auxiliar
for i = 1:length(fp)
    widthphi1 = widthphi1 * length(fp{i});
end
widthphi = widthphi1*(2*orden + 1);

heightphi = 0;
for i = 1:length(U)
    if length(U{i}) > orden
        heightphi = heightphi + length(U{i}) - orden;
    end
end

% Inicializaci�n de variables
phi = zeros(heightphi, widthphi); % matriz de entradas y salidas (llamada X, creo, en el Takagi Sugeno)
yr = zeros(heightphi, 1); % salida p resultado (no es anidar todas las salidas, solo a partir del orden del sistema)
inputs = cell(1,length(varargin)); % las variables borrosas usadas y tal

%% Bucle de phi y anidador de Y
k1 = 1;

for i = 1:length(U)
    if length(U{i}) <= orden
        continue;
    end
    
    for j = 1:length(varargin)
        inputs(j) = varargin{j}(i);
    end
    
    k2 = k1 + length(U{i}) - orden - 1;
    
    phi(k1:k2,:) = FuzzyPhiMatrix(orden, fp, U{i}, inputs{:}); % anida diversas matrices phi borrosas
    yr(k1:k2,1) = varargin{1}{i}(orden + 1 : end); % anida las salidas Y = Vari{n*j + 1
    k1 = k2 + 1;
end

%% Parte final (gamma)

gamma_2 = c*norm(phi'*yr) / norm(linearparam);
    
%% C�lculo de los par�metros
param = (phi'*phi + gamma_2*eye(widthphi))\(phi'*yr + gamma_2*repmat(linearparam,widthphi1,1));
    
%% Error cometido
err = yr - phi * param;
fprintf('Error = %d\n', sqrt(mse(err)));
end
