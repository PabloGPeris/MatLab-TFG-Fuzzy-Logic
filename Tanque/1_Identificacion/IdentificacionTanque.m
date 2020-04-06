%% 2 Identificación Tanque (Mín cuadrados)

clearvars
close all
clc
format shortG


load datosGeneracion
%% Caudal Q
phiQ = [ones(length(Qm)-6,1) Qm(6:end-1 ,2) Qm(5:end-2,2) U1(2:end-5,2) U1(1:end-6,2) U2(3:end-4,2) U2(2:end-5,2)];
yQ = Qm(7:end,2);
pQ = phiQ\yQ %#ok<*NOPTS>

%preguntar por esto
%% Temperatura T
phiT = [ones(length(T)-4,1) T(4:end-1,2) T(3:end-2,2) T(2:end-3,2) U1(2:end-3,2) U1(1:end-4,2) U2(3:end-2,2) U2(2:end-3,2)];
yT = T(5:end,2);
pT = phiT\yT

save datosIdentificacion pQ pT






