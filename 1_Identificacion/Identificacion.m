clearvars;
close all;
clc;

addpath('..\Funciones');
addpath('..\BallAndBeam');

format shortG;

%% COSAS ESPECÍFICAS DEL BALL AND BEAM
%Parámetros
global a b m l ;
m = 0.025;
g = 9.81;
r = 0.0167;
Ib = 3.516e-6;
Iw = 0.09;
bfr = 1.0; %bfr = b (friction)
K = 0.001;
l = 0.49;

%a y b (a1, a2, a3 y b1, ... b6)
[a, b] = ParametrosBAB(m, g, r, Ib, Iw, bfr, K, l);

%% Tiempos y todo eso
ttotal = 10;
tmuestra = 0.05;
var = 0.00001; %Varianza

tiempo = (0:tmuestra:ttotal)';
n = size(tiempo, 1);

%% Entrada - me compliqué la vida para que no se saturara en el rango empleado
u(1:n, 1) = tiempo;
u(1:floor(0.2*n), 2) = 0;
u(floor(0.2*n):floor(0.6*n), 2) = -0.015;
u(floor(0.6*n):floor(0.77*n), 2) = 0.17;
u(floor(0.77*n):floor(0.84*n), 2) = -0.15;
u(floor(0.84*n):floor(1*n), 2) = 0.16;

%% Simulación
sim('..\BallAndBeam\BallAndBeam')

orden  = 4;
%% Parámetros
[Y,U] = Recortador(defX(:,2),defU(:,2), 0, 0.1);

[param, phi] = MinCuadrados(orden, Y, U);

%para representar el error respecto lo previsto, se dan los primeros datos
%y se calculan los siguientes multiplicando phi por los parámetros
simulY1 = Y(1:orden);
simulY2 = phi * param;
simulY = [simulY1; simulY2];

tiempo2 = tiempo(1:size(Y));

save ResultadosParametros param
save ResultadosSimulacion U Y simulY tiempo2
save Parametros a b m l
error = (Y - simulY);



%%
%Dibuja todo
figure; plot(tiempo2, error); title('Error');
figure; plot(tiempo2, Y, 'b-',tiempo2,  defX(1:size(Y,1),2), 'r*'); title('Posición simulada');
figure; plot(tiempo, defX(1:n, 2)); title('Posición');
figure; plot(tiempo,defAlpha(:, 2) * 180 / pi);title('Alpha');
figure; plot(tiempo,defU(:,2)); title('Entrada');

