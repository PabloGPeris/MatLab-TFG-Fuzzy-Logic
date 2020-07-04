%% 5 LQR Incremental Tanque (Control discreto incremental LQR y observador de estado)

clearvars
clc
close all

format shortG

addpath('..\..\Funciones');
addpath('..\');

global A B C K_ H Uk1 Yk1 DeltaXek

load datosEstados
%% Matrices de modelo de estados incremental

[A_, B_, ~] = Modelo_Incremental(A,B,C);

%% Matrices LQR

% observador

H = A/C;

% parámetros LQR

% Q = diag([5 5 1 1 1 1 1 1 0.01 0.01 0.01 0.01]);
Q = diag([0.03 0.0002 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01]);
R = diag([1 1]);

% realimentación

K_ = dlqr(A_, B_, Q, R);


%% Parámetros iniciales y matriz M

% parámetros iniciales
Qi = 3;
Ti = 35;
Y0 = [Qi; Ti];

% matriz M (para el Ur)
M1 = [(A - eye(size(A))) B ; C D];
M = inv(M1);
resul = M*[ -ax ; Y0 - ay]; 
Ui = resul(11:12);

% estados y entradas iniciales
Yk1 = Y0;
Uk1 = Ui;
DeltaXek = zeros(length(A),1);

%% Simulación y constantes del tanque
tsim = 100;
% tmuestra = 0.5;
ParametrosTanque;


Yr = [5; 65] %#ok<*NOPTS>

% Real
load_system('SimulacionTanqueControlado');
set_param('SimulacionTanqueControlado/Controlador','MATLABFcn','ControlDiscretoIncremental([u(1); u(2)], [u(3); u(4)], [0 4; 0 4])');
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
