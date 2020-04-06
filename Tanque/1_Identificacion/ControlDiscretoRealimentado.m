function output = ControlDiscretoRealimentado(Yr, Yk)
%CONTROLADORDISCRETOREALIMENTADO Controlador discreto de un sistema
%   

global A B C K H ax ay M Xek;



%% Referencia
resul = M*[ -ax ; Yr - ay];
Xr = resul(1:size(A));
Ur = resul(size(A) + 1:end);

%% Controlador
Uk = real(Ur - K * (Xek - Xr));

for i = 1:length(Uk)
    if Uk(i) < 0
        Uk(i) = 0;
    end
end
for i = 1:length(Uk)
    if Uk(i) > 4
        Uk(i) = 4;
    end
end

%% Observador de estado
%Y estimada
Ye = ay + C*Xek;



Xek = ax + A*Xek + B*Uk + H*(Yk - Ye);


%% Error
error_obs = Yk - Ye;

output = [Uk; error_obs];
end