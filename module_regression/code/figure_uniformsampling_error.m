
% enforcing uniform sampling (error)

load('data_mat/aloha_uniformsampling');

fig = figure();

tmpx = find(sweep.t1>=t(1),1);
tmpy = length(sweep.dt);

subplot(1,3,1);
tmpim = imagesc(sweep.err);
tmpim.AlphaData = ~isnan(sweep.err);
hold on;
plot([tmpx tmpx],[0 tmpy]+0.5,'r');
plot(sweep.t1ID,sweep.dtID,'w*');
hold off;
colorbar();
ylabel('sampling interval (days)');
xlabel('start time');
set(gca,'XTickLabel',string(sweep.t1(xticks),'MMM-dd'),'XTickLabelRotation',90);
set(gca,'YTickLabel',string(sweep.dt(yticks)));
title('error');

subplot(1,3,2);
tmpim = imagesc(sweep.NT);
tmpim.AlphaData = ~isnan(sweep.NT);
hold on;
plot([tmpx tmpx],[0 tmpy]+0.5,'r');
plot(sweep.t1ID,sweep.dtID,'w*');
hold off;
colorbar();
ylabel('sampling interval (days)');
xlabel('start time');
set(gca,'XTickLabel',string(sweep.t1(xticks),'MMM-dd'),'XTickLabelRotation',90);
set(gca,'YTickLabel',string(sweep.dt(yticks)));
title('NT');

subplot(1,3,3);
tmpim = imagesc(sweep.errpen);
tmpim.AlphaData = ~isnan(sweep.errpen);
hold on;
plot([tmpx tmpx],[0 tmpy]+0.5,'r');
plot(sweep.t1ID,sweep.dtID,'w*');
hold off;
colorbar();
ylabel('sampling interval (days)');
xlabel('start time');
set(gca,'XTickLabel',string(sweep.t1(xticks),'MMM-dd'),'XTickLabelRotation',90);
set(gca,'YTickLabel',string(sweep.dt(yticks)));
title('error penalized by NT');

fig.Position(3:4) = fig.Position(3:4).*[2 .75];
print('figures/uniformsampling_error','-dpng');
clear tmp* fig;