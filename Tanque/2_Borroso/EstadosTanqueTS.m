%% 3 Estados Tanque TS (Modelo discreto borroso del tanque)

clearvars
clc
close all

format shortG

addpath('..\..\Funciones');

load datosIdentificacionTS % normal
% load('..\2_Borroso\datosIdentificacionTS.mat');

%% Inicio
N = FuzzySetQ.FSLength*FuzzySetT.FSLength; %número de reglas

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

    indexQ = 7*(i-1)%#ok<*NOPTS>
    
    [AQ, BQ, CQ, DQ, axQ, ayQ] = C_Observable_MISO([pQTS(indexQ+2) pQTS(indexQ+3) 0 0 0 0], ...
        [0 0 0 0 pQTS(indexQ+4) pQTS(indexQ+5); 0 0 0 pQTS(indexQ+6) pQTS(indexQ+7) 0], pQTS(indexQ+1), [0; 0]);
    %% Temperatura
    %En este caso T(k) = pT(1) + pT(2)T(k-1) + pT(3)T(k-2) + pT(4)T(k-3) + 
    %pT(5)U1(k-3) + pT(6)U1(k-4) + pT(7)U2(k-2) + pT(8)U2(k-3)
    
    indexT = 8*(i-1)
    
    [AT, BT, CT, DT, axT, ayT] = C_Observable_MISO([pTTS(indexT+2) pTTS(indexT+3) pTTS(indexT+4) 0], ...
        [0 0 pTTS(indexT+5) pTTS(indexT+6); 0 pTTS(indexT+7) pTTS(indexT+8) 0], pTTS(indexT+1), [0; 0]);
    
    %% Todo junto
    A{i} = blkdiag(AQ, AT) 
    B{i} = [BQ; BT]
    C{i} = blkdiag(CQ, CT)
%     D{i} = [DQ; DT]
    ax{i} = [axQ; axT]
    ay{i} = [ayQ; ayT]
end

%% Salvar datos
% save datosEstadosTS A B C ax ay FuzzySetQ FuzzySetT
% save datosEstadosTSIncremental A B C ax ay FuzzySetQ FuzzySetT
