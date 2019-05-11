
% autoregression coefficients and residual timeseries
tmpdir = dir('data_mat/ar*');

for depthID = 1:length(tmpdir)
    
    load(sprintf('data_mat/%s',tmpdir(depthID).name));

    fig = figure();

    % AR coefficients
    subplot(1,2,1);
    [~,tmpID] = sort(AR(1,:),'descend');
    stem(AR(:,tmpID)');
    xlim([1 size(AR,2)]);
    xlabel('contig');
    ylabel('AR coefficient');
    legend(strcat('p=',string(1:maxP)));

    % residual timeseries
    subplot(1,2,2);
    plot(tres,X0res,'o-');
    ylabel('residual');
    xlim([tres(1) tres(end)]);
    set(gca,'XTick',tres,'XTickLabel',string(tres,'MMM-dd-yy'),'XTickLabelRotation',90);

    fig.Position(3:4) = fig.Position(3:4).*[1.25 .6];
    print(sprintf('figures/autoregression/depth%d',depthID),'-dpng');
    close;
    
end
clear tmp*;