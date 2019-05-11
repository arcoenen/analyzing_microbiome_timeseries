
% INTERPOLATE MISSING SAMPLES

tmpdir = dir('data_mat/ts*');
for k = 1:length(tmpdir)
    load(sprintf('data_mat/%s',tmpdir(k).name));
    nanID = all(isnan(X0));
    X0 = transpose(interp1(t(~nanID),X0(:,~nanID)',t));
    save(sprintf('data_mat/ts_depth%d',depthID),'X0','t','depthID','contigID','depth','nanID');
end

fprintf('missing values interpolated\n');