
% autoregression to obtain residual timeseries
clear;
analysis_setup;

% simple take 1 (need to modify) - autoregression with maximum lag p=1
% ideally maximum lag is determined by partial autocorrelation

% with maximum lag p=1, can compute coefficients directly (faster than
% using arima() and estimate())
X1 = X0(:,1:end-1)';
X2 = X0(:,2:end)';
phi = sum((X1-mean(X1)).*(X2-mean(X2)))./sum(X1.^2-mean(X1).^2);

% compute residuals
Xres = X2-phi.*X1;

save(sprintf('data/ar_depth%d_p%d',depthID,present_fraction*100),'Xres','phi','contigID','present_fraction','depthID','depth');
