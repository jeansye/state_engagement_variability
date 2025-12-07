
%% 

% This script uses 10-fold connectome-based predictive modeling to
% identify SEV networks. 

clear;clc
rng(128)

%% Set up path

path(path,"CPM-master/matlab/func_pca/");

%% SEV networks 

% main dataset shown here as an example 
load('main_concat_connectome.mat');

[y_predict,pmask_all]=cpm_main_pca(all_connectomes(:,:,:,7),behav(:,2:5),'pthresh',0.01,'kfolds',10);

[coeff,score,latent,tsquared,explained] = pca(behav(:,2:5));
[r_model,p_model] = corr(y_predict,score(:,1))

% permutation testing 
% (codes in CPM-master/matlab/func_pca should be updated/un-commented to allow randomization
% before running this part) 

r_store = zeros(500,1);
for i = 1:500
    [y_predict,pmask_all]=cpm_main_pca(all_connectomes(:,:,:,7),behav(:,2:5),'pthresh',0.01,'kfolds',10);
    [r,p]=corr(y_predict,score(:,1));
    r_store(i,1) = r;
end

length(find(r_store>r_model))/500
