%%Prueba TS sobre gamma

clearvars;
close all;
clc;

addpath('..\Funciones');
addpath('..\BallAndBeam');

format shortG;

load('..\1_Identificacion\ResultadosParametros.mat');%para param
load('ResultadosSimulacionTS');

%%

mup = [-.4 -.2 0 .2 .4];
mupd = [-.25 0 .25];
mualpha = [-.25 -.15 0 .15 .25];
mualphad = [-.15 0 .15];

fp = {mup, mupd, mualpha, mualphad};

orden  = 4;
gamma = 1e-3;

[param, ~] = Takagi_Sugeno(orden, gamma, param, fp, cellU, cellP, cellPd, cellAlpha, cellAlphad);

save ResultadosParametrosTS2 param fp

