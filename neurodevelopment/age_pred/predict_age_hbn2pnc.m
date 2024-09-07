
clear; clc

%% train in hbn

hbn_data = importdata('hbn_sd_behav.csv');

[b,stats] = robustfit(hbn_data.data(:,6:9),hbn_data.data(:,1));


%% test in pnc

pnc_data = importdata('pnc_sd_behav.csv');

pred_age = zeros(size(pnc_data.data,1),1);
for sub = 1:size(pnc_data.data,1)
    sub_age = b(1) + b(2) * pnc_data.data(sub,5) + b(3) * pnc_data.data(sub,6) + b(4) * pnc_data.data(sub,7) + b(5) * pnc_data.data(sub,8);
    pred_age(sub,1) = sub_age;
end

% age prediction accuracy
[r,p] = corr(pred_age,pnc_data.data(:,9))

% deviation 
age_diff = pred_age - pnc_data.data(:,9);
age_diff = age_diff.^2;

% deviation with executive function
[r,p] = partialcorr(age_diff,pnc_data.data(:,2),pnc_data.data(:,9)) 
