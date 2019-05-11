
% autoregression to obtain residual timeseries
clear;

maxP = 2; % maximum allowed time lag

dir_pac = dir('data_mat/pac*');
dir_ts = dir('data_mat/ts*');
for depthID = 1:length(dir_pac)
    
    load(sprintf('data_mat/%s',dir_pac(depthID).name));
    load(sprintf('data_mat/%s',dir_ts(depthID).name));
    
    % set up AR(p) model with p = lags identified by partial
    % autocorrelation
    P = sum(sigID_lag(1:maxP+1,:))-1; % only consider lags 1 thru maxP
    AR = zeros(maxP,length(contigID)); % collect AR coefficients
    tmpPID = find(P>0); % skip P=0 contigs
    for i = 1:length(tmpPID)
        tmpi = tmpPID(i);
        try % start with AR(p) model
            tmpmodel = arima(P(tmpi),0,0);
            tmpest = estimate(tmpmodel,X0(tmpi,:)');
            tmpAR = cell2mat(tmpest.AR);
        catch
            try % try AR(1) instead
            	tmpmodel = arima(1,0,0);
                tmpest = estimate(tmpmodel,X0(tmpi,:)');
                tmpAR = cell2mat(tmpest.AR);
            catch % failure
                tmpAR = nan(1,maxP);
            end
        end
        AR(1:length(tmpAR),tmpi) = tmpAR;
    end
    clear tmp* i;
    
    % compute residual timeseries
    X0res = X0(:,1:end-maxP);
    tres = t(1:end-maxP);
    for i = 1:length(contigID)
        for p = 1:P(i)
            X0res(i,:) = X0res(i,:) - X0(i,(p+1):(end-maxP+p))*AR(p,i);
        end
        % how to handle nans?
        X0res(isnan(X0res)) = 0;
    end
    clear i p;

    save(sprintf('data_mat/ar_depth%d',depthID),'AR','X0res','tres','contigID','depth','depthID','maxP');
    
end
    
fprintf('autoregression analysis complete for all depths\n');