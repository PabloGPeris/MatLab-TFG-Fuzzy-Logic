% Aquí simplemente hice algunas pruebas, no mirar demasiado este archivo

clc;
clearvars;
close all;
addpath('..\Funciones');
%%

load ResultadosSimulacion
P = [];
Pd = [];
Alpha = [];
Alphad = [];
for i = 0:length(C)/5 - 1
    P = [P; C{5*i + 1}];
    Pd = [Pd; C{5*i + 2}];
    Alpha = [Alpha; C{5*i + 3}];
    Alphad = [Alphad; C{5*i + 4}];
end
figure; plot(P, Pd, '.');  xlabel('Posición'); ylabel('Velocidad');
figure; plot(Alpha, Alphad, '.');  xlabel('Ángulo'); ylabel('Vel. angular');
%%
% t = -.5:0.01:.5;
% s = size(t,2);
% mup = zeros(5, s);
% mupd = zeros(3, s);
% weight = zeros(s,s);
% for i=1:s
%    mup(:,i) = mu_p(t(i));
% end
% for i=1:s
%    mupd(:,i) = mu_pd(t(i));
% end
% for i=1:s
%     for j = 1:s
%         weight(i,j)=max(mup(:,i))*max(mupd(:,j));
%     end
% end
% 
% surfc(t,t,weight);
% Beta(x) = peso(x) ya que el sumatorio de los pesos es igual a 1