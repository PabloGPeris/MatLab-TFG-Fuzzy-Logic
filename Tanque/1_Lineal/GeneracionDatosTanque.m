%% 1 Generación Datos Tanque (Solo una simulación)

clearvars
clc
close all

format shortG

addpath('..\..\Funciones');
addpath('..\');

%% Parámetros de simulación
tsim = 5000;
tmuestra = 0.5;
tvar1 = 23;
tvar2 = 24;

ParametrosTanque

seed = randi(1,4);
%% Simulación
load_system('SimulacionTanque');
sim('SimulacionTanque');

save datosGeneracion U1 U2 Qm T

%% Simulación - gráficas
tiempo = 0:tmuestra:tsim;
figure; plot(tiempo, Qm(:, 2), tiempo, U1(:,2), tiempo, U2(:,2)); title('Caudal');
figure; plot(tiempo, T(:, 2)); title('Temperatura');

