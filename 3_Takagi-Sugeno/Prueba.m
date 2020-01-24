clearvars;
close all;
clc;

addpath('..\.\Funciones');

format shortG;


%% Tiempos y todo eso
ttotal = 50;
tmuestra = 0.05;
var = 0.00001; %Varianza

tiempo = (0:tmuestra:ttotal)';
n = size(tiempo, 1);

%% Parámetros
numero = 2;

num = [0 0 1 0.2];
denom = [1 -0.2 0.5 -0.1];
num2 = [0 0 0 1];
denom2 = [1 -0.3 0.4 0.5];

orden = 3;

%% Simulación 
fp = cell(1,2);
fp(1)={[-1 0 1]};
fp(2)={[-0.5 0 0.5]};


CU = cell(1,numero);
CY = cell(1,numero);
COtra = cell(1,numero);

u = zeros(n,2);
u(1:n, 1) = tiempo;
u(1:floor(0.2*n), 2) = 0;

for iseed = 1:numero
    % ya mejoraré la entrada para que salgan más cambios y tal
    u(1:40, 2) = 0;
    u(40:120, 2) = rand - .5;
    u(120:n, 2) = rand - .5;
    sim('SistemaLineal');
    
    CY{iseed} = defY(:,2);
    COtra{iseed} = defY(:,3);
    CU{iseed} = defU(:,2);
    
end

gamma = 1e-10;

[param, phi] = Takagi_Sugeno(orden, gamma, [0 0.2 -0.5 0.1 0 1 0.2]',fp, CU, CY, COtra);
% [param, phi, yr] = Takagi_Sugeno(orden, gamma, [0 0.2 -0.5 0.1 0 1 0.2]', {0}, CU, CY);
% [param, phi] = Takagi_Sugeno(orden, gamma, [0 0.2 -0.5 0.1 0 1 0.2]', fp(1), CU, CY);
[param2, phi2, yr2] = MinCuadradosMultiple(orden, CY{1}, CU{1}, CY{2}, CU{2});
%%

%U = [0 0 0 0 1 1 1 1 1 1]';
%Y = [-3 -2 -0.5 -0.2 0.5 0.9 2 2 2 2]';
%Otra = [-1 -.8 -.6 -.4 -.2 0 .2 .4 .6 .8]';
%phi = FuzzyPhiMatrix(orden, fp, U, Y, Otra);
% for i = 1:10
%     resul1(:,i) = Fuzzification(Y(i), fp{1});
%     resul2(:,i) = Fuzzification(Otra(i), fp{2});
% end
param
disp('FIN');
param - kron(ones(length(param)/7,1), param2)
