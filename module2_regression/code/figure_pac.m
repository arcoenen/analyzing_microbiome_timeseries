
depthID = 1;
present_fraction = 0.8;
load(sprintf('data/pac_depth%d_p%d',depthID,present_fraction*100));

% partial autocorrelation for individual contigs
fig = figure();
tmp = factor(N0contig);
tmpi = 1;
while length(tmp)==1
    tmp = factor(N0contig-tmpi);
    tmpi = tmpi+1;
end
ncol = tmp(end);
nrow = ceil(N0contig/ncol);
clear tmp;
for k = 1:N0contig
    subplot(nrow,ncol,k);
    stem(lag,pac(:,k));
    title(sprintf('contig %d',contigID(k)));
    xlabel('lag');
    ylabel('PAC');
end
fig.Position(3:4) = fig.Position(3:4).*[2 3];
fig.Position(2) = fig.Position(2)-fig.Position(4)/2;
print(sprintf('figures/pac_depth%d_p%d_contigs',depthID,present_fraction*100),'-dpng');

% boxplot of partial autocorrelation for all contigs
lagID = 1:4;
figure();
boxplot(pac(lagID,:)',lag(lagID));
hold on;
plot(xlim,[0 0],'k');
hold off;
xlabel('lag');
ylabel('PAC');
title(sprintf('all contigs at depth %dm',depth(depthID)));
set(gca,'FontSize',14);
print(sprintf('figures/pac_depth%d_p%d_boxplot',depthID,present_fraction*100),'-dpng');

