
% partial autocorrelation
clear;

Nlag = 6;
lag = 0:Nlag;
pac_thresh = 0.3;

% run analysis for each depth
tmpdir = dir('data_mat/ts*');
for depthID = 1:length(tmpdir)
    
    % load data
    load(sprintf('data_mat/%s',tmpdir(depthID).name));
    
    % partial autocorrelation for each contig
    pac = zeros(Nlag+1,length(contigID));
    for i = 1:length(contigID)
       pac(:,i) = parcorr(X0(i,:),'NumLags',Nlag); 
    end
    clear i X0 t
    
    % apply threshold to get rid of weak pacs
    sigID_lag = abs(pac)>pac_thresh;
    sigID_contig = find(sum(sigID_lag)>1);
    
    fprintf('depth %d: %d/%d (%.0f%%) contigs are autocorrelated\n',depthID,length(sigID_contig),length(contigID),length(sigID_contig)/length(contigID)*100);
    save(sprintf('data_mat/pac_depth%d',depthID),'pac','pac_thresh','lag','Nlag','sigID_contig','sigID_lag','contigID','depthID','depth');
end

fprintf('partial autocorrelation analysis complete\n');