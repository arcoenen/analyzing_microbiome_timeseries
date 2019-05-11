
% enforcing uniform sampling

load('data_mat/aloha_uniformsampling');

fig = figure();

subplot(1,2,1);
plot(dt,'o-');
ylim([0 max(dt)+5]);
xlabel('cast number');
ylabel('time until next cast (days)');
title('ALOHA 1.0 cast intervals');

newID = ones(length(t_uniform),1);
newID(uID) = 0;
newID = find(newID);

subplot(1,2,2);
plot(t,t_uniform(uID),'o');
hold on;
stem(t_uniform(newID),t_uniform(newID),'r.');
hold off;
plot_one2one();
legend({'existing cast times','added cast times'},'Location','NorthWest');
xlabel('original cast times');
ylabel('proposed cast times');
title(sprintf('uniform cast times (dt=%.2g days)',days(t_uniform(2)-t_uniform(1))));

fig.Position(3) = fig.Position(3)*2;
print('figures/uniformsampling','-dpng');
clear fig newID;

