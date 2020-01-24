function K = kron_m(varargin)
%KRON_M(A1, A2, ... An) Kronecker tensor product
%
%   Retorna el producto tensioral de Kroneker de los argumentos
%
%   K = A1 (x) A2 (x) ... (x) An
l = length(varargin);

K = varargin{1};

for i=2:l
    K=kron(K, varargin{i});
end
end

