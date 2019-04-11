
depthID = 1;
present_fraction = 0.8;
load(sprintf('data/reg_depth%d_p%d',depthID,present_fraction*100));

fig = figure();

subplot(1,2,1);
imagesc(beta1,[-1 1]);
colorbar();
colormap(gca,flip(redbluecmap()));
title('no regularization');
xlabel('contigs');
ylabel('contigs');
set(gca,'FontSize',14,'XTickLabels',[],'YTickLabels',[]);

subplot(1,2,2);
imagesc(beta2,[-1 1]);
colorbar();
colormap(gca,flip(redbluecmap()));
title('L1 regularization');
xlabel('contigs');
ylabel('contigs');
set(gca,'FontSize',14,'XTickLabels',[],'YTickLabels',[]);

fig.Position(3:4) = fig.Position(3:4).*[2 1];

print(sprintf('figures/reg_depth%d_p%d',depthID,present_fraction*100),'-dpng');