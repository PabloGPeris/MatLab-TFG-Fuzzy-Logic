%% 4 LQRTanque

clearvars
clc
close all

format shortG

addpath('..\..\Funciones');

global A B C K H ax ay M Xek

load datosEstados
%% Matrices LQR

%observador

H = A/C;

%parámetros LQR

% Q = eye(10);
% R = eye(2);

Q = diag([1 1 1 1 1 1 0.01 0.01 0.01 0.01]);
R = diag([1 1]);

%realimentación

K = dlqr(A, B, Q, R);


%% Parámetros iniciales y matriz M

Qi = 4;
Ti = 49.9;
Y0 = [Qi; Ti];

M1 = [(A - eye(size(A))) B ; C D];
M = inv(M1);

resul = M*[ -ax ; Y0 - ay]; 
Xek = resul(1:10);
Ui = resul(11:12);

%% Simulación y constantes del tanque
tsim = 100;
tmuestra = 0.5;
ParametrosTanque;


Yr = [5; 67];

% Real
load_system('SimulacionTanqueControlado');
sim('SimulacionTanqueControlado');
% load_system('SimulacionTanqueControlador2018');
% sim('SimulacionTanqueControlador2018');


%% Simulación - gráficas
tiempo = 0:tmuestra:tsim;
%figure; plot(tiempo, lqrError(:,2)); title('Error');
figure; plot(tiempo, Qm(:, 2), tiempo, Q1(:,2), tiempo, Q2(:,2)); title('Caudal');
figure; plot(tiempo, T(:, 2)); title('Temperatura');
% figure; plot(tiempo, lqrX(:, 2), tiempo, lqrYr(:,2)); title('Posición');