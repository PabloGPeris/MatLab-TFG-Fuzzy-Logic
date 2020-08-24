figure;
for i = 1:length(FuzzySetArg)
    subplot(2,2,i);

    FuzzySetArg(i).plotFS(100);
    title(num2str(i));
    xlim([-pi pi]);
end