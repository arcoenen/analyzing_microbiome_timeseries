
% regression on residual timeseries
clear;
tmpdir_AR = dir('data_mat/ar*');
tmpdir_TS = dir('data_mat/ts*');

for depthID = 1:length(tmpdir_AR)

    
    
    % regression analysis on residual timeseries
    load(sprintf('data_mat/%s',tmpdir_AR(depthID).name));

    % simple linear regression using pinv()
    k = 2;
    beta_label{k} = sprintf('simple on X_{res}');
    tmpX = [ones(length(tres),1) X0res']; % add constant term
    beta{k} = pinv(tmpX)*X0res';
    clear tmpX;

    % linear regression with L1 regularization using lasso()
    k = 4;
    beta_label{k} = 'L1 on X_{res}';
    beta{k} = zeros(length(contigID)+1,length(contigID));
    for i = 1:length(contigID)
        [tmpbeta, tmpstat] = lasso(X0res',X0res(i,:));
        tmpbeta = [tmpstat.Intercept; tmpbeta];
        beta{k}(:,i) = tmpbeta(:,1);
    end
    
    % correlation
    %{
    k = 6;
    beta_label{k} = 'corr on X_{res}';
    beta{k} = corr(X0res');
    %}
    
    

    % for comparision, also run regression analysis on original timeseries
    load(sprintf('data_mat/%s',tmpdir_TS(depthID).name));
    
    % simple linear regression using pinv() 
    k = 1;
    beta_label{k} = 'simple on X';
    tmpX = [ones(length(t),1) X0']; % add constant term
    beta{k} = pinv(tmpX)*X0';
    clear tmpX;
    
    % linear regression with L1 regularization using lasso()
    k = 3;
    beta_label{k} = 'L1 on X';
    beta{k} = zeros(length(contigID)+1,length(contigID));
    for i = 1:length(contigID)
        [tmpbeta, tmpstat] = lasso(X0',X0(i,:));
        tmpbeta = [tmpstat.Intercept; tmpbeta];
        beta{k}(:,i) = tmpbeta(:,1);
    end    
    
    % correlation
    %{
    k = 5;
    beta_label{k} = 'corr on X';
    beta{k} = corr(X0');
    %}

    
    
    % fraction of interactions which are negative vs positive vs zero
    betafrac = zeros(2,length(beta));
    betafrac_thresh = 0; % values less than threshold are considered 'zero'
    for k = 1:length(beta)
        betafrac(1,k) = sum(beta{k}(:)<-betafrac_thresh); % negative values
        betafrac(2,k) = sum(beta{k}(:)>betafrac_thresh); % positive values
    end
    betafrac = betafrac/(length(contigID)*(length(contigID)+1)); % normalize
    betafrac_label = {'negative','positive'};
    
    
    save(sprintf('data_mat/reg_depth%d',depthID),'beta','beta_label','betafrac','betafrac_label','betafrac_thresh','depth','depthID');

    
end

fprintf('regression analysis complete for all depths\n');