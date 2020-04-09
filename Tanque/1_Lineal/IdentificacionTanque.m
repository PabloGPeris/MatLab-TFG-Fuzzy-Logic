%% 2 Identificación Tanque (Mín cuadrados)

clearvars
close all
clc
format shortG

addpath('..\..\Funciones');

load datosGeneracion
%% Caudal Q
% [phiQ, yQ] = PhiMatrixMISO(Qm(:,2), [U1(:,2) U2(:,2)], [1 1 1 0 0 0 0; 0 0 0 0 0 1 1; 0 0 0 0 1 1 0]);
% 
% phiQ = [ones(length(Qm)-6,1) Qm(6:end-1 ,2) Qm(5:end-2,2) U1(2:end-5,2) U1(1:end-6,2) U2(3:end-4,2) U2(2:end-5,2)];
% yQ = Qm(7:end,2);
% 
% pQ = phiQ\yQ 

pQ = MinCuadradosMISO(Qm(:,2), [U1(:,2) U2(:,2)], [1 1 1 0 0 0 0; 0 0 0 0 0 1 1; 0 0 0 0 1 1 0])%#ok<*NOPTS>

%preguntar por esto
%% Temperatura T

% [phiT, yT] = PhiMatrixMISO(T(:,2), [U1(:,2) U2(:,2)], [1 1 1 1 0; 0 0 0 1 1; 0 0 1 1 0]);
% 
% phiT = [ones(length(T)-4,1) T(4:end-1,2) T(3:end-2,2) T(2:end-3,2) U1(2:end-3,2) U1(1:end-4,2) U2(3:end-2,2) U2(2:end-3,2)];
% yT = T(5:end,2);
% 
% pT = phiT\yT

pT = MinCuadradosMISO(T(:,2), [U1(:,2) U2(:,2)], [1 1 1 1 0; 0 0 0 1 1; 0 0 1 1 0])

%% Guardar datos

save datosIdentificacion pQ pT






