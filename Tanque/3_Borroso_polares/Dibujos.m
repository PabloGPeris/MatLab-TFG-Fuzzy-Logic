clearvars
clc
close all

addpath('..\..\Funciones');
addpath('..\');

% load datosIdentificacionPolar
% load datosIdentificacionPolar2
load datosIdentificacionPolar3
%%


figure;
[Q, T] = meshgrid(0:0.01:8, 10:0.5:90);

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
% [rho, theta] = meshgrid(0:0.01:1, -pi:0.01:pi);
% 
% w = zeros(size(rho));
% for i = 1:size(rho,1)
%     for j = 1:size(rho,2)
% 
%         mu = Fuzzification_polar([theta(i,j),rho(i,j)], FuzzySetArg, FuzzySetMod);
%         w(i,j) = max(mu);
%     end
% end
% 
% surf(rho,theta,w,'edgecolor', 'none');
%%
save Dibujos Q T w
%%
load Dibujos
surf(Q,T,w,'edgecolor', 'none');
