%% 4 LQR Tanque (Control discreto LQR y observador de estado)

clearvars
clc
close all

format shortG

addpath('..\..\Funciones');
addpath('..\');

global A B C K H ax ay M Xek

load datosEstados
%% Matrices LQR

% observador

H = A/C;

% parámetros LQR

% Q = eye(10);
% R = eye(2);

Q = diag([1 1 1 1 1 1 0.01 0.01 0.01 0.01]);
R = diag([1 1]);

% realimentación

K = dlqr(A, B, Q, R);


%% Parámetros iniciales y matriz M

% parámetros iniciales
Qi = 4;
Ti = 50;
Y0 = [Qi; Ti];

% matriz M
M1 = [(A - eye(size(A))) B ; C D];
M = inv(M1);

% estados y entradas iniciales
resul = M*[ -ax ; Y0 - ay]; 
Xek = resul(1:10);
Ui = resul(11:12);

%% Simulación y constantes del tanque
tsim = 100;
% tmuestra = 0.5;
ParametrosTanque;


Yr = [1.5; 70] %#ok<*NOPTS>

% Real
load_system('SimulacionTanqueControlado');
set_param('SimulacionTanqueControlado/Controlador','MATLABFcn','ControlDiscretoRealimentado([u(1); u(2)], [u(3); u(4)], [0 4; 0 4])');
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
