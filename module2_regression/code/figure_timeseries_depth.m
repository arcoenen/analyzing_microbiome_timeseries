 
% timeseries plots for a single depth only
load('data/aloha_averaged');
depthID = 1;
sort_flag = 1; % sort contigs at each depth so that most abundant are on the bottom
omit_flag = 1; % omit contigs if they are totally absent from depth

% area plots
figure();
tmpX = X(:,:,depthID)';
if sort_flag==1
    [~,tmpID] = sort(mean(tmpX,'omitnan'),'descend');
    tmpX = tmpX(:,tmpID);
end
area(tmpX);
title(sprintf('depth %dm',depth(depthID)));
xlabel('cruise');
ylabel('relative abundance');
xlim([1 Ncruise]);
ylim([0 1]);
set(gca,'XTick',1:Ncruise,'XTickLabel',cruise,'XTickLabelRotation',90);
set(gca,'FontSize',14);
clear ncol nrow k fig tmp*;
if sort_flag==1
    print(sprintf('figures/timeseries_depth%d_areasort',depthID),'-dpng');
else
    print(sprintf('figures/timeseries_depth%d_area',depthID),'-dpng');
end

% heatmaps
figure();
tmpX = X(:,:,depthID);
if omit_flag==1
    tmpID = sum(tmpX,2)>0;
    tmpX = tmpX(tmpID,:);
end
tmpim = imagesc(tmpX,[0 1]);
tmpim.AlphaData = tmpX~=0 & ~isnan(tmpX);
title(sprintf('depth %dm',depth(depthID)));
xlabel('cruise');
ylabel('viral contig');
set(gca,'XTick',1:Ncruise,'XTickLabel',cruise,'XTickLabelRotation',90);
cbar = colorbar();
cbar.Label.String = 'relative abundance';
set(gca,'FontSize',14);
clear ncol nrow k fig cbar tmp*;
if omit_flag==1
    print(sprintf('figures/timeseries_depth%d_heatmapomit',depthID),'-dpng');
else
    print(sprintf('figures/timeseries_depth%d_heatmap',depthID),'-dpng');
end