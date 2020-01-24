clearvars;
close all;
clc;

addpath('..\Funciones');

format shortG;

load('..\1_Identificacion\Parametros.mat');%para a, b, m y l
load('..\1_Identificacion\ResultadosParametros.mat');%para param


global a b m l; %#ok<NUSED>


%% Tiempos y todo eso
ttotal = 10;
tmuestra = 0.05;
var = 0.001; %Varianza

tiempo = (0:tmuestra:ttotal)';
n = length(tiempo);


%% Simulación 
n_sim = 100; %número de simulaciones

u(1:n, 1) = tiempo;
u(1:floor(0.2*n), 2) = 0;


cellU = cell(1, n_sim);
cellP = cell(1, n_sim);
cellPd = cell(1, n_sim);
cellAlpha = cell(1, n_sim);
cellAlphad = cell(1, n_sim);

for i = 1:n_sim
    
    iseed = randi(2^53-1); %genera número aleatorio entre 1 y el máximo (2^53 - 1)
    p0 = -0.25 + 0.5 * rand;
    alpha0 = -10*pi/180 + 20*pi/180 * rand;
    
    
    u(1:40, 2) = rand - .5;
    u(40:120, 2) = rand - .5;
    u(120:n, 2) = rand - .5;
    sim('BallAndBeamTS');
    P_rec0 = Recortador(P(:,2),Entrada(:,2), 0, 0.39); % "recorta" la salida antes de la saturación
    Alpha_rec0 = Recortador(Alpha(:,2),Entrada(:,2), 0, 15*pi/180 - 0.01); % "recorta" la salida antes de la saturación
    k = min(length(P_rec0), length(Alpha_rec0));
    % Forma "artificial" de recortar el resto de variables
    U_rec = Entrada(1:k, 2);
    P_rec = P(1:k, 2);
    Pd_rec = Pd(1:k, 2);
    Alpha_rec = Alpha(1:k, 2);
    Alphad_rec = Alphad(1:k, 2);

    cellU{i} = U_rec;
    cellP{i} = P_rec;
    cellPd{i} = Pd_rec;
    cellAlpha{i} = Alpha_rec;
    cellAlphad{i} = Alphad_rec;
    
end

mup = [-.4 -.2 0 .2 .4];
mupd = [-.25 0 .25];
mualpha = [-.25 -.15 0 .15 .25];
mualphad = [-.15 0 .15];

orden  = 4;
gamma = 1e-8;

%% Parámetros

[param, phi] = Takagi_Sugeno(orden, gamma, param, {mup, mupd, mualpha, mualphad}, cellU, cellP, cellPd, cellAlpha, cellAlphad);

disp('FIN');

figure;

for i = 1:n_sim
    hold on;
    plot(cellP{i}, cellPd{i}, 'k.');
end
xlabel('Posición');
ylabel('Velocidad');

figure;
for i = 1:n_sim
    hold on;
    plot(cellAlpha{i}, cellAlphad{i}, 'k.');
end
xlabel('Ángulo');
ylabel('Velocidad angular');

figure;
for i = 1:n_sim
    hold on;
    plot(cellP{i}, cellAlpha{i}, 'k.');
end
xlabel('Posición');
ylabel('Ángulo');

save ResultadosSimulacionTS cellU cellP cellPd cellAlpha cellAlphad
save ResultadosParametrosTS param




