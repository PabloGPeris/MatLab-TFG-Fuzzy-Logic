%% 1 SimulaciónTanque

clearvars
clc
close all

format shortG

addpath('..\..\Funciones');

%% Parámetros de simulación
tsim = 5000;
tmuestra = 0.5;
tvar1 = 23;
tvar2 = 24;

ParametrosTanque

%% Simulación
load_system('SimulacionTanque2');
sim('SimulacionTanque2');

save datosSimulacion U1 U2 Qm T