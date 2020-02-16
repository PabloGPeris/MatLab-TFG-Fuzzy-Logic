clear
close all
clc
global Q R tmuestra;
x = 10.^([-3:0.5:3])

tmuestra = 0.02;
for i = 1:length(x)
    Q = x(i)*eye(4);
    R = 1;
    ControlDeEstadosTS
end