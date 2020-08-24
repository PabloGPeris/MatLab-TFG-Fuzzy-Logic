%% 4 LQR Tanque TS (Control discreto borroso LQR y observador de estado)

clearvars
clc
close all

format shortG

addpath('..\..\Funciones');
addpath('..\');

global A B C K H ax ay M Xek

load datosEstadosTS
% load datosEstadosTSPrevio

%% Inicio y fin

ParametrosTanque;

var_ruido = 0; % varianza del ruido

Qi = 3.2;
Ti = 43;
Qf = 3.2;
Tf = 43;

Tef = 10000; %Temperatura ambiente (exterior) final

%% Inicio
N = FuzzySetQ.FSLength*FuzzySetT.FSLength; %número de reglas

H = cell(1,N); 
K = cell(1,N);%realimentación LQR
M = cell(1,N);

%% Matrices LQR
%parámetros LQR

Q = diag([1 1 1 1 1 1 0.01 0.01 0.01 0.01]);
R = diag([1 1]);
    
for i = 1:N
    
    % observador
    H{i} = A{i}/C{i};
    % realimentación

    K{i} = dlqr(A{i}, B{i}, Q, R);


    %% Parámetros iniciales y matriz M


    M1 = [(A{i} - eye(size(A{i}))) B{i} ; C{i} [0 0; 0 0]];
    M{i} = inv(M1);


end

%% Parámetros iniciales

Y0 = [Qi; Ti];

w = kron(FuzzySetQ.Fuzzification(Qi), FuzzySetT.Fuzzification(Ti));

Mf = 0;
axf = 0;
ayf = 0;

for i = 1:N % Referencia
    Mf = Mf + w(i)*M{i};
    axf = axf + w(i)*ax{i};
    ayf = ayf + w(i)*ay{i};
end

resul = Mf*[ -axf ; Y0 - ayf];
Xek = resul(1:length(A{1}));
Ui = resul(length(A{1})+1:end);

%% Simulación y constantes del tanque
tsim = 150;


Yr = [Qf; Tf] %#ok<*NOPTS>

% Real
load_system('SimulacionTanqueControlado');
set_param('SimulacionTanqueControlado/Controlador','MATLABFcn','ControlBorrosoRealimentado([u(1); u(2)], [u(3); u(4)], [0 4; 0 4], [u(1); u(2)], [FuzzySetQ FuzzySetT])');
sim('SimulacionTanqueControlado');
% load_system('SimulacionTanqueControlador2018');
% sim('SimulacionTanqueControlador2018');


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

