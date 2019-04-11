
% this script is run at the start of every analysis script
% it grabs a subset of data from the original data matrix


% edit these to choose different depth or present fraction
depthID = 1; % depth index
present_fraction = 0.8; % present fraction

% grab contigs that satisfy present_fraction at chosen depth
load('data/aloha_averaged');
if present_fraction==1
    contigID = find(sum(X(:,:,depthID)>0,2)/Ncruise==present_fraction);
else
    contigID = find(sum(X(:,:,depthID)>0,2)/Ncruise>present_fraction);
end
X0 = X(contigID,:,depthID);
N0contig = size(X0,1);