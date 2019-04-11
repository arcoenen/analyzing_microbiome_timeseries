
% partial autocorrelation
clear;
analysis_setup;

% partial autocorrelation
Nlag = Ncruise-1;
pac = zeros(Nlag+1,N0contig);
for i = 1:N0contig
    pac(:,i) = parcorr(X0(i,:),'NumLags',Nlag);
end
lag = 0:Nlag;

% some pacs are much larger than 1 -- this is a problem, implies
% non-stationary timeseries. need to detrend or difference first?

save(sprintf('data/pac_depth%d_p%d',depthID,present_fraction*100),'contigID','cruise','depth','depthID','lag','N0contig','Nlag','pac','present_fraction','X0');