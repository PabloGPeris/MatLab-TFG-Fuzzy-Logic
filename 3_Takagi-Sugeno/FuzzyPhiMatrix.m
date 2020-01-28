function phi = FuzzyPhiMatrix(orden, fp, U, varargin)
%   FUZZYPHIMATRIX(orden, {fpY fp1 ... fpm}, U, Y, Vb1, ..., Vbm )
%   Matriz Phi (X) Borrosa del Takagi-Sugeno
%
%   Ecuación del tipo y(k) = a0 + a1y(k-1) + ... + aoy(k-o) + b1u(k-1) +
%   ... + bou(k-o), donde o es el orden del sistema. Y es el vector [y(1)
%   ... y(n)]' y U = [u(1) ... u(n)]'. fpY define la función de pertenencia
%   de la variable borrosa Y. Vb1, Vb2, ... Vbm son las otras variables
%   borrosas a considerar, en vectores [vbi(1) ... vbi(n)]', definidas en
%   funciones de pertenencia según fp1, fp2, ..., fpm.
%   Devuelve la matriz phi (x) formada por los valores [ beta1...1(1 y(o) 
%   y(n-1) ... y(1) u(o) ... u(1)) beta1...2(1 y(o) y(n-1) ... y(1) u(o) 
%   ... u(1))]; 1 y(o+1) y(o) ... y(2) u(o) ... u(2); ... ; 1 y(n-1) y(n-2)
%   ... y(n - o) u(n-1) ... u(n-o). Se considera en este caso que beta = w 
%   (peso)


%fp = funciones de pertenencia
if ~iscell(fp)
    error('Deben pasarse los valores que definen las funciones de pertenencia en formato cell');
end
if length(varargin) ~= length(fp)
    error('El número de funciones de pertenencia no coincide con el de variables borrosas');
elseif isempty(varargin)
    error('Debe introducirse mínimo la variable borrosa Y');
end

% Comprobación de tamaños correctos
for i=1:length(varargin)
    if size(varargin{i}) ~= size(U)
        error('Los vectores de U y las variables borrosas deben tener el mismo tamaño');
    end
end

if isrow(U)
    U = U';
    for i=1:length(varargin)
        varargin{i} = varargin{i}';
    end
elseif ~iscolumn(U)
    error('U y las variables borrosas deben ser vectores');
end

n = length(U);
m = n - orden;

%variable auxiliar para calcular el tamaño a priori de la matriz Phi
sizephi = 1; 
for i = 1:length(varargin)
    sizephi = sizephi * length(fp{i});
end
sizephi = sizephi*(2 * orden + 1);
phi = zeros(m, sizephi);
% sizephi debería ser 5*3*5*3*9, el producto de todas las zonas / regiones de
% pertenencia de cada variable p, pd, alpha, alphad * (2 * orden + 1) que son 
% los parámetros (1 a1 a2 ... b1 b2 ...) -CASO BALL AND BEAM-

mu = cell(1, length(varargin)); %Resultados de aplicar la función Fuzzyfication


for i = (orden+1):n
    
    for j = 1:length(varargin)
        mu(j) = {Fuzzification(varargin{j}(i), fp{j})};
    end
    
    w = kron_m(mu{:});
    % kron_m es una función que me he inventado para poder anidar varios
    % productos tensoriales de Kronecker (kron(...)) fácilmente
    % el peso w coincide con beta ya que la suma de los pesos es 1
    row = [1 varargin{1}(i-1:-1:i-orden)' U(i-1:-1:i-orden)']; % fila de 1 p(k - 1) p(k - 2) ... u(k - 1) u(k - 2) ...
    phi(i - orden,:)=kron(w,row);
    
end

end

