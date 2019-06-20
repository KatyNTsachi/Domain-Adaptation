% mX     = randn(10, 1000);
% vClass = randi(4, 1, 1000);
% 
% linaerSvmTemplate = templateSVM('Standardize', false);
% 
% % mdlLinearSVM      = fitcecoc(mX', vClass, 'Learners', linaerSvmTemplate, 'KFold', 5);
% % mdlLinearSVM.kfoldLoss
% 
% mdlLinearSVM      = fitcecoc(mX', vClass, 'Learners', linaerSvmTemplate);
% mdlLinearSVM.resubLoss

rlocus(n, d)