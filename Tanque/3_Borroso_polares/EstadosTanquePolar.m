%% 3 Estados Tanque Polar (Modelo discreto borroso del tanque)

clearvars
clc
close all

format shortG

addpath('..\..\Funciones');

load datosIdentificacionPolar % no inc de verdad
% load datosIdentificacionPolar2
% load datosIdentificacionPolar3 % inc
% load('..\2_Borroso\datosIdentificacionTS.mat');

%% Inicio
N = 0;
for i = 1:length(FuzzySetArg)
    N = N + FSLength(FuzzySetArg(i)); %número de reglas
end

A = cell(1,N);    
B = cell(1,N);
C = cell(1,N);
ax = cell(1,N);
ay = cell(1,N);
% D = cell(1,N);


%% Matrices

for i = 1:N
    %% Caudal
    %En este caso Q(k) = pQ(1) + pQ(2)Q(k-1) + pQ(3)Q(k-2) + pQ(4)U1(k-5) +
    %pQ(5)U1(k-6) + pQ(6)U2(k-4) + pQ(7)U2(k-5)

    indexQ = 7*(i-1);
    
    [AQ, BQ, CQ, DQ, axQ, ayQ] = C_Observable_MISO([pQPolar(indexQ+2) pQPolar(indexQ+3) 0 0 0 0], ...
        [0 0 0 0 pQPolar(indexQ+4) pQPolar(indexQ+5); 0 0 0 pQPolar(indexQ+6) pQPolar(indexQ+7) 0], pQPolar(indexQ+1), [0; 0]);
    %% Temperatura
    %En este caso T(k) = pT(1) + pT(2)T(k-1) + pT(3)T(k-2) + pT(4)T(k-3) + 
    %pT(5)U1(k-3) + pT(6)U1(k-4) + pT(7)U2(k-2) + pT(8)U2(k-3)
    
    indexT = 8*(i-1);
    
    [AT, BT, CT, DT, axT, ayT] = C_Observable_MISO([pTPolar(indexT+2) pTPolar(indexT+3) pTPolar(indexT+4) 0], ...
        [0 0 pTPolar(indexT+5) pTPolar(indexT+6); 0 pTPolar(indexT+7) pTPolar(indexT+8) 0], pTPolar(indexT+1), [0; 0]);
    
    %% Todo junto
    A{i} = blkdiag(AQ, AT);
    B{i} = [BQ; BT];
    C{i} = blkdiag(CQ, CT);
%     D{i} = [DQ; DT]
    ax{i} = [axQ; axT];
    ay{i} = [ayQ; ayT];
end

%%
% save datosEstadosPolar A B C ax ay FuzzySetMod FuzzySetArg
% save datosEstadosPolarIncremental A B C ax ay FuzzySetMod FuzzySetArg