
depthID = 1;
present_fraction = 0.8;
load(sprintf('data/ar_depth%d_p%d',depthID,present_fraction*100));

% autoregression coefficients
figure();
stem(sort(phi,'descend'),'o');
title(sprintf('AR(1) coefficients at depth %dm',depth(depthID)));
xlabel('contig');
ylabel('\phi');
set(gca,'FontSize',14);
print(sprintf('figures/ar_depth%d_p%d_phi',depthID,present_fraction*100),'-dpng');

% residual timeseries
figure();
plot(Xres);
xlim([1 size(Xres,1)]);
title(sprintf('AR(1) residuals at depth %dm',depth(depthID)));
xlabel('time difference');
ylabel('X_{res}');
set(gca,'FontSize',14);
print(sprintf('figures/ar_depth%d_p%d_resplot',depthID,present_fraction*100),'-dpng');

% residual timeseries - heatmap version
figure();
imagesc(Xres');
colorbar();
title(sprintf('AR(1) residuals at depth %dm',depth(depthID)));
xlabel('time difference');
ylabel('contig');
set(gca,'FontSize',14);
print(sprintf('figures/ar_depth%d_p%d_resheatmap',depthID,present_fraction*100),'-dpng');