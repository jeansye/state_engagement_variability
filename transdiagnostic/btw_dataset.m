%%

% This script tests whether state engagement variability (SEV) can predict
% individual differences in cognitive control in previously unseen individuals. 

clear;clc

%% load data

load('main_concat.mat');
main_behav = behav;
main_labels = behav_labels;

df = importdata('tcp_rrs_merged.csv');
tcp_behav = df.data;
tcp_labels = df.textdata(1,:);
tcp_labels(1) = [];

load('cnp_stroop_concat.mat');
cnp_behav = behav;
cnp_labels = labels;

%% INHIBITION: main to inhibition validation 

exl_idx = find(isnan(main_behav(:,115)));
main_behav(exl_idx,:) = [];
pidx = find(main_behav(:,1)==1);

b = robustfit(main_behav(pidx,2:5),main_behav(pidx,115));

pred_val = zeros(size(all_rest_sd,1),1);
for sub = 1:size(all_rest_sd,1)
    pred_val(sub,1) = b(1)+b(2)*all_rest_sd(sub,1)+b(3)*all_rest_sd(sub,2)+b(4)*all_rest_sd(sub,3)+b(5)*all_rest_sd(sub,4);
end

[r,p] = corr(pred_val(110:225,1),cnp_behav(110:225,4),'rows','complete')

%% INHIBITION: inhibition validation to main 

b = robustfit(all_rest_sd(110:225,:),cnp_behav(110:225,4));

pred_val = zeros(size(main_behav,1),1);
for sub = 1:size(main_behav,1)
    pred_val(sub,1) = b(1)+b(2)*main_behav(sub,2)+b(3)*main_behav(sub,3)+b(4)*main_behav(sub,4)+b(5)*main_behav(sub,5);
end

pidx = find(main_behav(:,1)==1);
[r,p] = corr(pred_val(pidx,1),r01_behav(pidx,115),'rows','complete')

%% SHIFT: main to shift validation

b = robustfit(main_behav(:,2:5),main_behav(:,43));

pred_val = zeros(size(tcp_behav,1),1);
for sub = 1:size(tcp_behav,1)
    pred_val(sub,1) = b(1)+b(2)*tcp_behav(sub,2)+b(3)*tcp_behav(sub,3)+b(4)*tcp_behav(sub,4)+b(5)*tcp_behav(sub,5);
end

[r,p] = corr(pred_val(:,1),tcp_behav(:,6),'rows','complete')

%% SHIFT: shift validation to main

b = robustfit(tcp_behav(:,2:5),tcp_behav(:,6));

pred_val = zeros(size(main_behav,1),1);
for sub = 1:size(main_behav,1)
    pred_val(sub,1) = b(1)+b(2)*main_behav(sub,2)+b(3)*main_behav(sub,3)+b(4)*main_behav(sub,4)+b(5)*main_behav(sub,5);
end

[r,p] = corr(pred_val(:,1),main_behav(:,43),'rows','complete')
