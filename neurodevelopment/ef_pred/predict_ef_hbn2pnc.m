% codes written in MATLAB R2021a

clear; clc

%% set up 

hbn_data = importdata('hbn_sd_behav.csv');
pnc_data = importdata('pnc_sd_behav.csv');

%% train in hbn; test in pnc

% pca on ef measures
[ef_coeff, ef_score, ef_latent, ef_tsquared, ef_explained] = pca(hbn_data.data(:,2:5));

exclude_idx = find(isnan(ef_score(:,1))); % remove sub with missing data
ef_score(exclude_idx,:) = [];
hbn_data.data(exclude_idx,:) = [];

% train in hbn
hbn_sev = hbn_data.data(:,6:9);
[b,stats] = robustfit(hbn_sev,ef_score(:,1));

% test in pnc
pred_ef = zeros(size(pnc_data.data,1),1);
pnc_sev = pnc_data.data(:,5:8);
for sub = 1:size(pnc_data.data,1)
    sub_ef = b(1) + b(2) * pnc_sev(sub,1) + b(3) * pnc_sev(sub,2) + b(4) * pnc_sev(sub,3) + b(5) * pnc_sev(sub,4);
    pred_ef(sub,1) = sub_ef;
end

% prediction accuracy
[r,p] = corr(pred_ef(:,1),pnc_data.data(:,2)) 
