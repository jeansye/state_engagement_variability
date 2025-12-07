function [y_predict,fam_indices,mean_mdl_sz] =cpm_cv_family(x,y,pthresh,kfolds,family,seed)
% Runs cross validation for CPM
% x            Predictor variable
% y            Outcome variable
% pthresh      p-value threshold for feature selection
% kfolds       Number of partitions for dividing the sample
% family       Vector indicating what family each subject belongs to
% seed         Sets seed to keep cv indices the same
% y_test       y data used for testing
% y_predict    Predictions of y data used for testing

% Split data
% cross-validation indices
rng(seed)
nsubs=size(x,2);
nfams = length(unique(family));
[~,fam_rank] = ismember(family,unique(family)); % adjust family numbers to range from 1 to max number of current families
fold_size = floor(nfams/kfolds);
all_ind = [];
for idx=1:kfolds
    all_ind=[all_ind; idx*ones(fold_size,1)];
end
leftover=mod(nfams,kfolds);
fam_indices=[all_ind; randperm(kfolds,leftover)'];
fam_indices=fam_indices(randperm(length(fam_indices)));

y_predict = zeros(nsubs, 1);
pmask_pos = zeros(size(x,1),kfolds);
pmask_neg = pmask_pos;
pos_mdl_sz = zeros(1,kfolds);
neg_mdl_sz = pos_mdl_sz;
% Run CPM over all folds
fprintf('\n# Running over %1.0f Folds.\nPerforming fold no. ',kfolds);
for leftout = 1:kfolds
    fprintf('%1.0f ',leftout);
    fam_testinds = find(fam_indices==leftout);
    fam_traininds = find(fam_indices~=leftout);
    testinds = ismember(fam_rank,fam_testinds);
    traininds = ismember(fam_rank,fam_traininds);
    
    
    % Assign x and y data to train and test groups
    x_train = x(:,traininds);
    y_train = y(traininds);
    x_test = x(:,testinds);
    
    % Train Connectome-based Predictive Model
    [~, ~, pmask, mdl] = cpm_train(x_train, y_train,pthresh);
    
    % Test Connectome-based Predictive Model
%     [y_predict(testinds)] = cpm_test(x_test,mdl,pmask);
%     
%     pmask_pos(:,leftout) = pmask==1;
%     pmask_neg(:,leftout) = pmask==-1;
    
    pos_mdl_sz(leftout) = sum(pmask==1);
    neg_mdl_sz(leftout) = sum(pmask==-1);
end
% mean pmask across folds
pmask_pos = sum(pmask_pos,2);
pmask_neg = sum(pmask_neg,2);
% mean model size
mean_mdl_sz = mean(pos_mdl_sz+neg_mdl_sz);