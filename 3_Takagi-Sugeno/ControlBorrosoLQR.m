function Ukfinal = ControlBorrosoLQR(Yr, fp, varargin)
%CONTROLBORROSOLQR(Yr, {fpY, fp1, ..., fpN}, Yk, Vb1k, .... Vbnk) 
%	Controlador discreto de un sistema
% Se usa en control de estados borrosos

global A B C K H ax ay M Xek;

N = length(A);
orden = length(A{1});
Uk = cell(1,N);
mu = cell(1,length(varargin));

%% Pesos borrosos (regiones definidas en funciones de pertenencia)
for i = 1:length(varargin)
    mu(i) = {Fuzzification(varargin{i}, fp{i})};
end

pesos = kron_m(mu{:});


for i = 1:N
    %% Referencia
    resul = M{i}*[ -ax{i} ; Yr - ay{i}];
    Xr = resul(1:orden);
    Ur = resul(orden + 1);

    %% Controlador
    Uk{i} = real(Ur - K{i} * (Xek{i} - Xr));
    
end

%% Suma final
Ukfinal = 0;
for i = 1:N
    Ukfinal = Ukfinal + pesos(i) * Uk{i};
end

%% Observador de estado
for i = 1:N
    
    %Y estimada
    Ye = ay{i} + C{i}*Xek{i};

    % Xek = ax + A*Xek +B*Uk;
    %
    Xek{i} = ax{i} + A{i}*Xek{i} + B{i}*Ukfinal + H{i}*(varargin{1} - Ye);
end
%% Error
% error_obs = varargin{1} - Ye;
% 
% res = [ Ukfinal , error_obs ];
end