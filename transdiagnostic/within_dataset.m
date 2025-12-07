%%

% This script looks at the correlation between state engagement variability
% (SEV) and cognitive control within dataset. 

clear;clc

%% Main dataset

load('main_concat');
main_behav = behav;
main_labels = behav_labels;

pidx = find(main_behav(:,1)==1); 
hidx = find(main_behav(:,1)==0); 

% shift
[coeff,score,latent,tsquared,explained] = pca(main_behav(:,2:5));
[r,p] = corr(score(:,1),main_behav(:,43))

% inhibition
[coeff,score,latent,tsquared,exzplained] = pca(main_behav(pidx,2:5));
[r,p] = corr(score(:,1),main_behav(pidx,115),'row','complete')

%% Inhibition validation dataset 

load('cnp_stroop_concat.mat');
cnp_behav = behav;
cnp_labels = labels;
pidx = 110:225;

[coeff,score,latent,tsquared,explained] = pca(all_rest_sd);
[r,p] = corr(score(pidx,1),behav(pidx,4),'rows','complete')

%% Shift validation dataset

df = importdata('tcp_rrs_merged.csv');
tcp_behav = df.data;
tcp_labels = df.textdata(1,:);
tcp_labels(1) = [];

[coeff,score,latent,tsquared,explained] = pca(tcp_behav(:,2:5));
[r,p] = corr(score(:,1),tcp_behav(:,6))

