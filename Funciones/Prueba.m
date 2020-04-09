clear


arg = {-3 -2 [-1 -.5] [.5 1] 2 3}; %argumento de la construcción de un FuzzySet
% poner un número, por ejemplo, -2, implica una función triangular (Delta,
% 'D') con vértice en -2, mientras con, por ejemplo, [-1 -.5], se trata de
% una función trapezoidal (Pi, 'P') de vértices -1 y -0.5
arg2 = FuzzySet.format(arg{:}); %Lo pasa a un formato listo para el constructor
% en este caso, arg2 sería como poner {'L', -3, 'D', -2, 'P', [-1 -.5], 'P', [.5 1], 'D',  2, 'G', 3}
%Las funciones disponibles son
% L - 'L'
% _____
%      \
%       \
%        \_____
% Gamma - 'G'
%         _____
%        /
%       /
% _____/
% Delta - 'D'
%       /\
%      /  \
% ____/    \____
% Pi - 'P'
%        ___
%       /   \
%      /     \
% ____/       \____
F = FuzzySet(arg2{:});

x = -4:.1:4;
y = zeros(length(arg), length(x));

for i = 1:length(x)
    y(:,i) = Fuzzification(F, x(i));
end

for i = 1:length(arg)
    plot(x, y(i,:));
    hold on
end
