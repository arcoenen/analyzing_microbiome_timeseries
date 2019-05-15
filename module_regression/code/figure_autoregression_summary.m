
% autoregression coefficients and residual timeseries
% for all depths in a single figure
tmpdir = dir('data_mat/ar*');

nrow = 2;
ncol = 4;

% AR coefficients
fig = figure();
for depthID = 1:length(tmpdir)
    load(sprintf('data_mat/%s',tmpdir(depthID).name));
    subplot(nrow,ncol,depthID);
    [~,tmpID] = sort(AR(1,:),'descend');
    stem(AR(:,tmpID)');
    xlim([1 size(AR,2)]);
    xlabel('contig');
    ylabel('AR coefficient');
    legend(strcat('p=',string(1:maxP)));
    title(sprintf('depth %dm',depth(depthID)));
end
fig.Position(3) = fig.Position(3)*1.75;
print('figures/autoregression/summary_coefficients','-dpng');

% residual timeseries
fig = figure();
for depthID = 1:length(tmpdir)
    load(sprintf('data_mat/%s',tmpdir(depthID).name));
    subplot(nrow,ncol,depthID);
    plot(tres,X0res,'o-');
    ylabel('residual');
    xlim([tres(1) tres(end)]);
    set(gca,'XTick',tres,'XTickLabel',string(tres,'MMM-dd-yy'),'XTickLabelRotation',90);
    title(sprintf('depth %dm',depth(depthID)));
end
fig.Position(3) = fig.Position(3)*1.75;
print('figures/autoregression/summary_residuals','-dpng');
