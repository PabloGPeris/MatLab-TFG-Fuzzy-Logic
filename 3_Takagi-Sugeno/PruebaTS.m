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

% mup = [-.4 -.2 0 .2 .4];
% mupd = [-.25 0 .25];
% mualpha = [-.25 0 .25];
% mualphad = [-.15 0 .15];

mup = [-.4 -.2 0 .2 .4];
mupd = [0];
mualpha = [-.25 0 .25];
mualphad = [0];

fp = {mup, mupd, mualpha, mualphad};

orden  = 4;
% gamma = 1e-2;
gamma = 1e-12;

[param, ~, ~] = Takagi_Sugeno_sin_a0(orden, gamma, param(2:end), fp, cellU, cellP, cellPd, cellAlpha, cellAlphad);

save ResultadosParametrosTS3 param fp

