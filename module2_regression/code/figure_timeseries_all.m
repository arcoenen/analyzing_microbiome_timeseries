
% timeseries plots for each depth
load('data/aloha_averaged');
sort_flag = 1; % sort contigs at each depth so that most abundant are on the bottom
omit_flag = 1; % omit contigs if they are totally absent from depth

% area plots
fig = figure();
nrow = 2;
ncol = 4;
for k = 1:Ndepth
    subplot(nrow,ncol,k);
    tmpX = X(:,:,k)';
    if sort_flag==1
        [~,tmpID] = sort(mean(tmpX,'omitnan'),'descend');
        tmpX = tmpX(:,tmpID);
    end
    area(tmpX);
    title(sprintf('depth %dm',depth(k)));
    xlabel('cruise');
    ylabel('relative abundance');
    xlim([1 Ncruise]);
    ylim([0 1]);
    set(gca,'XTick',1:Ncruise,'XTickLabel',cruise,'XTickLabelRotation',90);
end
fig.Position(3:4) = fig.Position(3:4).*[2 1];
clear ncol nrow k fig tmp*;
if sort_flag==1
    print('figures/timeseries_all_areasort','-dpng');
else
    print('figures/timeseries_all_area','-dpng');
end

% heatmaps
fig = figure();
nrow = 2;
ncol = 4;
for k = 1:Ndepth
    subplot(nrow,ncol,k);
    tmpX = X(:,:,k);
    if omit_flag==1
        tmpID = sum(tmpX,2,'omitnan')>0;
        tmpX = tmpX(tmpID,:);
    end
    tmpim = imagesc(tmpX,[0 1]);
    tmpim.AlphaData = tmpX~=0 & ~isnan(tmpX);
    title(sprintf('depth %dm',depth(k)));
    xlabel('cruise');
    ylabel('viral contig');
    set(gca,'XTick',1:Ncruise,'XTickLabel',cruise,'XTickLabelRotation',90);
end
tmppos = get(gca,'Position');
cbar = colorbar('Location','manual','Position',[tmppos(1)+.17 tmppos(2) 0.017 tmppos(4)]);
cbar.Label.String = 'relative abundance';
fig.Position(3:4) = fig.Position(3:4).*[2 1];
clear ncol nrow k fig cbar tmp*;
if omit_flag==1
    print('figures/timeseries_all_heatmapomit','-dpng');
else
    print('figures/timeseries_all_heatmap','-dpng');
end

