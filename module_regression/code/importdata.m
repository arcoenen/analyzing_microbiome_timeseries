% custom script to import ALOHA 1.0 data into matlab

%% READ RAW DATA

clear;
file_str = 'merged.relativeabundances.129alohaviralcontigs.txt';
fid = fopen(sprintf('data_raw/%s',file_str));

% read cast strings in first line of file
tmpN = 101; % number of casts
formatspec = ['%*s' repmat('%s',[1 tmpN])];
tmp = textscan(fid,formatspec,1);
cast.str = string(tmp');

% split cast strings
tmp = regexp(cast.str,'_','split');
cast.cruise = zeros(length(cast.str),1);
cast.sequencerun = string(zeros(length(cast.str),1));
cast.depth = zeros(length(cast.str),1);
for i = 1:length(tmp)
    cast.cruise(i) = str2double(tmp{i}{1}(4:end)); % omit 'HOT'
    cast.depth(i) = str2double(tmp{i}{3}(1:end-1)); % omit 'm'
    cast.sequencerun(i) = tmp{i}(2);
end

% read the rest of the file
formatspec = ['%s' repmat('%f',[1 tmpN])];
tmp = textscan(fid,formatspec);
contig_str = string(tmp{1});
data_mat = cell2mat(tmp(2:end));

% save
clear tmp* i fid formatspec file_str;
save('data_mat/aloha_raw');
fprintf('raw data imported\n');


%% READ METADATA FILE (for cast times)

clear;
file_str = 'Suppl_Table_2_HOT_2010_11_metadata_4.xlsx';

% cruise
[~,tmptxt] = xlsread(file_str,'D3:D85');
cast_cruise_meta = zeros(length(tmptxt),1);
for i = 1:length(tmptxt)
    cast_cruise_meta(i) = str2double(tmptxt{i}(4:end));
end

% depth
[cast_depth_meta,~] = xlsread(file_str,'F3:F85');

% datetime
% datetimes are read as integers in the form MMDDYYHHmmSS
[tmpnum,~] = xlsread(file_str,'I3:J85');
tmpM = floor(tmpnum(:,1)/10000); 
tmpD = floor((tmpnum(:,1)-tmpM*10000)/100);
tmpY = 2000+tmpnum(:,1)-tmpM*10000-tmpD*100;
tmpH = floor(tmpnum(:,2)/10000);
tmpMI = floor((tmpnum(:,2)-tmpH*10000)/100);
tmpS = tmpnum(:,2)-tmpH*10000-tmpMI*100;
cast_date_meta = datetime(tmpY,tmpM,tmpD,tmpH,tmpMI,tmpS);

% link datetimes to casts for the raw data
load('data_mat/aloha_raw');
for i = 1:length(cast.str)
    cast.date(i) = cast_date_meta(cast.cruise(i)==cast_cruise_meta & cast.depth(i)==cast_depth_meta);
end
cast.date = cast.date';

% save to raw data file
clear tmp* i file_str;
save('data_mat/aloha_raw','cast','-append');
fprintf('cast times added to raw data file\n');


%% DATA CLEANING

clear;
load('data_mat/aloha_raw');

% unique cruises and depths
ucruise = unique(cast.cruise);
udepth = unique(cast.depth);
Ncruise = length(ucruise);
Ndepth = length(udepth);
Ncontig = length(contig_str);

% how many replicates (sequence runs) per cruise and per depth?
Nreplicates = zeros(Ncruise,Ndepth);
for i = 1:Ncruise
    for j = 1:Ndepth
        Nreplicates(i,j) = sum(cast.cruise==ucruise(i) & cast.depth==udepth(j));
    end
end
replicates_table = array2table(Nreplicates,'VariableNames',strcat('depth',string(udepth),'m'),'RowNames',strcat('cruise',string(ucruise)));
fprintf('number of replicate metaviromes:\n');
disp(replicates_table)
save('data_mat/aloha_replicates','replicates_table');
clear Nreplicates replicates_table;

% depth 45m does not have enough time points, so omit it
omitID = cast.depth==45;
tmpf = fieldnames(cast);
for i = 1:length(tmpf)
    cast.(tmpf{i}) = cast.(tmpf{i})(~omitID);
end
data_mat = data_mat(:,~omitID);
udepth = unique(cast.depth);
Ndepth = length(udepth);
fprintf('depth 45m removed from data\n');
clear omitID;

% reshape into 3D matrix
% if there are replicates, average across them
% if there is no sample, taking mean([]) results in NaN
data_mat3 = zeros(Ncontig,Ncruise,Ndepth);
for i = 1:Ncruise
    for j = 1:Ndepth
        tmpID = cast.cruise==ucruise(i) & cast.depth==udepth(j);
        data_mat3(:,i,j) = mean(data_mat(:,tmpID),2);
    end
end
fprintf('replicates averaged\n');

% average the cast times across each cruise
for i = 1:length(ucruise)
   tmpID = cast.cruise==ucruise(i);
   ucruise_date(i) = mean(cast.date(tmpID));
end
fprintf('cast times averaged\n');

% rename variables
X = data_mat3;
cruise = ucruise;
t = ucruise_date';
depth = udepth;
clear data_mat cast data_mat3 ucruise ucruise_date udepth;

% save
clear i j tmp*;
save('data_mat/aloha_clean');
fprintf('data cleaning complete\n');

