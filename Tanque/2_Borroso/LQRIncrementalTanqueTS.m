%% 5 LQR Incremental Tanque TS (Control discreto borroso LQR y observador de estado)

clearvars
clc
close all

format shortG

addpath('..\..\Funciones');
addpath('..\');

global A B C K_ H Uk1 Yk1 DeltaXek

% load datosEstadosTSIncremental
load datosEstadosTSPrevio
% load datosEstadosTS

%% Inicio
N = FuzzySetQ.FSLength*FuzzySetT.FSLength; %número de reglas

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
% parámetros iniciales
Qi = 4;
Ti = 50;
Y0 = [Qi; Ti];

% pesos
w = kron(FuzzySetQ.Fuzzification(Qi), FuzzySetT.Fuzzification(Ti));

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

Yr = [0.6; 70] %#ok<*NOPTS>

% Real
load_system('SimulacionTanqueControlado');
set_param('SimulacionTanqueControlado/Controlador','MATLABFcn','ControlBorrosoIncremental([u(1); u(2)], [u(3); u(4)], [0 4; 0 4], [u(1); u(2)], [FuzzySetQ FuzzySetT])');
sim('SimulacionTanqueControlado');


%% Simulación - gráficas
tiempo = 0:tmuestra:tsim;
%figure; plot(tiempo, lqrError(:,2)); title('Error');
figure; 
subplot(2,1,1);
plot(tiempo, Qm(:, 2), '-', tiempo, Q1(:,2), '-', tiempo, Q2(:,2), '-', tiempo, Ref(:,2), '--'); title('Caudal');
ylim([0 8]);
subplot(2,1,2);
plot(tiempo, T(:, 2), '-', tiempo, Ref(:,3), '--'); title('Temperatura');
ylim([10 90]);
% figure; plot(tiempo, lqrX(:, 2), tiempo, lqrYr(:,2)); title('Posición');