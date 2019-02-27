Readme for autoregression and regression tutorials

Each tutorial is independent, that is, they can be run independently from the other tutorials. The tutorials are NOT self-contained. There are a few "helper" functions that are used. Before running the tutorials, go into the parent directory ("autoregression") and run "setup.mat", which adds the appropriate subdirectories to the Matlab path.

Several of the tutorials require the Matlab econometrics toolbox for computing partial autocorrelations and arima models.

The second autoregression tutorial (autoregression_tutorial2.mat) uses SparCC, a Python package developed by Friedman and Alm. SparCC is available at:
https://bitbucket.org/yonatanf/sparcc

To run the cell that does SparCC calculations, Matlab must know where Python is installed on your machine. The "setup.mat" script attempts to take care of this, but if it doesn't work, see:
https://www.mathworks.com/help/matlab/matlab_external/undefined-variable-py-or-function-py-command.html.

Tutorials were developed in Matlab R2018b and may not be compatible with older versions.