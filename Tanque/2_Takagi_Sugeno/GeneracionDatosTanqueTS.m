%% 1 GeneraciónDatosTanqueTS

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

%% Simulación
load_system('SimulacionTanque');
sim('SimulacionTanque');

save datosGeneracionTS U1 U2 Qm T

%% Simulación - gráficas
tiempo = 0:tmuestra:tsim;
figure; plot(tiempo, Qm(:, 2), tiempo, Q1(:,2), tiempo, Q2(:,2)); title('Caudal');
figure; plot(tiempo, T(:, 2)); title('Temperatura');