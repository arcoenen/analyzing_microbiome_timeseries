
% when and at what depths do casts occur?

load('data_mat/aloha_raw','cast');
load('data_mat/aloha_clean','t','cruise','depth');

figure();
hold on;
for i = 1:length(cruise)
    tmpID = cast.cruise==cruise(i);
    plot(cast.date(tmpID),cast.depth(tmpID),'o');
end
for i = 1:length(depth)
    tmp = plot(xlim,depth(i)*[1 1],'k-','HandleVisibility','off');
    uistack(tmp,'bottom');
end
tmph = legend(string(cruise),'Location','bestoutside');
tmph.Title.String = 'cruise #';
ylim([0 max(depth)+min(depth)]);
ylabel('depth (m)');
set(gca,'XTick',t,'XTickLabelRotation',90);
xtickformat('dd-MMM-yy');
set(gca,'YTick',depth,'YDir','reverse');
title('sampling times and depths');
box on;
set(gca,'FontSize',14);

clear i tmp*;
print('figures/casttimes','-dpng');