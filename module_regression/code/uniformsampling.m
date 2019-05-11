
fprintf('adjusting sampling times...\n');

%% DESIGNATE A UNIFORM TIME VECTOR

clear;
load('data_mat/aloha_clean','t');

dt = days(diff(t));

% choose uniform sample times such that they are as close as possible to
% the original sample times
% (ad hoc / brute force - sweep across different sampling intervals and
% start times)
sweep.dt = 20:0.1:40;
sweep.t1 = t(1)+days(-10:0.2:10);
sweep.NT = nan(length(sweep.dt),length(sweep.t1));
sweep.err = nan(length(sweep.dt),length(sweep.t1));
sweep.err2 = nan(length(sweep.dt),length(sweep.t1));
for k = 1:length(sweep.dt)
    for l = 1:length(sweep.t1)
        sweep.NT(k,l) = ceil(days(t(end)-sweep.t1(l))/sweep.dt(k));
        tmpt = sweep.t1(l)+sweep.dt(k)*(0:sweep.NT(k,l))';
        tmpID = zeros(length(t),1);
        for i = 1:length(t)
            [~,tmpID(i)] = min(abs(t(i)-tmpt));
        end
        if length(unique(tmpID))==length(t) % each time in t must map to a unique time in tmpt
            sweep.err(k,l) = sum(days(tmpt(tmpID)-t).^2);
            sweep.err2(k,l) = days(mean(abs(tmpt(tmpID)-t)));
        end
    end
end
clear k l i tmp*;

% find the sample times w/ minimum error (penalized by NT)
sweep.pen_weight = 500; % note: changing pen_weight changes the minimum
sweep.errpen = sweep.err+sweep.NT*sweep.pen_weight;
[~,tmpID] = min(sweep.errpen(:));
[sweep.dtID,sweep.t1ID] = ind2sub(size(sweep.errpen),tmpID);
t_uniform = sweep.t1(sweep.t1ID)+sweep.dt(sweep.dtID)*(0:sweep.NT(sweep.dtID,sweep.t1ID))';
clear tmp*;

% map the original times to the uniform times
uID = zeros(length(t),1);
for i = 1:length(t)
    [~,uID(i)] = min(abs(t(i)-t_uniform));
end
clear i;

fprintf('uniform sample times chosen:\n');
fprintf('sample interval = %.2g days\n',days(t_uniform(2)-t_uniform(1)));
fprintf('number of added samples = %d\n',length(t_uniform)-length(t));
fprintf('average shift from original time = %.2g days\n',days(mean(abs(t_uniform(uID)-t))));
save('data_mat/aloha_uniformsampling');


%% FILL IN THE MISSING SAMPLES WITH NANS

clear;
load('data_mat/aloha_clean');
load('data_mat/aloha_uniformsampling','t_uniform','uID');

% pad data matrix
uN = length(t_uniform);
ucruise = nan(uN,1);
ucruise(uID) = cruise;
uX = nan(size(X,1),uN,size(X,3));
uX(:,uID,:) = X;

% rename variables
cruise = ucruise;
X = uX;
t = t_uniform;
clear ucruise uX uN uID t_uniform;
fprintf('uniform sample times applied to aloha data\n');
save('data_mat/aloha_clean_uniform');


