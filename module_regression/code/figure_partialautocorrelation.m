

% partial autocorrelation coefficients for individual contigs
% only plot contigs with at least one significant pac
filestr = dir('data_mat/pac*');

for depthID = 1:length(filestr)
    
    % load data
    load(sprintf('data_mat/%s',filestr(depthID).name));
    fig = figure();

    % subplot orientation
    tmpN = length(sigID_contig);
    tmp = factor(tmpN);
    tmpi = 1;
    while length(tmp)==1
        tmp = factor(tmpN-tmpi);
        tmpi = tmpi+1;
    end
    ncol = tmp(end);
    nrow = ceil(tmpN/ncol);
    clear tmp*;

    % plot pac
    for k = 1:length(sigID_contig)
        subplot(nrow,ncol,k);
        tmpk = sigID_contig(k);
        stem(lag(~sigID_lag(:,tmpk))',pac(~sigID_lag(:,tmpk),tmpk));
        hold on;
        stem(lag(sigID_lag(:,tmpk))',pac(sigID_lag(:,tmpk),tmpk));
        plot(lag,repmat([+1 -1]*pac_thresh,[length(lag),1]),'Color',[.7 .7 .7]);
        hold off;
        xlim([0 lag(end)]);
        title(sprintf('contig %d',contigID(tmpk)));
        xlabel('lag');
        ylabel('PAC');
    end
    fig.Position(3:4) = fig.Position(3:4).*[2 3];
    print(sprintf('figures/partialautocorrelation/depth%d',depthID),'-dpng');
    close;
    
end



