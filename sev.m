function [sev_vals, eng_vals, sub_resnorm_above] = sev(ts,brain_states)

% This function takes in a timeseries matrix (dimension: number of ROIs x
% number of TRs) and a set of brain states (dimension: number of ROIs x
% number of brain states) to compute the engagement of each individual
% brain states over time. There are three output variables: sev_vals
% indicates the state engagement variability of each brain state, eng_vals
% describes the relative engagement of each brain state, and
% sub_resnorm_above indicates the number of TRs with an outlier residual. 

% written by Jean Ye (in MATLAB R2021a)

no_tr = size(ts,2);
no_bs = size(brain_states,2);

bs_engagement = zeros(no_tr,no_bs);
sev_vals = [];
eng_vals = [];
sub_resnorm = [];

% standardize brain states 
bs_s = brain_states;
for num = 1:no_bs
    bs_s(:,num) = bs_s(:,num)/std(bs_s(:,num));
end

% extract state engagement
for tr = 1:no_tr 
    tmp_tr = ts(:,tr)/std(ts(:,tr)); % standardize tr
    [beta_all, resnorm, residual] = lsqnonneg(bs_s,tmp_tr);
    bs_engagement(tr,:) = beta_all';
    sub_resnorm = [sub_resnorm, resnorm];
end

% compute state engagement variability 
for bs_num = 1:no_bs
    sev_vals = [sev_vals,std(bs_engagement(:,bs_num))];
end

% compute relative engagement 
all_sum = sum(bs_engagement);
all_sum = sum(all_sum,2); 
for bs_num = 1:no_bs
    eng_vals = [eng_vals,sum(bs_engagement(:,bs_num))/all_sum];
end

% check errors
resnorm_vec = quantile(sub_resnorm,[0.25,0.75]);
sub_thresh = resnorm_vec(2)+1.5*(resnorm_vec(2)-resnorm_vec(1));
resnorm_above = find(sub_resnorm > sub_thresh);
sub_resnorm_above = length(resnorm_above);



