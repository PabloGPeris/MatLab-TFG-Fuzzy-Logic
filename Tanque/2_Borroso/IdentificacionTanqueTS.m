%% 2 Identificación Tanque TS (Takagi Sugeno)

clearvars
close all
clc
format shortG

addpath('..\..\Funciones');

load datosGeneracionTS

%% Previo

reglasQ = {1 4 7};
reglasQ = FuzzySet.format(reglasQ{:});

reglasT = {20 50 80};
reglasT = FuzzySet.format(reglasT{:});

FuzzySetQ = FuzzySet(reglasQ{:});
FuzzySetT = FuzzySet(reglasT{:});
%% Caudal Q

% pQ = MinCuadradosMISO(Qm, U, [1 1 1 0 0 0 0; 0 0 0 0 0 1 1; 0 0 0 0 1 1 0])%#ok<*NOPTS>
pQ = Takagi_SugenoMISO(Qm, U, [1 1 1 0 0 0 0; 0 0 0 0 0 1 1; 0 0 0 0 1 1 0], T, [FuzzySetQ FuzzySetT])

%% Temperatura T

% De manera lineal no cinciden los resultados
% pT = MinCuadradosMISO(T, U, [1 1 1 1 0; 0 0 0 1 1; 0 0 1 1 0])

% pTx = cell(1,5);
% for i = 1:5
%     pTx{i} = MinCuadradosMISO(T{i}, U{i}, [1 1 1 1 0; 0 0 0 1 1; 0 0 1 1 0])
% end


%% Guardar datos

save datosIdentificacionTS pQ %pT






