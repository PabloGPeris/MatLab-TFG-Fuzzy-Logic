clear all;
clc;

format shortG;


ttotal = 10;
tmuestra = 0.05;
var = 0.001;

%conv = convolución
num = conv(conv(conv([1 0.5], [1 0.7]),[1 -0.2]),[0 1])
denom = conv(conv(conv([1 0.2], [1 -0.6]),[1 0.4]),[1 -0.1])

tiempo = (0:tmuestra:ttotal)';
n = size(tiempo, 1);



u(1:n, 1) = tiempo;
u(1:floor(0.5*n), 2) = 0;
u(floor(0.5*n):n, 2) = 1;


C = {};
for iseed = 1:100
    sim('SistemaLineal');
    C = [C, defY(:, 2), defU(:,2)];
end


orden = 4;

[param] = MinCuadradosMultiple(orden, C{1:100});

%figure; plot(tiempo,defY(:, 2));title('Salida');
%figure; plot(tiempo,defU(:,2)); title('Entrada');

param