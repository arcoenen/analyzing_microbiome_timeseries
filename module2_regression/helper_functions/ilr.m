function Z = ilr(Y)
% Isometric log ratio transform.

N = size(Y,2);

% construct Helmert matrix
helmert = tril(ones(N),-1);
helmert(logical(eye(N))) = -(0:N-1);
helmert = transpose(helmert(2:end,:));
%n = sqrt((2:N).*((2:N)+1));

Z = log(Y);
Z = Z-mean(Z,2);
Z = Z*helmert;

end
