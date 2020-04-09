%% 1 Generación Datos Tanque TS (Borroso)

clearvars
clc
close all

format shortG

addpath('..\..\Funciones');
addpath('..\');

%% Parámetros de simulación
n_sim = 1;
tsim = 6000;
tmuestra = 0.5;
tvar1 = 23;
tvar2 = 24;

ParametrosTanque

seed = abs(randi(2^32-1,[n_sim 4]));

load_system('SimulacionTanque');

for i = 1:n_sim
	simulacion(i) = Simulink.SimulationInput('SimulacionTanque'); 
	simulacion(i) =  simulacion(i).setBlockParameter('SimulacionTanque/URN1', 'Seed', num2str(seed(i,1)));
    simulacion(i) =  simulacion(i).setBlockParameter('SimulacionTanque/URN2', 'Seed', num2str(seed(i,2)));
    simulacion(i) =  simulacion(i).setBlockParameter('SimulacionTanque/URN3', 'Seed', num2str(seed(i,3)));
    simulacion(i) =  simulacion(i).setBlockParameter('SimulacionTanque/URN4', 'Seed', num2str(seed(i,4)));
end




%% Simulación
out = parsim(simulacion, 'ShowProgress', 'on');

%% Tratamiento de datos
Qm = cell(1,n_sim);
% U1 = cell(1,n_sim);
% U2 = cell(1,n_sim);
U = cell(1,n_sim);
T = cell(1,n_sim);
Q1 = cell(1,n_sim);
Q2 = cell(1,n_sim);

for i = 1:n_sim
    Qm{i} = out(i).Qm(:,2);
%     U1{i} = out(i).U1(:,2);
%     U2{i} = out(i).U2(:,2);
    U{i} = [out(i).U1(:,2) out(i).U2(:,2)];
    T{i} = out(i).T(:,2);
    Q1{i} = out(i).Q1(:,2);
    Q2{i} = out(i).Q2(:,2);
end

save datosGeneracionTS U Qm T

%% Simulación - gráficas
tiempo = [0:tmuestra:tsim]';
% for i = 1:n_sim
% 
%     figure; plot(tiempo, Qm{i}, tiempo, Q1{i}, tiempo, Q2{i}); title('Caudal');
%     figure; plot(tiempo, T{i}); title('Temperatura');
% end

figure;
for i = 1:n_sim
    plot(Qm{i}, T{i}, '*')
    hold on;
end
title('Q - T');
