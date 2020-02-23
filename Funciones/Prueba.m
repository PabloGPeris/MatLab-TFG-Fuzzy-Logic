clear

% F = FuzzySet('L', -3, 'D', -2, 'P', [-1 1], 'D', 2, 'G', 3);
arg = {-3 -2 [-1 -.5] [.5 1] 2 3};
arg2 = FuzzySet.format(arg{:});
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
