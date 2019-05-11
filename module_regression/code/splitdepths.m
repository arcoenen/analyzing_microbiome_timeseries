
% split timeseries into separate file for each depth and omit contigs which
% are not present for any samples

clear;
load('data_mat/aloha_clean_uniform');

present_num = 0; % must be present for at least this many timepoints

for depthID = 1:Ndepth
    contigID = find(sum(X(:,:,depthID)>0,2)>present_num); 
    X0 = X(contigID,:,depthID);
    save(sprintf('data_mat/ts_depth%d',depthID),'X0','t','depthID','contigID','depth');
end

fprintf('depths split into separate mat files\n');