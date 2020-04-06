%% 3 EstadosTanque

clearvars
clc
close all

format shortG

addpath('..\..\Funciones');

load datosIdentificacion
%% Caudal
%En este caso Q(k) = pQ(1) + pQ(2)Q(k-1) + pQ(3)Q(k-2) + pQ(4)U1(k-5) +
%pQ(5)U1(k-6) + pQ(6)U2(k-4) + pQ(7)U2(k-5)

[AQ, BQ, CQ, DQ, axQ, ayQ] = C_Observable_MISO([pQ(2) pQ(3) 0 0 0 0], ...
    [0 0 0 0 pQ(4) pQ(5); 0 0 0 pQ(6) pQ(7) 0], pQ(1), [0; 0]);
%% Temperatura
%En este caso T(k) = pT(1) + pT(2)T(k-1) + pT(3)T(k-2) + pT(4)T(k-3) + 
%pT(5)U1(k-3) + pT(6)U1(k-4) + pT(7)U2(k-2) + pT(8)U2(k-3)

[AT, BT, CT, DT, axT, ayT] = C_Observable_MISO([pT(2) pT(3) pT(4) 0], ...
    [0 0 pT(5) pT(6); 0 pT(7) pT(8) 0], pT(1), [0; 0]);

%% Todo junto
A = blkdiag(AQ, AT) %#ok<*NOPTS>
B = [BQ; BT]
C = blkdiag(CQ, CT)
D = [DQ; DT]
ax = [axQ; axT]
ay = [ayQ; ayT]

save datosEstados A B C D ax ay