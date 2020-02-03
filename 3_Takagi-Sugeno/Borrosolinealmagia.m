function Y = Borrosolinealmagia(X1, X2, X3)

Y = Fuzzification(X3, [-.1 .1]) * [X1; X2];
% Y = X1;
end