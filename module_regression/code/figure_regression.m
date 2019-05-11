
tmpdir = dir('data_mat/reg*');

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
end
fig.Position(3) = fig.Position(3)*1.75;
print('figures/regression/summary_posneg','-dpng');
print('figures/paper_figures/aloha4b','-dpng');


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
print(sprintf('figures/regression/depth%d',depthID),'-dpng');
print('figures/paper_figures/aloha4a_depth1','-dpng');


% regression matrices
fig = figure();
nrow = length(depth);
ncol = length(beta);
kk = 1;
for depthID = 1:length(tmpdir)
    load(sprintf('data_mat/%s',tmpdir(depthID).name));
    for k = 1:length(beta)
        subplot(nrow,ncol,kk);
        tmpim = imagesc(beta{k},[-1 +1]);
        tmpim.AlphaData = abs(beta{k})>betafrac_thresh;
        colormap(flip(redbluecmap()));
        set(gca,'XTickLabel',[],'YTickLabel',[]);
        if k==1; ylabel(sprintf('depth %dm',depth(depthID)),'FontWeight','bold'); end
        if kk<=length(beta); title(beta_label{k}); end
        kk = kk+1;
    end
end
fig.Position(3:4) = fig.Position(3:4).*[1.5 3];
print('figures/regression/summary','-dpng');
print('figures/paper_figures/aloha4a','-dpng');
