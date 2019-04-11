
% regression on residual timeseries
clear;
analysis_setup;
load(sprintf('data/ar_depth%d_p%d',depthID,present_fraction*100));

% simple linear regression
beta1 = pinv(Xres)*Xres;

% linear regression with L1 regularization
% need to run for each contig separately...
beta2 = zeros(N0contig,N0contig);
for i = 1:N0contig
    [tmpbeta, stat] = lasso(Xres,Xres(:,i));
    beta2(:,i) = tmpbeta(:,1);
end

% for comparision, also run regression analysis on original timeseries (not
% residuals)

% check heuristics for overfitting

save(sprintf('data/reg_depth%d_p%d',depthID,present_fraction*100),'beta1','beta2','contigID');