
%% PART 1 - DATA IMPORT & CLEANING

% import data
importdata;
figure_casttimes;
figure_replicates;

% adjust sample times so that they are uniform
uniformsampling;
figure_uniformsampling;
figure_uniformsampling_error;

% split into separate datasets by depth and omit contigs that are absent
splitdepths;
interpolatenans; % interpolate for missing values (use caution!)
figure_timeseries;
figure_timeseries_summary;


%% PART 2 - PARTIAL AUTOCORRELATION & AUTOREGRESSION

% partial autocorrelation
partialautocorrelation;
figure_partialautocorrelation;
figure_partialautocorrelation_summary;

% autoregression
autoregression;
figure_autoregression;
figure_autoregression_summary;


%% PART 3 - REGRESSION

regression;
figure_regression;