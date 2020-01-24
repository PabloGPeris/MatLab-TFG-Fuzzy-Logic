clear all;
close all;
clc;

addpath('.\..\Funciones');
format shortG;

load('.\..\1_Identificacion\ResultadosParametros')
load('.\..\1_Identificacion\Parametros');

global A B C K H DeltaXek Yk1 Uk1;
global a b m l; %#ok<NUSED>

%Siendo X4 = U / (b4 + b3Z + b2Z^2 + b1Z^3 (+ b0Z^4)), X3 = ZX4, X2 = ZX3
%y X1=ZX2

%recordar que param = [a0 (=0) a1 a2 a3 a4 b1 b2 b3 b4]'

%% Forma canónica controlable

%[A, B, C, D, ax, ay] = C_Controlable(param(2:5), param(6:9), 0, 0)

%% Forma canónica observable

[A, B, C, D, ax, ay] = C_Observable(param(2:5), param(6:9), 0, 0);

%% Forma de Jordan

% [A, B, C, D, ax, ay] = C_Jordan(param(2:5), param(6:9), 0, 0);

%% Incremental

A_ = [1 C*A; zeros(legnth(A),1) A];
B_ = [C*B; B];
%C innecesaria
%C_ = [1 zeros(1,size(A,1))];

%% Observador

H = A/C;

%% DLQR

Q = 100*[ 1 0 0 0 0;
         0 1 0 0 0;
         0 0 1 0 0;
         0 0 0 1 0;
         0 0 0 0 1];
R = 1;

K = dlqr(A_, B_, Q, R);


%% Simulación - parámetros iniciales

set_param('BallAndBeamControlado/Controlador','MATLABFcn','ControlIncrementalBAB(u(1), u(2))');
Yr = 0.05;

DeltaXek = [0; 0; 0; 0];

Yk1 = 0;
Uk1 = 0;

ttotal = 10;
tmuestra = 0.05;


%% Simulación

sim('BallAndBeamControlado')


%% Simulación - gráficas
tiempo = 0:tmuestra:ttotal;

figure; plot(tiempo, lqrError(:,2)); title('Error');
figure; plot(tiempo, lqrU(:, 2), tiempo, lqrYr(:,2)); title('Entrada');
% figure; plot(tiempo, lqrAlpha(:, 2), tiempo, lqrYr(:,2)); title('Alpha');
figure; plot(tiempo, lqrX(:, 2), tiempo, lqrYr(:,2)); title('Posición');
