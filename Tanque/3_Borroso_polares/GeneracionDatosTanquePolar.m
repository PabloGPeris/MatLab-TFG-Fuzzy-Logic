%% 1 Generación Datos Tanque Polar (Borroso)

clearvars
clc
close all

format shortG

addpath('..\..\Funciones');
addpath('..\');

%% Parámetros de simulación

n_sim = 3;
tsim = 50000;
tmuestra = 0.5;
tvar1 = 23;
tvar2 = 24;

seed = abs(randi(2^32-1,[n_sim 4]));

save ..\ParametrosSimulacion tsim tvar1 tvar2
%% Carga del sistema
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
Vb = cell(1,n_sim);

for i = 1:n_sim
    Qm{i} = out(i).Qm(:,2);
%     U1{i} = out(i).U1(:,2);
%     U2{i} = out(i).U2(:,2);
    U{i} = [out(i).U1(:,2) out(i).U2(:,2)];
    T{i} = out(i).T(:,2);
    Q1{i} = out(i).Q1(:,2);
    Q2{i} = out(i).Q2(:,2);
end

%% Normalización
mediaQ = mean(Qm{1});
stdQ = std(Qm{1});
mediaT = mean(T{1});
stdT = std(T{1});

for i = 1:n_sim

    
    Qnorm = Normalizacion(Qm{i}, 'rango', 0, 8);
    Tnorm = Normalizacion(T{i}, 'normal', 10, 90);
    [theta,rho] = cart2pol(Qnorm,Tnorm);
    
    Vb{i} = [theta rho];
end

save datosGeneracionPolar U Qm T Vb mediaQ stdQ mediaT stdT
% save datosGeneracionPolar2 U Qm T Vb mediaQ stdQ mediaT stdT
%% Simulación - gráficas
tiempo = (0:tmuestra:tsim)';
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

%%
figure;
for i = 1:n_sim
    plot(Vb{i}(:,2), Vb{i}(:,1), '*')
    hold on;
end
title('theta - rho');

%%

figure;
for i = 1:n_sim
    plot(Qnorm, Tnorm, '*')
    hold on;
end
title('Q - T');