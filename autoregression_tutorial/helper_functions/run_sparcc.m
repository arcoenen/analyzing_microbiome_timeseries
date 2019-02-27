function [rho] = run_sparcc(X)
% Run the Python script SparCC and return correlation matrix.

% change to sparcc directory to run python scripts
dir_sparcc = 'sparcc';
cd(dir_sparcc);

% run sparcc
s = py.SparCC.main(X,pyargs('method','sparcc','iter',int8(1)));
rho = double(s{1});

% change back to root directory
cd('..');

end
    