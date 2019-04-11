
% do viral contigs across replicates (sequence runs) have similar values?

load('data/aloha_clean');

[tmp_cruiseID, tmp_depthID] = find(Nreplicates>1); % 2 or more replicates

fig = figure();
nrow = 4;
ncol = 4;
for k = 1:length(tmp_cruiseID)
    tmp_repID = find(cast_cruise==ucruise(tmp_cruiseID(k)) & cast_depth==udepth(tmp_depthID(k)));
    subplot(nrow,ncol,k);
    loglog(data_mat(:,tmp_repID(1)),data_mat(:,tmp_repID(2:end)),'o');
    plot_one2one();
    xlabel('replicate 1');
    ylabel('replicates 2,3');
    title(sprintf('cruise%d %dm',ucruise(tmp_cruiseID(k)),udepth(tmp_depthID(k))));
end
fig.Position(3:4) = fig.Position(3:4)*2;
fig.Position(2) = fig.Position(2)-fig.Position(4)/2;
clear nrow ncol fig k tmp*;

print('figures/replicates','-dpng');