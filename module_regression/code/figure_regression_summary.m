
tmpdir = dir('data_mat/reg*');

% regression matrices - example at a single depth
fig = figure();
depthID = 1;
load(sprintf('data_mat/%s',tmpdir(depthID).name));
k = [2 4];
for kk = 1:length(k)
    subplot(1,2,kk);
    tmpim = imagesc(beta{k(kk)},[-1 +1]);
    tmpim.AlphaData = abs(beta{k(kk)})>betafrac_thresh;
    colormap(flip(redbluecmap()));
    set(gca,'XTickLabel',[],'YTickLabel',[]);
    colorbar();
    title(beta_label{k(kk)});
end
fig.Position(3:4) = fig.Position(3:4).*[1 0.5];
print('figures/manuscript/aloha3a','-dpng');

%%

% positive vs negative comparisons
fig = figure();
nrow = 2;
ncol = 4;
for depthID = 1:length(tmpdir)
	load(sprintf('data_mat/%s',tmpdir(depthID).name));
    subplot(nrow,ncol,depthID)
    bar(betafrac','stacked');
    set(gca,'XTickLabel',beta_label,'XTickLabelRotation',90);
    ylabel('fraction of pairs');
    %legend({'negative','positive'});
    title(sprintf('depth %dm',depth(depthID)));
    set(gca,'FontSize',12);
end
fig.Position(3:4) = fig.Position(3:4).*[1.75 1.25];
print('figures/regression/summary_posneg','-dpng');
print('figures/manuscript/aloha3b','-dpng');