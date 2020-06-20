function output = ControlDiscretoIncremental(Yr, Yk, Sat)
%CONTROLDISCRETOREALIMENTADO Controlador discreto de un sistema
%   Sat = [U1min U1max; ...; Unmin Unmax]

global A B C K_ H Uk1 Yk1 DeltaXek

%% Estado X_ y referencia
X_k = [Yk; DeltaXek];
X_r = [Yr; zeros(size(DeltaXek))];

%% Controlador
Uk = real(Uk1 - K_ * (X_k - X_r));

% saturación
for i = 1:length(Uk)
    if Uk(i) < Sat(i,1)
        Uk(i) = Sat(i,1);
    end
end

for i = 1:length(Uk)
    if Uk(i) > Sat(i,2)
        Uk(i) = Sat(i,2);
    end
end
%% Observador de estado
% Y estimada
Ye = Yk1 + C*DeltaXek;

DeltaXek = A*DeltaXek + B*(Uk - Uk1) + H*(Yk - Ye);

%% Siguiente iteración

Uk1 = Uk;
Yk1 = Yk;

%% Error
error_obs = Yk - Ye;

output = [ Uk ; error_obs ];
end