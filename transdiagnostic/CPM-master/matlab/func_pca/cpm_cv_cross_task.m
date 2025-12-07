function [y_predict]=cpm_cv_cross_task(x1,x2,y,pthresh,kfolds)
% Runs cross validation for CPM
% x            Predictor variable
% y            Outcome variable
% pthresh      p-value threshold for feature selection
% kfolds       Number of partitions for dividing the sample
% y_test       y data used for testing
% y_predict    Predictions of y data used for testing

% Split data
% cross-validation indices
nsubs=size(x1,2);
all_ind=[];
fold_size=floor(nsubs/kfolds);
for idx=1:kfolds
    all_ind=[all_ind; idx*ones(fold_size, 1)];
end
leftover=mod(nsubs, kfolds);
indices=[all_ind; randperm(kfolds, leftover)'];
indices=indices(randperm(length(indices)));

y_predict = zeros(nsubs, size(x2,3));
% Run CPM over all folds
fprintf('\n# Running over %1.0f Folds.\nPerforming fold no. ',kfolds);
for leftout = 1:kfolds
    fprintf('%1.0f ',leftout);
    testinds=(indices==leftout);
    traininds=(indices~=leftout);
    
    
    % Assign x and y data to train and test groups
    x_train = x1(:,traininds);
    y_train = y(traininds);
    
    % Train Connectome-based Predictive Model
    [~, ~, pmask, mdl] = cpm_train(x_train, y_train,pthresh);
    
    % Test Connectome-based Predictive Model
    for task_ind = 1:size(x2,3)
        x_test = x2(:,testinds,task_ind);
        [y_predict(testinds,task_ind)] = cpm_test(x_test,mdl,pmask);
    end
    
end