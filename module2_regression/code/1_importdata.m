

%% READ RAW DATA

clear;
file_str = 'merged.relativeabundances.129alohaviralcontigs.txt';
fid = fopen(sprintf('data/%s',file_str));

% read cast strings in first line of file
cast_str = fgetl(fid);
cast_str = strsplit(cast_str);
keepID = strncmp(cast_str,'HOT',3); % only keep cells that start with 'HOT'
cast_str = string(cast_str(keepID))';
Ncasts = length(cast_str);

% read the rest of the file
formatspec = ['%s' repmat('%f',1,Ncasts)];
C = textscan(fid,formatspec);
contig_str = string(C{1});
data_mat = cell2mat(C(2:end));

clear keepID formatspec fid C Ncasts
save('data/aloha_raw','cast_str','contig_str','data_mat');



%% DATA CLEANING

clear;
load('data/aloha_raw');

% split cast strings
tmp = regexp(cast_str,'_','split');
cast_cruise = zeros(length(cast_str),1);
cast_sequencerun = string(zeros(length(cast_str),1));
cast_depth = zeros(length(cast_str),1);
for i = 1:length(tmp)
    cast_cruise(i) = str2double(tmp{i}{1}(4:end)); % omit 'HOT'
    cast_sequencerun(i) = tmp{i}(2);
    cast_depth(i) = str2double(tmp{i}{3}(1:end-1)); % omit 'm'
end
clear tmp i;

% unique cruises and depths
ucruise = unique(cast_cruise);
udepth = unique(cast_depth);
Ncruise = length(ucruise);
Ndepth = length(udepth);
Ncontig = length(contig_str);

% how many replicates (sequence runs) per cruise and per depth?
Nreplicates = zeros(Ncruise,Ndepth);
for i = 1:Ncruise
    for j = 1:Ndepth
        Nreplicates(i,j) = sum(cast_cruise==ucruise(i) & cast_depth==udepth(j));
    end
end
replicates_table = array2table(Nreplicates,'VariableNames',strcat('depth',string(udepth),'m'),'RowNames',strcat('cruise',string(ucruise)));
clear i j tmp
disp('number of replicate metaviromes:');
disp(replicates_table)
save('data/aloha_replicates','replicates_table');

% depth 45m does not have enough time points, so omit it
omitID = cast_depth==45;
cast_str = cast_str(~omitID);
cast_cruise = cast_cruise(~omitID);
cast_depth = cast_depth(~omitID);
cast_sequencerun = cast_sequencerun(~omitID);
data_mat = data_mat(:,~omitID);
udepth = unique(cast_depth);
Ndepth = length(udepth);
clear omitID
Nreplicates = Nreplicates(:,[1 3:end]);
disp('depth 45m removed from data');

save('data/aloha_clean','cast_cruise','cast_depth','cast_sequencerun','data_mat','Ncontig','Ndepth','Ncruise','Nreplicates','ucruise','udepth');



%% DATA AVERAGING AND RESHAPING

clear;
load('data/aloha_clean');
show_figs = 1;

% visualization - are viral contig values similar across replicates?
if show_figs==1; figure_replicates; end

% reshape into 3D matrix
% if there are replicates, average across them
% if there is no sample, taking mean([]) results in NaN
data_mat3 = zeros(Ncontig,Ncruise,Ndepth);
for i = 1:Ncruise
    for j = 1:Ndepth
        tmpID = cast_cruise==ucruise(i) & cast_depth==udepth(j);
        data_mat3(:,i,j) = mean(data_mat(:,tmpID),2);
    end
end
clear i j tmpID;

% rename some variables
X = data_mat3;
cruise = ucruise;
depth = udepth;

% show timeseries
if show_figs==1; figure_timeseries_all; end

save('data/aloha_averaged','X','Ncontig','Ncruise','Ndepth','cruise','depth');


