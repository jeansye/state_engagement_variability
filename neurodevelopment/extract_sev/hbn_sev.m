
clear;clc

%% set up 

load('centroid.mat');
load('cluster_labels.mat');

% standardize centroid
centroid_std = centroid;
centroid_std(:,1) = centroid_std(:,1)/std(centroid_std(:,1));
centroid_std(:,2) = centroid_std(:,2)/std(centroid_std(:,2));
centroid_std(:,3) = centroid_std(:,3)/std(centroid_std(:,3));
centroid_std(:,4) = centroid_std(:,4)/std(centroid_std(:,4));

load('sublist.mat')

all_sub_sd = zeros(length(sublist),4);

dm_resnorm = zeros(length(sublist),no_tr);

%% extract sev

for sub = 1:length(sublist)
    tmp_path = strcat('data/',string(sublist(sub)),'_task-movieDM_bis_matrix_roimean.txt');
    tmp = importdata(tmp_path);
    tmp = tmp.data;
    tmp(:,1) = []; % remove node label
    tmp(:,[249, 239, 243, 129, 266, 109, 115, 118, 250]) = []; % remove poor-resolution nodes
    timeframe_num = size(tmp,1);
    beta1 = [];
    beta2 = [];
    beta3 = [];
    beta4 = [];
    for f = 1:timeframe_num
        tmp_vol = transpose(tmp(f,:)/std(tmp(f,:)));
        [beta_all, resnorm, residual] = lsqnonneg(centroid_std,tmp_vol);
        beta1 = [beta1,beta_all(1)];
        beta2 = [beta2,beta_all(2)];
        beta3 = [beta3,beta_all(3)];
        beta4 = [beta4,beta_all(4)];
        dm_resnorm(sub,f) = resnorm;
    end
    all_sub_sd(sub,1) = std(beta1);
    all_sub_sd(sub,2) = std(beta2);
    all_sub_sd(sub,3) = std(beta3);
    all_sub_sd(sub,4) = std(beta4);
end

%% QC residuals

residual_qc = zeros(length(sublist),1);
for sub = 1:length(sublist)
    sub_vals = quantile(dm_resnorm(sub,:),[0.25,0.75]);
    sub_thresh = sub_vals(2)+1.5*(sub_vals(2)-sub_vals(1));
    above_thresh = find(dm_resnorm(sub,:) > sub_thresh);
    residual_qc(sub,1) = length(above_thresh);
end

find(residual_qc(:,1) ~= 0)
