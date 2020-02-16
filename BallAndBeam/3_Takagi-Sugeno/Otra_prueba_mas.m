clearvars;
close all;
clc;

addpath('..\Funciones');

format shortG;

num1 = [0 1 .2];
denom1 = [1 -.7 .1];
num2 = [0 2 -.6];
denom2 = [1 -.5 .04];
num3 = [0 0 1];
denom3 = [1 -1.7 .72];

%% Tiempos y todo eso
ttotal = 5;
tmuestra = 0.05;

tiempo = (0:tmuestra:ttotal)';
n = length(tiempo);


%% Simulación 
n_sim = 1; %número de simulaciones

u(1:n, 1) = tiempo;
u(1:floor(0.2*n), 2) = 0;


cellU = cell(1, n_sim);
cellY = cell(1, n_sim);
cellVB = cell(1, n_sim);
% cellDoble = cell(1, 2*n_sim);
load_system('SistemaLinealFuzzy');
%Vendría bien aprender a usar el parsim
for i = 1:n_sim
    
    iseed = randi(5000); %genera número aleatorio entre 1 y el máximo (2^53 - 1
    sim('SistemaLinealFuzzy');

    cellU{i} = U(:,2);
    cellY{i} = Y(:,2);
    cellVB{i} = VB(:,2);
%     cellDoble{2*i - 1} = Y(:,2);
%     cellDoble{2*i} = U(:,2);
end

%% Parámetros

mu = [[-.1 .1]];

fp = {[0] mu};

orden  = 2;
gamma = 1e-10;
% [param, phi, ~] = MinCuadradosMultiple(orden, cellU, cellY);
[param, phi, ~] = Takagi_Sugeno_sin_a0(orden, gamma, zeros(2*orden, 1), fp, cellU, cellY, cellVB);
param
