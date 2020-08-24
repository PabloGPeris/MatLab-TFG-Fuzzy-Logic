function ts = Tiempo_establecimiento(t, var)
dist = abs(var(end) - var(1))*0.05;

idx = 1;
for i = 1:length(t)
    if abs(var(i) - var(end)) > dist
        idx = i;
    end
end

ts = t(idx);
end