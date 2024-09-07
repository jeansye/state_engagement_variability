
clear; clc

%% train in pnc

pnc_data = importdata('pnc_sd_behav.csv');

[b,stats] = robustfit(pnc_data.data(:,5:8),pnc_data.data(:,9));


%% test in hbn

hbn_data = importdata('hbn_sd_behav.csv');

pred_age = zeros(size(hbn_data.data,1),1);
for sub = 1:size(hbn_data.data,1)
    sub_age = b(1) + b(2) * hbn_data.data(sub,6) + b(3) * hbn_data.data(sub,7) + b(4) * hbn_data.data(sub,8) + b(5) * hbn_data.data(sub,9);
    pred_age(sub,1) = sub_age;
end

% age prediction accuracy
[r,p] = corr(pred_age,hbn_data.data(:,1))

% age deviation
age_diff = pred_age - hbn_data.data(:,1);
age_diff = age_diff.^2;

% deviation and exeuctive function 
[row,col] = find(isnan(hbn_data.data(:,2:5))); % remove participants with missing behavioral data
ind = unique(row);
hbn_data.data(ind,:) =[];
age_diff(ind,:) =[];

[ef_coeff, ef_score, ef_latent, ef_tsquared, ef_explained] = pca(hbn_data.data(:,2:5));

[r,p] = partialcorr(age_diff,ef_score(:,1),hbn_data.data(:,1))
