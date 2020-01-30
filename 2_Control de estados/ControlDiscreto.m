function res = ControlDiscreto(Yr, Yk)
%CONTROLADORDISCRETOBAB Controlador discreto de un sistema
%   Se usa en ABCLQR

global A B C K H ax ay M Xek;

%% Referencia
resul = M*[ -ax ; Yr - ay];
Xr = resul(1:4);
Ur = resul(5);

%% Controlador
Uk = real(Ur - K * (Xek - Xr));

%% Observador de estado
%Y estimada
Ye = ay + C*Xek;

Xek = ax + A*Xek + B*Uk + H*(Yk - Ye);


% fprintf('Xek = [%f %f %f %f], Uk = %f\n]', Xek(1), Xek(2), Xek(3), Xek(4), Uk);
% if Yr ~= 0
%        fprintf('Yr = %f ', Yr);
% end


%% Error
error_obs = Yk - Ye;

res = [ Uk , error_obs ];
end