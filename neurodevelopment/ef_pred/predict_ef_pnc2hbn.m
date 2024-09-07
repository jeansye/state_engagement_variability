% codes written in MATLAB R2021a

clear; clc

%% set up 

hbn_data = importdata('hbn_sd_behav.csv');
pnc_data = importdata('pnc_sd_behav.csv');

%% train in PNC; test in HBN

% train in pnc
pnc_sev = pnc_data.data(:,5:8);
pnc_ef = pnc_data.data(:,2);
[b,stats] = robustfit(pnc_sev,pnc_ef);

% test in hbn
pred_ef = zeros(size(hbn_data.data,1),1);
hbn_sev = hbn_data.data(:,6:9);
for sub = 1:size(hbn_data.data,1)
    sub_ef = b(1) + b(2) * hbn_sev(sub,1) + b(3) * hbn_sev(sub,2) + b(4) * hbn_sev(sub,3) + b(5) * hbn_sev(sub,4);
    pred_ef(sub,1) = sub_ef;
end

% prediction accuracy
[ef_coeff, ef_score, ef_latent, ef_tsquared, ef_explained] = pca(hbn_data.data(:,2:5));
[r,p] = corr(ef_score(:,1),pred_ef(:,1),'rows','complete') 


