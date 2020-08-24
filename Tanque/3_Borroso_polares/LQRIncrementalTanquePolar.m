%% 5 LQR Incremental Tanque TS (Control discreto borroso LQR y observador de estado)

clearvars
clc
close all

format shortG

addpath('..\..\Funciones');
addpath('..\');

global A B C K_ H Uk1 Yk1 DeltaXek

load datosEstadosPolarIncremental

%% Inicio y fin

ParametrosTanque;

var_ruido = 0; % varianza del ruido

Qi = 3.2;
Ti = 43;
Qf = 3.2;
Tf = 43;

Tef = 10000; %Temperatura ambiente (exterior) final

%% Inicio
N = 0;
for i = 1:length(FuzzySetArg)
    N = N + FSLength(FuzzySetArg(i)); %número de reglas
end 

H = cell(1,N); 
K_ = cell(1,N);%realimentación LQR
M = cell(1,N);

%% Matrices LQR

% parámetros LQR
Q = diag([0.03 0.0002 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01]);
R = diag([1 1]);


for i = 1:N
    %% Matrices de modelo de estados incremental

    [A_, B_, ~] = Modelo_Incremental(A{i},B{i},C{i});
    
    %% Matrices LQR

    % observador
    H{i} = A{i}/C{i};
    
    %realimentación

    K_{i} = dlqr(A_, B_, Q, R);


    %% Parámetros iniciales y matriz M


    M1 = [(A{i} - eye(size(A{i}))) B{i} ; C{i} [0 0; 0 0]];
    M{i} = inv(M1);


end

%% Parámetros iniciales
Y0 = [Qi; Ti] %#ok<*NOPTS>

% a polares y pesos
Qnorm = Normalizacion(Qi, 'rango', 0, 8);
Tnorm = Normalizacion(Ti, 'rango', 10, 90);
[theta,rho] = cart2pol(Qnorm,Tnorm);
w = Fuzzification_polar([theta,rho], FuzzySetArg, FuzzySetMod);

% matriz M (para el Ur)
Mf = 0;
axf = 0;
ayf = 0;

for i = 1:N % Referencia
    Mf = Mf + w(i)*M{i};
    axf = axf + w(i)*ax{i};
    ayf = ayf + w(i)*ay{i};
end

resul = Mf*[ -axf ; Y0 - ayf];
Ui = resul(length(A{1})+1:end);

% estados y entradas iniciales
Yk1 = Y0;
Uk1 = Ui;
DeltaXek = zeros(length(A{1}),1);


%% Simulación y constantes del tanque
tsim = 150;
ParametrosTanque;


Yr = [Qf; Tf] 

% Real
load_system('SimulacionTanqueControlado');
set_param('SimulacionTanqueControlado/Controlador','MATLABFcn','ControlBorrosoIncrementalPolar([u(1); u(2)], [u(3); u(4)], [0 4; 0 4], FuzzySetArg, FuzzySetMod)');
sim('SimulacionTanqueControlado');


%% Simulación - gráficas
tiempo = 0:tmuestra:tsim;

TsQ = Tiempo_establecimiento(tiempo, Qm(:,2)) - 10
TsT = Tiempo_establecimiento(tiempo, T(:,2)) - 10

%figure; plot(tiempo, lqrError(:,2)); title('Error');
figure; 
subplot(2,1,1);
plot(tiempo, Qm(:, 2), '-', tiempo, Q1(:,2), '-', tiempo, Q2(:,2), '-', tiempo, Ref(:,2), '--'); 
title(strcat("Caudal, ts = ", num2str(TsQ), " varianza = ", num2str(var(Q(100:end,2)))));
ylim([0 8]);
legend('Q observado', 'Q caliente', 'Q frío', 'Ref');
subplot(2,1,2);
plot(tiempo, T(:, 2), '-', tiempo, Ref(:,3), '--'); 
title(strcat("Temperatura, ts = ", num2str(TsT), " varianza = ", num2str(var(T(100:end,2)))));
ylim([10 90]);
legend('T observada', 'Ref');
