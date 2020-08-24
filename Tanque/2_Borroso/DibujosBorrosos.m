clearvars
clc
close all

addpath('..\..\Funciones');
addpath('..\');

load datosIdentificacionTS

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

        w(i,j) = max(FuzzySetQ.Fuzzification(Q(i,j))) * max(FuzzySetT.Fuzzification(T(i,j)));

    end
end

%%
save Dibujos Q T w
%%
load Dibujos
surf(Q,T,w,'edgecolor', 'none');