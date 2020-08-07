function output = ControlBorrosoPolar(Yr, Yk, Sat, FSetArg, FSetMod)
%CONTROLDISCRETOREALIMENTADO Controlador discreto de un sistema
%   Sat = [U1min U1max; ...; Unmin Unmax]

global A B C K H ax ay M Xek;

%% A polares

Qnorm = Normalizacion(Yk(1), 'rango', 0, 8);
Tnorm = Normalizacion(Yk(2), 'rango', 10, 90);
[theta,rho] = cart2pol(Qnorm,Tnorm);


%% Fuzzification
w = Fuzzification_polar([theta,rho], FSetArg, FSetMod);

%% Matrices borrosas

N = length(w);

Af = 0;
Bf = 0;
Cf = 0;
Mf = 0;
Hf = 0;
Kf = 0;
axf = 0;
ayf=0;

for i = 1:N    
    Af = Af + w(i)*A{i};
    Bf = Bf + w(i)*B{i};
    Cf = Cf + w(i)*C{i};
    Mf = Mf + w(i)*M{i};
    Hf = Hf + w(i)*H{i};
    Kf = Kf + w(i)*K{i};
    axf = axf + w(i)*ax{i};
    ayf = ayf + w(i)*ay{i};
end

%% Referencia

resul = Mf*[ -axf ; Yr - ayf];
Xr = resul(1:length(Af));
Ur = real(resul(length(Af)+1:end));

%% Controlador
Uk = real(Ur - Kf * (Xek - Xr));

% Saturación
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
Ye = real(ayf + Cf*Xek);

Xek = axf + Af*Xek + Bf*Uk + Hf*(Yk - Ye);

%% Error
error_obs = Yk - Ye;

output = [Uk; error_obs];
end