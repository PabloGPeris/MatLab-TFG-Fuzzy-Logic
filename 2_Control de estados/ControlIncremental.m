function res = ControlIncremental(Yr, Yk)
%CONTROLADORDISCRETOBAB Controlador discreto de un Ball And Beam
%   Se usa en ABCLQR

global A B C K H DeltaXek Yk1 Uk1;

%% Estado X_ y referencia
X_k = [Yk; DeltaXek];
X_r = [Yr; zeros(4,1)];

%% Controlador
Uk = real(Uk1 - K * (X_k - X_r));

%% Observador de estado
%Y estimada
Ye = Yk1 + C*DeltaXek;

DeltaXek = A*DeltaXek + B*(Uk - Uk1) + H * (Yk - Ye);
%% Siguiente iteración

Uk1 = Uk;
Yk1 = Yk;
%% Error
error_obs = Yk - Yr;

res = [ Uk , error_obs ];
end

