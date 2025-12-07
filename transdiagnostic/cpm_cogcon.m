%% 

% This script uses 10-fold connectome-based predictive modeling to
% identify cognitive-control-predictive networks. 

clear;clc
rng(128)

%% Set up path & load in data

path(path,"CPM-master/matlab/func/");

load('r01_concat_connectome.mat');

%% Identify CPM networks - Inhibition 

excl = find(isnan(behav(:,115)));
behav(excl,:) = [];
all_connectomes(:,:,excl,:) = [];

[y_predict,pmask_all]=cpm_main(all_connectomes(:,:,:,7),behav(:,115),'pthresh',0.01,'kfolds',10);
[r_model,p_model] = corr(y_predict,behav(:,115))

% permutation testing 
% (codes in CPM-master/matlab/func should be updated/un-commented to allow randomization
% before running this part) 

r_store = zeros(500,1);
for i = 1:500
    [y_predict,pmask_all]=cpm_main(all_connectomes(:,:,:,7),behav(:,115),'pthresh',0.01,'kfolds',10);
    [r,p]=corr(y_predict,behav(:,115));
    r_store(i,1) = r;
end
 
length(find(r_store>r_model))/500

%% Identify CPM networks - Shift 

[y_predict,pmask_all]=cpm_main(all_connectomes(:,:,:,7),behav(:,43),'pthresh',0.01,'kfolds',10);
[r_model,p_model] = corr(y_predict,behav(:,43))

% permutation testing 
% (codes in CPM-master/matlab/func should be updated/un-commented to allow randomization
% before running this part) 

r_store = zeros(500,1);
for i = 1:500
    [y_predict,pmask_all]=cpm_main(all_connectomes(:,:,:,7),behav(:,43),'pthresh',0.01,'kfolds',10);
    [r,p]=corr(y_predict,behav(:,43));
    r_store(i,1) = r;
end
 
length(find(r_store>r_model))/500

