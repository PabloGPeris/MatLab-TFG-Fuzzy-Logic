function Uk = ControlBorrosoLQR(Yr, fp, varargin)
%CONTROLBORROSOLQR(Yr, {fpY, fp1, ..., fpN}, Yk, Vb1k, .... Vbnk) 
%	Controlador discreto de un sistema
% Se usa en control de estados borrosos

global A B C K H ax ay M Xek Q R;

N = length(A);
orden = length(A{1});
mu = cell(1,length(varargin));


%% Pesos borrosos (regiones definidas en funciones de pertenencia)
for i = 1:length(varargin)
    mu(i) = {Fuzzification(varargin{i}, fp{i})};
end

pesos = kron_m(mu{:});

%% No mi manera
Af = 0;
Bf = 0;
Cf = 0;
Mf = 0;
Hf = 0;
Kf = 0;
axf = 0;
ayf=0;

for i = 1:N
    %% Referencia
    Af = Af + pesos(i)*A{i};
    Bf = Bf + pesos(i)*B{i};
    Cf = Cf + pesos(i)*C{i};
    Mf = Mf + pesos(i)*M{i};
    Hf = Hf + pesos(i)*H{i};
    Kf = Kf + pesos(i)*K{i};
    axf = axf + pesos(i)*ax{i};
    ayf = ayf + pesos(i)*ay{i};
end

resul = Mf*[ -axf ; Yr - ayf];
Xr = resul(1:orden);
Ur = resul(orden + 1);

%% Controlador
% Kf = dlqr(Af, Bf, Q, R);
Uk = real(Ur - Kf * (Xek - Xr));

%% Observador de estado
    
%Y estimada
Ye = ayf + Cf*Xek;

Xek = axf + Af*Xek + Bf*Uk + Hf*(varargin{1} - Ye);%varargin{1} = y



%% A mi manera
% Uk = 0;
% for i = 1:N
%     
%     resul = M{i}*[ -ax{i} ; Yr - ay{i}];
%     Xr = resul(1:orden);
%     Ur = resul(orden + 1);
%     
%     %% Controlador
%     Uk = Uk + pesos(i)*real(Ur - K{i} * (Xek{i} - Xr));
%     
% end
% 
% for i = 1:N
%     
%     %% Observador de estado
%     
%     %Y estimada
%     Ye = ay{i} + C{i}*Xek{i};
% 
%     Xek{i} = ax{i} + A{i}*Xek{i} + B{i}*Uk + H{i}*(varargin{1} - Ye);%varargin{1} = y
%     
% end

%% Para depurar errores
%fprintf('Xek = [%f %f %f %f], Uk = %f\n]', Xek(1), Xek(2), Xek(3), Xek(4), Uk);
% if Yr ~= 0
%        fprintf('Yr = %f ', Yr);
% end

end