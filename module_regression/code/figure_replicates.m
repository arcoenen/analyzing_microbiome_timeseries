
% do contigs across replicates have similar relative abundances?

load('data_mat/aloha_raw');
load('data_mat/aloha_clean','cruise','depth');
load('data_mat/aloha_replicates');

% only plot cases with 2 or more replicates
tmp_reps = replicates_table(:,[1 3:end]).Variables; % omit depth 45m
[tmp_cruiseID, tmp_depthID] = find(tmp_reps>1);

fig = figure();
nrow = 4;
ncol = 4;
for k = 1:length(tmp_cruiseID)
    tmp_repID = find(cast.cruise==cruise(tmp_cruiseID(k)) & cast.depth==depth(tmp_depthID(k)));
    subplot(nrow,ncol,k);
    loglog(data_mat(:,tmp_repID(1)),data_mat(:,tmp_repID(2:end)),'o');
    plot_one2one();
    xlabel('replicate 1');
    ylabel('replicates 2,3');
    title(sprintf('cruise%d %dm',cruise(tmp_cruiseID(k)),depth(tmp_depthID(k))));
end
fig.Position(3:4) = fig.Position(3:4)*2;
fig.Position(2) = fig.Position(2)-fig.Position(4)/2;
clear nrow ncol fig k tmp*;

print('figures/replicates','-dpng');