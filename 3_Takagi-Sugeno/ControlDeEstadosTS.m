%% Modelo de Estados Takagi-Sugeno con LQR

clear;
close all;
clc;

addpath('..\Funciones');
addpath('..\BallAndBeam');
format shortG;

load('ResultadosParametrosTS')
load('..\1_Identificacion\Parametros');

global A B C K H ax ay M Xek; %#ok<*NUSED>
global a b m l; 

%% Cosas previas

orden = 4;
N = 1;
for i = 1:length(fp)
    N = N * length(fp{i});%Debería dar 3*5*3*5 o 225
end

%% Variables globales (cell)
A = cell(1,N);    
B = cell(1,N);
C = cell(1,N);
H = cell(1,N); 
K = cell(1,N);%realimentación LQR
ax = cell(1,N);
ay = cell(1,N);
M = cell(1,N);
Xek = cell(1,N);

% Algunos parámetros
Q = 10*ones(orden);
R = 1;


for i=1:N
    %% Forma canónica observable
    index = (i-1)*(2 * orden + 1); %variable auxiliar
    [A{i}, B{i}, C{i}, ~, ax{i}, ay{i}] = C_Observable(param(index + 2:index + 1 + orden), param(index + 2 + orden:index + 1 + 2*orden), param(index + 1), 0);
    
    %% Observador
    H{i} = A{i}/C{i};
    
    %% LQR
    K{i} = dlqr(A{i},B{i}, Q, R);
    
    %% Matriz M y condiciones iniciales
    M{i} = inv([(A{i} - eye(size(A{i}))) B{i} ; C{i} 0]);

    resul = M{i}*[ -ax{i} ; 0 - ay{i}]; 
    Xek{i} = resul(1:4);
    
end

%% Simulación
ttotal = 15;
tmuestra = 0.05;
Yr = 0.1;

% Real
set_param('BallAndBeamControladoTS/Controlador','MATLABFcn','ControlBorrosoLQR(u(1), fp, u(2), u(3), u(4), u(5))');
sim('BallAndBeamControladoTS')

%% Simulación - gráficas
tiempo = 0:tmuestra:ttotal;
%figure; plot(tiempo, lqrError(:,2)); title('Error');
figure; plot(tiempo, lqrU(:, 2)); title('Entrada');
figure; plot(tiempo, lqrAlpha(:, 2)); title('Alpha');
figure; plot(tiempo, lqrX(:, 2)); title('Posición');
