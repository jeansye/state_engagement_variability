%%

% This script examines the temporal alignment of cognitive control and
% state engagement variability (SEV) network dynamics.

clear;clc
 
%% Extract edge indices for each CPM network

% load in one of the cognitive control networks
load('inhibition_cpm_networks.mat');
load('shift_cpm_networks.mat');

pos = triu(pos_mask_all,1);
neg = triu(neg_mask_all,1);

[neg_r,neg_c] = find(neg==1);
neg_idx1 = [neg_r neg_c];

[pos_r,pos_c] = find(pos==1);
pos_idx1 = [pos_r pos_c];

clear pos_mask_all
clear neg_mask_all

% load in the SEV networks
load('sev_cpm_networks.mat');
pos = triu(pos_mask_all,1);
neg = triu(neg_mask_all,1);

[neg_r,neg_c] = find(neg==1);
neg_idx2 = [neg_r neg_c];

[pos_r,pos_c] = find(pos==1);
pos_idx2 = [pos_r pos_c];

%% Apply edge timeseries to each CPM network 

% load in functional connectomes from each dataset (main dataset shown here
% as an example)
load('all_ts.mat');

no_sub = length(df_sublist);
no_tr = size(all_ts,1);

network1_ts = zeros(no_sub,no_tr);
network2_ts = zeros(no_sub,no_tr);

for sub = 1:no_sub
    tmp_scan = all_ts(:,:,sub,1); % extract the resting-state scan
    % positive network 1
    all_edges = zeros(size(pos_idx1,1),size(tmp_scan,1));
    for p = 1:size(pos_idx1,1)
        node1 = zscore(tmp_scan(:,pos_idx1(p,1)));
        node2 = zscore(tmp_scan(:,pos_idx1(p,2)));
        all_edges(p,:) = transpose(node1.*node2);
    end
    pos_all = sum(all_edges);
    % negative network 1
    all_edges = zeros(size(neg_idx1,1),size(tmp_scan,1));
    for p = 1:size(neg_idx1,1)
        node1 = zscore(tmp_scan(:,neg_idx1(p,1)));
        node2 = zscore(tmp_scan(:,neg_idx1(p,2)));
        all_edges(p,:) = transpose(node1.*node2);
    end
    neg_all = sum(all_edges);
    network1_ts(sub,:) = pos_all - neg_all;
    % positive network 2
    all_edges = zeros(size(pos_idx2,1),size(tmp_scan,1));
    for p = 1:size(pos_idx2,1)
        node1 = zscore(tmp_scan(:,pos_idx2(p,1)));
        node2 = zscore(tmp_scan(:,pos_idx2(p,2)));
        all_edges(p,:) = transpose(node1.*node2);
    end
    pos_all = sum(all_edges);
    % negative network 2
    all_edges = zeros(size(neg_idx2,1),size(tmp_scan,1));
    for p = 1:size(neg_idx2,1)
        node1 = zscore(tmp_scan(:,neg_idx2(p,1)));
        node2 = zscore(tmp_scan(:,neg_idx2(p,2)));
        all_edges(p,:) = transpose(node1.*node2);
    end
    neg_all = sum(all_edges);
    network2_ts(sub,:) = pos_all - neg_all;
end

%% Compute temporal alignment between SEV and cognitive control networks

rs_store = zeros(no_sub,2);

for sub = 1:no_sub
    tmp1 = network1_ts(sub,:)';
    tmp2 = network2_ts(sub,:)';
    [r,p] = corr(tmp1,tmp2);
    rs_store(sub,1) = r;
    rs_store(sub,2) = p;
end

rs_store(:,1) = atanh(rs_store(:,1));

[t,p,~,stats] = ttest(rs_store(:,1))

%% Group comparison analysis 

pidx = find(df_data(:,1)==1);
hidx = find(df_data(:,1)==0);

[t,p,~,stats] = ttest2(rs_store(pidx,1),rs_store(hidx,1))
