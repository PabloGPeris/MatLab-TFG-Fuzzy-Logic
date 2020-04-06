function output = ControlDiscretoRealimentado(Yr, Yk, Sat)
%CONTROLADORDISCRETOREALIMENTADO Controlador discreto de un sistema
%   Sat = [lim_inf_1 lim_sup_1; ...; lim_inf_n lim_sup_n]

global A B C K H ax ay M Xek;



%% Referencia
resul = M*[ -ax ; Yr - ay];
Xr = resul(1:size(A));
Ur = real(resul(size(A) + 1:end));

%% Controlador
Uk = real(Ur - K * (Xek - Xr));

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
%Y estimada
Ye = real(ay + C*Xek);


Xek = ax + A*Xek + B*Uk + H*(Yk - Ye);


%% Error
error_obs = Yk - Ye;

output = [Uk; error_obs];
end