%% 4 LQR Tanque Polar (Control discreto borroso LQR y observador de estado)

clearvars
clc
close all

format shortG

addpath('..\..\Funciones');
addpath('..\');

global A B C K H ax ay M Xek

load datosEstadosPolar
% load datosEstadosTSPrevio

%% Inicio
N = 0;
for i = 1:length(FuzzySetArg)
    N = N + FSLength(FuzzySetArg(i)); %número de reglas
end 

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
Qi = 2;
Ti = 30;
Y0 = [Qi; Ti];

% a polares y pesos
Qnorm = Normalizacion(Qi, 'rango', 0, 8);
Tnorm = Normalizacion(Ti, 'rango', 10, 90);
[theta,rho] = cart2pol(Qnorm,Tnorm);
w = Fuzzification_polar([theta,rho], FuzzySetArg, FuzzySetMod);

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
ParametrosTanque;

Yr = [2; 30] %#ok<*NOPTS>

% Real
load_system('SimulacionTanqueControlado');
set_param('SimulacionTanqueControlado/Controlador','MATLABFcn','ControlBorrosoPolar([u(1); u(2)], [u(3); u(4)], [0 4; 0 4], FuzzySetArg, FuzzySetMod)');
sim('SimulacionTanqueControlado');                                                                             
% load_system('SimulacionTanqueControlador2018');
% sim('SimulacionTanqueControlador2018');


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