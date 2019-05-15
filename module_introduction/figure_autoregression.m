
if ~exist('X','var')
    fprintf('running autoregression tutorial...\n');
    tutorial_autoregression
end

fs = 8;
fig = figure();

subplot(2,2,1);
plot(X);
xlabel('time');
ylabel('abundance');
title('Independent random walks');
set(gca,'FontSize',fs);

subplot(2,2,2);
plot_correlation(rho_X,pval_X);
title(sprintf('Correlations among\nindependent random walks'));
set(gca,'FontSize',fs);

subplot(2,2,3);
plot(Xresidual);
tmpy = ylim;
ylim([-1 +1]*max(abs(tmpy)));
xlabel('time');
ylabel('X_{residual}');
title(sprintf('Residuals of\nindependent random walks'));
set(gca,'FontSize',fs);

subplot(2,2,4);
plot_correlation(rho_Xresidual,pval_Xresidual);
title(sprintf('Correlations among\nresidual timeseries'));
set(gca,'FontSize',fs);

fig.Units = 'inches';
fig.Position(3:4) = [6 4];
print('figure_autoregression','-dpng');