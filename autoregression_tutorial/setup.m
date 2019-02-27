
clear;

dir_root = 'autoregression';
dir_current = regexp(pwd,'/','split');
dir_current = dir_current{end};

% MATLAB PATH
fprintf('Setting up Matlab path... ');
try
    if ~strcmp(dir_current,dir_root)
        cd(dir_root)
    end
    addpath(genpath('..'));
    fprintf('success!\n\n');
catch
    fprintf('WARNING: path was not set\n\n');
end

% PYTHON
fprintf('Setting up Python...\n');
[v,e,loaded] = pyversion;
fprintf('Python path: %s\n',e);
s = input('Is this the correct location of Python? You can check by running\n$ which python\nin the terminal. Type (Y/N): ','s');
if ~strcmp(s,'Y')
    if ~loaded
        tmpexe = input("Enter the output of 'which python': ",'s');
        pyversion(tmpexe);
        fprintf('Python path set!\n');
    else
        fprintf('Python is already loaded. To change the Python path, restart Matlab and run this script again.\n');
    end
end

% SPARCC
fprintf('\nAttempting test run of SparCC...\n');
run_sparcc(rand(10));
fprintf('success!\n\n');

clear;
fprintf('Setup complete.\n');