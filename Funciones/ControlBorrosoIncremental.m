function output = ControlBorrosoIncremental(Yr, Yk, Sat, Vbk, FSet)
%CONTROLDISCRETOREALIMENTADO Controlador discreto de un sistema
%   Sat = [U1min U1max; ...; Unmin Unmax]

global A B C K_ H Uk1 Yk1 DeltaXek

%% Fuzzification
mu = cell(1, length(Vbk));

for i = 1:length(Vbk)
    mu{i} = Fuzzification(FSet(i), Vbk(i));
end

w = kron_m(mu{:});

%% Matrices borrosas

N = length(w);

Af = 0;
Bf = 0;
Cf = 0;
Hf = 0;
Kf_ = 0;

for i = 1:N    
    Af = Af + w(i)*A{i};
    Bf = Bf + w(i)*B{i};
    Cf = Cf + w(i)*C{i};
    Hf = Hf + w(i)*H{i};
    Kf_ = Kf_ + w(i)*K_{i};
end

%% Estado X_ y referencia
X_k = [Yk; DeltaXek];
X_r = [Yr; zeros(size(DeltaXek))];

%% Controlador
Uk = real(Uk1 - Kf_ * (X_k - X_r));

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
% Y estimada
Ye = Yk1 + Cf*DeltaXek;

DeltaXek = Af*DeltaXek + Bf*(Uk - Uk1) + Hf*(Yk - Ye);

%% Siguiente iteración

Uk1 = Uk;
Yk1 = Yk;

%% Error
error_obs = Yk - Ye;

output = [Uk; error_obs];
end