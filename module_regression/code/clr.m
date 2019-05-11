function Z = clr(X)
% centered log-ratio transform
% dimension 1 = variables
% dimension 2 = time/samples

% check that orientation is correct
thresh = 1e-5;
check_sum = sum(X,'omitnan');
check_sum_1 = check_sum>(1-thresh) & check_sum<(1+thresh);
check_sum_0 = check_sum==0; % if all nans
if ~all(check_sum_1 | check_sum_0)
    disp('WARNING: X may not be in correct orientation');
end

% check that all entries are non-zero
if any(X(:)==0)
    disp('WARNING: some entries in X are zero');
end

% number of variables
D = size(X,1);

% method 1
%G = prod(X,'omitnan').^(1/D);
%G = repmat(G,[D 1]);
%Z = log(X./G);

% method 2
C = eye(D)*D - 1;
Z = transpose(log(X')/D * C);


end
