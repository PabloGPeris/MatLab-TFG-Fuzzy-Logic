function output = Fuzzification_polar(Vb, FSetArg, FSetMod)
%FUZZIFICATION_POLAR (Vb, FSetArg, FSetMod)
%   Hace la borrosificación de las variables borrosas argumento y módulo en
%   función del FuzzySetArgumento FSetArg y los FSetMod. Se recomienda que
%   el primer FSetMod (en modo vector) sea no borroso ('-')
%   Vb = [argumento módulo]

output = [];

moduloFuzzy = FSetMod.Fuzzification(Vb(2));
for i = 1:length(moduloFuzzy)
    output = [output moduloFuzzy(i)*FSetArg(i).Fuzzification(Vb(1))];
end
end

