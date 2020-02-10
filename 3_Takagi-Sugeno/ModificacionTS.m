%%Modificaci�n de los par�metros resultado apartir de las simulaciones TS sobre gamma

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
% mualpha = [-.25 -.15 0 .15 .25];
% mualphad = [-.15 0 .15];

% mup = [-.4 -.2 0 .2 .4];%#ok<*NBRAK>
% mupd = [0]; 
% mualpha = [-.25 0 .25];
% mualphad = [0];

mup = [0];
mupd = [0]; 
mualpha = [0];
mualphad = [0];

fp = {mup, mupd, mualpha, mualphad};
orden  = 4;

% tmn = length(mup) * length(mupd) * length(mualpha) * length(mualphad);
% pos_central = floor(length(mup)/2) * length(mupd) * length(mualpha) * length(mualphad);
% pos_central = pos_central + floor(length(mupd)/2) * length(mualpha) * length(mualphad);
% pos_central = pos_central + floor(length(mualpha)/2) *  length(mualphad);
% pos_central = pos_central + floor(length(mualphad)/2) + 1;
% gamma = ones(tmn, 1) * 1e-12;
% gamma(pos_central) = 100;

gamma = 1e-12;

% [param, phi, ~] = Takagi_Sugeno_sin_a0(orden, gamma, param(2:end), fp, cellU, cellP, cellPd, cellAlpha, cellAlphad);
[param, phi, ~] = Takagi_Sugeno_c(orden, gamma, param, fp, cellU, cellP, cellPd, cellAlpha, cellAlphad);
save ResultadosParametrosTS3 param fp

