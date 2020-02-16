%% Modelo de Estados Takagi-Sugeno con LQR

% clear;
% close all;
% clc;

addpath('..\Funciones');
addpath('..\BallAndBeam');
format shortG;

load('ResultadosParametrosTS')
% load('ResultadosParametrosTS_HF')

load('..\1_Identificacion\Parametros');


global A B C K H ax ay M Xek Q R;%#ok<*NUSED>
% global tmuestra; 
global a b m l; 

%% Cosas previas

orden = 4;
N = 1;
for i = 1:length(fp)
    N = N * length(fp{i});%Deber�a dar 3*5*3*5 o 225
end

%% Variables globales (cell)
A = cell(1,N);    
B = cell(1,N);
C = cell(1,N);
H = cell(1,N); 
K = cell(1,N);%realimentaci�n LQR
ax = cell(1,N);
ay = cell(1,N);
M = cell(1,N);
% Xek = cell(1,N);

% Algunos par�metros
% Q = eye(orden);
% R = 1;


for i=1:N
    %% Forma can�nica observable
    % con a0
%     index = (i-1)*(2 * orden + 1); %variable auxiliar
%     [A{i}, B{i}, C{i}, ~, ax{i}, ay{i}] = C_Observable(param(index + 2:index + 1 + orden), param(index + 2 + orden:index + 1 + 2*orden), param(index + 1), 0);
    
    % sin a0
    index = (i-1)*(2 * orden); %variable auxiliar    
    [A{i}, B{i}, C{i}, ~, ax{i}, ay{i}] = C_Observable(param(index + 1:index + orden), param(index + 1 + orden:index  + 2*orden), 0, 0);

    %% Observador
    H{i} = A{i}/C{i};
    
    %% LQR
    K{i} = dlqr(A{i},B{i}, Q, R);
    
    %% Matriz M y condiciones iniciales
    M1 = [(A{i} - eye(size(A{i}))) B{i} ; C{i} 0];
    M{i} = inv(M1);

%     resul = M{i}*[ -ax{i} ; 0 - ay{i}]; 
%     Xek{i} = resul(1:4);

    
end

Xek = zeros(orden, 1);


%% Simulaci�n
ttotal = 20;
tmuestra = 0.2;
Yr = 0.05;
Yr2 = 0;

% Real
load_system('BallAndBeamControladoTS');
set_param('BallAndBeamControladoTS/Controlador','MATLABFcn','ControlBorrosoLQR(u(1), fp, u(2), u(3), u(4), u(5))');
sim('BallAndBeamControladoTS')

%% Simulaci�n - gr�ficas
tiempo = 0:tmuestra:ttotal;
%figure; plot(tiempo, lqrError(:,2)); title('Error');
% figure; plot(tiempo, lqrU(:, 2)); title('Entrada');
% figure; plot(tiempo, lqrAlpha(:, 2)); title('Alpha');
figure; plot(tiempo, lqrX(:, 2), tiempo, lqrYr(:,2)); title('Posici�n');
