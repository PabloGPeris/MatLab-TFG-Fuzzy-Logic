clearvars;
close all;
clc;


load Resultados;
load Parametros;


tmuestra = 0.05;

datos = iddata(Y, U, tmuestra);

orden = 4;

sol = arx(datos, [orden orden 0]);

[PVEC, ~] = getpvec(sol)

param
