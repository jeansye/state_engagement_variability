
clear;clc

%% set up

load('sublist.mat')

load('centroid.mat');
load('cluster_labels.mat');

% standardize centroid
centroid_std = centroid;
centroid_std(:,1) = centroid_std(:,1)/std(centroid_std(:,1));
centroid_std(:,2) = centroid_std(:,2)/std(centroid_std(:,2));
centroid_std(:,3) = centroid_std(:,3)/std(centroid_std(:,3));
centroid_std(:,4) = centroid_std(:,4)/std(centroid_std(:,4));

all_sub_sd = zeros(length(sublist),4);
all_sub_scrub_num = zeros(length(sublist),1);

pnc_resnorm = zeros(length(sublist),no_tr);

%% extract sev

for sub = 1:length(sublist)
    tmp_path = strcat('data/',sublist(sub),'_rest_bis_matrix_1_roimean.txt');
    tmp = importdata(tmp_path);
    tmp(:,1) = []; % remove node label
    tmp(:,[249, 239, 243, 129, 266, 109, 115, 118, 250]) = []; % remove poor-resolution nodes
    tmp(1,:) = []; % remove first tr 
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
        pnc_resnorm(sub,f) = resnorm;
    end
    tmp2_path = strcat('motion/REALIGN_A',sublist(sub),'*.mat');
    tmp2_name = dir(tmp2_path).name;
    tmp2_full_path = strcat('motion/',tmp2_name);
    tmp2 = load(tmp2_full_path);
    tmp2 = tmp2.mag_ser;
    assert(size(tmp,1)==size(tmp2,1));
    scrub = find(tmp2 > 0.45);
    all_sub_scrub_num(sub,1) = size(scrub,1);
    beta1(scrub) = [];
    beta2(scrub) = [];
    beta3(scrub) = [];
    beta4(scrub) = [];
    all_sub_sd(sub,1) = std(beta1);
    all_sub_sd(sub,2) = std(beta2);
    all_sub_sd(sub,3) = std(beta3);
    all_sub_sd(sub,4) = std(beta4);
end

%% QC 

% check motion

scrub_thresh = no_tr * .2;

subs_to_remove = find(all_sub_scrub_num > scrub_thresh); 

sublist(subs_to_remove) = [];
all_sub_sd(subs_to_remove,:) = [];
pnc_resnorm(subs_to_remove,:) = [];

% check residuals

pnc_residual_qc = zeros(length(sublist),1);

for sub = 1:length(sublist)
    sub_vals = quantile(pnc_resnorm(sub,:),[0.25,0.75]);
    sub_thresh = sub_vals(2)+1.5*(sub_vals(2)-sub_vals(1));
    above_thresh = find(pnc_resnorm(sub,:) > sub_thresh);
    pnc_residual_qc(sub,1) = length(above_thresh);
end

sub_exclude = find(pnc_residual_qc~=0); 

sublist(sub_exclude) = [];
all_sub_sd(subs_exclude) = [];
