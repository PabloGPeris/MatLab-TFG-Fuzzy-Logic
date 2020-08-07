clearvars
clc
close all

addpath('..\..\Funciones');
addpath('..\');

load datosIdentificacionPolar

%%


% FSetArg, FSetMod
figure;
[Q, T] = meshgrid(0:0.05:8, 10:0.1:90);
% Q = linspace(0, 8, 100);
% T = linspace(10,90,100);

w = zeros(size(Q));
for i = 1:size(Q,1)
    for j = 1:size(Q,2)
        % previo
        Qnorm = Normalizacion(Q(i,j), 'rango', 0, 8);
        Tnorm = Normalizacion(T(i,j), 'rango', 10, 90);
        [theta,rho] = cart2pol(Qnorm,Tnorm);

        mu = Fuzzification_polar([theta,rho], FuzzySetArg, FuzzySetMod);
        w(i,j) = max(mu);
    end
end

%%
save Dibujos Q T w
%%
load Dibujos
surf(Q,T,w,'edgecolor', 'none');
