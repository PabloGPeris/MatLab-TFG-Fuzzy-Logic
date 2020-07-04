%% 2 Identificación Tanque TS (Takagi-Sugeno)

clearvars
close all
clc
format shortG

addpath('..\..\Funciones');
addpath('..\1_Lineal');
load datosIdentificacion %para linearparam
load datosGeneracionTS

%% Previo

% reglasQ = {1 4 7};
% reglasQ = {1 1.5 2 3 4 5 6 7}; % normal
reglasQ = {1 2 4}; % incremental
reglasQ = FuzzySet.format(reglasQ{:});

% reglasT = {25 [30 40] [45 55] [60 70] 75}; % normal - ahora también incremental
reglasT = {20 35 50 65 80}; % incremental
% reglasT = {20 50 80};
reglasT = FuzzySet.format(reglasT{:});

FuzzySetQ = FuzzySet(reglasQ{:});
FuzzySetT = FuzzySet(reglasT{:});
%% Caudal Q

% pQ = MinCuadradosMISO(Qm, U, [1 1 1 0 0 0 0; 0 0 0 0 0 1 1; 0 0 0 0 1 1 0])%#ok<*NOPTS>

% pQx = cell(1,5);
% for i = 1:5
%     pQx{i} = MinCuadradosMISO(Qm{i}, U{i}, [1 1 1 0 0 0 0; 0 0 0 0 0 1 1; 0 0 0 0 1 1 0]);
% end


pQTS = Takagi_SugenoMISO(Qm, U, [1 1 1 0 0 0 0; 0 0 0 0 0 1 1; 0 0 0 0 1 1 0], Vb, [FuzzySetQ FuzzySetT], 1e-18, pQ)%#ok<*NOPTS>
% pQTS = Takagi_SugenoMISO(Qm{1}, U{1}, [1 1 1 0 0 0 0; 0 0 0 0 0 1 1; 0 0 0 0 1 1 0], Vb{1}, [FuzzySetQ FuzzySetT], 1e-18, pQ)%#ok<*NOPTS>

%% Temperatura T

% De manera lineal no coinciden los resultados
% pT = MinCuadradosMISO(T, U, [1 1 1 1 0; 0 0 0 1 1; 0 0 1 1 0])

% pTx = cell(1,5);
% for i = 1:5
%     pTx{i} = MinCuadradosMISO(T{i}, U{i}, [1 1 1 1 0; 0 0 0 1 1; 0 0 1 1 0]);
% end

pTTS = Takagi_SugenoMISO(T, U, [1 1 1 1 0; 0 0 0 1 1; 0 0 1 1 0], Vb, [FuzzySetQ FuzzySetT], 1e-18, pT)
% pTTS = Takagi_SugenoMISO(T{1}, U{1}, [1 1 1 1 0; 0 0 0 1 1; 0 0 1 1 0], Vb{1}, [FuzzySetQ FuzzySetT], 1e-18, pT)

%% Guardar datos

save datosIdentificacionTS pQTS pTTS FuzzySetQ FuzzySetT






