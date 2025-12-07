function [y_predict,mdl]=cpm_cv_cross_dataset(x1,x2,y1,pthresh)
% Runs cross validation for CPM
% x            Predictor variable
% y            Outcome variable
% pthresh      p-value threshold for feature selection
% kfolds       Number of partitions for dividing the sample
% y_test       y data used for testing
% y_predict    Predictions of y data used for testing

% Run CPM 
[~,~,pmask,mdl] = cpm_train(x1,y1,pthresh);
[y_predict] = cpm_test(x2,mdl,pmask);
