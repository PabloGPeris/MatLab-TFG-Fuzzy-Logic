%% Modelo de Estados discreto con matrices A,B,C y control LQR



clear;
close all;
clc;

addpath('..\..\Funciones');
addpath('..\');
format shortG;

load('..\1_Identificacion\ResultadosParametros')
load('..\1_Identificacion\Parametros');

global A B C K H ax ay M Xek;
global a b m l; %#ok<NUSED>

%Siendo X4 = U / (b4 + b3Z + b2Z^2 + b1Z^3 (+ b0Z^4)), X3 = ZX4, X2 = ZX3
%y X1=ZX2

%recordar que param = [a0 (=0) a1 a2 a3 a4 b1 b2 b3 b4]'

%% Poner a0 = 0

param(1)=0;

%% Espacio de estados

%Forma can�nica controlable

%[A, B, C, D, ax, ay] = C_Controlable(param(2:5), param(6:9), 0, 0)

% Forma can�nica observable

[A, B, C, ~, ax, ay] = C_Observable(param(2:5), param(6:9), 0, 0);

% Forma de Jordan

% [A, B, C, D, ax, ay] = C_Jordan(param(2:5), param(6:9), 0, 0);

%% Observador

H = A/C;

%% DLQR

Q = [ 10 0 0 0 ;
      0 10 0 0 ;
      0 0 10 0 ;
      0 0 0 10];
R = 1;

K = dlqr(A, B, Q, R);


%% Simulaci�n - par�metros iniciales y matriz M
M1 = [(A - eye(size(A))) B ; C 0];
M = inv(M1);

p0 = 0; %equivale p0 a Yr para el c�lculo de Xek0

resul = M*[ -ax ; p0 - ay]; 
Xek = resul(1:4);


%% Simulaci�n
ttotal = 15;
tmuestra = 0.05;
Yr = 0.1;
% Real
load_system('BallAndBeamControlado');
set_param('BallAndBeamControlado/Controlador','MATLABFcn','ControlDiscreto(u(1), u(2))');
sim('BallAndBeamControlado');

% Lineal
% Num = param(6:9)';
% Denom = [1 -param(2:5)'];
% set_param('ZControlado/Controlador','MATLABFcn','ControlDiscretoBAB(u(1), u(2))');
% sim('ZControlado')


%% Simulaci�n - gr�ficas
tiempo = 0:tmuestra:ttotal;
%figure; plot(tiempo, lqrError(:,2)); title('Error');
figure; plot(tiempo, lqrU(:, 2), tiempo, lqrYr(:,2)); title('Entrada');
figure; plot(tiempo, lqrAlpha(:, 2), tiempo, lqrYr(:,2)); title('Alpha');
figure; plot(tiempo, lqrX(:, 2), tiempo, lqrYr(:,2)); title('Posici�n');
