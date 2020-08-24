%% 2 Identificación Tanque Polar (Takagi-Sugeno)

clearvars
close all
clc
format shortG

addpath('..\..\Funciones');
addpath('..\1_Lineal');
load datosIdentificacion %para linearparam
load datosGeneracionPolar2

%% Reglas (1,3)

% reglasmod = {0 1 0.7 0.9}; %llega hasta raíz de 2 en teoría - 1 aprox en realidad
% % reglasmod = {0 0.5 0.8}; %llega hasta raíz de 2 en teoría - 1 aprox en realidad
% reglasmod = FuzzySet.format(reglasmod{:});
% 
% reglasarg1 = {-pi -2.5 -1 1 2.5}; 
% reglasarg1 = FuzzySetArgumento.format(reglasarg1{:});
% 
% reglasarg2 = {-pi -2.5 -2 -1.5 0 1.5 2 2.5}; 
% reglasarg2 = FuzzySetArgumento.format(reglasarg2{:});
% 
% FuzzySetMod = FuzzySet(reglasmod{:});
% FuzzySetArg1 = FuzzySetArgumento(reglasarg1{:});
% FuzzySetArg2 = FuzzySetArgumento(reglasarg2{:});
% FuzzySet0 = FuzzySetArgumento('-', 0);
% 
% 
% FuzzySetArg = [FuzzySet0 FuzzySetArg1 FuzzySetArg2 FuzzySetArg2];
% % FuzzySetArg = [FuzzySet0 FuzzySetArg1 FuzzySetArg2];

%% Reglas (1,3)

reglasmod = {0 1.5 2.1 2.7}; %llega hasta 3 en teoría 
reglasmod = FuzzySet.format(reglasmod{:});

reglasarg1 = {-pi -2.5 -1 1 2.5}; 
reglasarg1 = FuzzySetArgumento.format(reglasarg1{:});

reglasarg2 = {-pi -2.5 -2 -1.5 0 1.5 2 2.5}; 
reglasarg2 = FuzzySetArgumento.format(reglasarg2{:});

FuzzySetMod = FuzzySet(reglasmod{:});
FuzzySetArg1 = FuzzySetArgumento(reglasarg1{:});
FuzzySetArg2 = FuzzySetArgumento(reglasarg2{:});
FuzzySet0 = FuzzySetArgumento('-', 0);


FuzzySetArg = [FuzzySet0 FuzzySetArg1 FuzzySetArg2 FuzzySetArg2];
% FuzzySetArg = [FuzzySet0 FuzzySetArg1 FuzzySetArg2];
%% Caudal Q

pQPolar = Takagi_SugenoPolar(Qm, U, [1 1 1 0 0 0 0; 0 0 0 0 0 1 1; 0 0 0 0 1 1 0], Vb, FuzzySetArg, FuzzySetMod, 1e-18, pQ)%#ok<*NOPTS>


%% Temperatura T


pTPolar = Takagi_SugenoPolar(T, U, [1 1 1 1 0; 0 0 0 1 1; 0 0 1 1 0], Vb, FuzzySetArg, FuzzySetMod, 1e-18, pT)


%% Guardar datos

save datosIdentificacionPolar pQPolar pTPolar FuzzySetMod FuzzySetArg % No incremental
% save datosIdentificacionPolar2 pQPolar pTPolar FuzzySetMod FuzzySetArg % Cambio de normalización (normal)
% save datosIdentificacionPolar3 pQPolar pTPolar FuzzySetMod FuzzySetArg % Incremental




