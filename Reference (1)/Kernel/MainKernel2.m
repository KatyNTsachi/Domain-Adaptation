% close all;
clear;

addpath('./RiemannianTools');

%% Load Data:
[Events, vClass] = GetEvents(8, 1);
vIdx             = ismember(vClass, [1, 2, 3, 4]);
% vIdx             = ismember(vClass, [1, 4]);
vClass           = vClass(vIdx);
Events           = Events(vIdx);
Covs             = CalcCovs(Events);
% Covs             = CalcCovs3(Events);
% Covs             = CalcPcaCovs(Events);
% Covs             = CalcKpcaCovs(Events);
mX               = CovsToVecs(cat(3, Covs{:}));

mZ = tsne(mX')';
figure; scatter(mZ(1,:), mZ(2,:), 50, vClass, 'Fill', 'MarkerEdgeColor', 'k');

%%
mD  = squareform( pdist(mX') );
eps = median(mD(:));
mK  = exp(-mD.^2 / eps^2);
mA  = mK ./ sum(mK, 2);

[mPhi, vLam] = eig(mA, 'vector');
figure; scatter3(mPhi(:,2), mPhi(:,3), mPhi(:,4), 50, vClass, 'Fill', 'MarkerEdgeColor', 'k');

%%
P  = 20;
mY = mPhi(:,1:P) .* vLam(1:P)';

mZ2 = tsne(mY)';
figure; scatter(mZ2(1,:), mZ2(2,:), 50, vClass, 'Fill', 'MarkerEdgeColor', 'k');
%% 
linaerSvmTemplate = templateSVM('Standardize', false);
mdlLinearSVM      = fitcecoc(mX', vClass, 'Learners', linaerSvmTemplate, 'KFold', 5);
mdlLinearSVM.kfoldLoss

%%
function Covs = CalcCovs(Events)
    for ii = 1 : length(Events)
        mX       = Events{ii}';
        Covs{ii} = cov(mX');
%         Covs{ii} = corrcoef(mX');
%         Covs{ii} = -partialcorr(mX') + 2*eye(22);
    end
end

%%
function Covs = CalcCovs3(Events)
    for ii = 1 : length(Events)
        mX       = Events{ii}';
        mX       = [
                    mX(:,1:end-4);
                    mX(:,2:end-3);
                    mX(:,3:end-2);
                    mX(:,4:end-1);
                    mX(:,5:end)];
                    
        Covs{ii} = cov(mX');
    end
end

%%
function Covs = CalcPcaCovs(Events)
    mAll  = cat(1, Events{:})';
    vMean = mean(mAll, 2);
    mU    = pca(mAll');
    for ii = 1 : length(Events)
        mX       = mU' * (Events{ii}' - vMean);
        Covs{ii} = cov(mX');
    end
end

%%
function Covs = CalcKpcaCovs(Events)
    mAll        = cat(1, Events{:})';
    [mW, mT, vQ] = KPCA(mAll, 20);
    
    for ii = 1 : length(Events)
        mX       = Events{ii}';
        mD       = pdist2(mX', mT')';
        mK       = exp(-mD.^2 / 1000);
%         mK       = mK - sum(mK) + vQ;
        mZ       = mW' * mK;
        Covs{ii} = cov(mZ');
    end
end

%%
function [mW, mX, vQ] = KPCA(mX, d)
    N       = size(mX, 2);
    if N > 1000
        vIdx = randperm(N, 1000);
        mX   = mX(:,vIdx);
        N    = 1000;
    end
    J       = eye(N) - 1/N * ones(N);
    
    mD      = squareform( pdist(mX') );
    K       = exp(-mD.^2 / 1000);
    K       = J * K * J;
    
    [V, vL] = eig(K, 'vector');
    
    [vL, vIdx] = sort(vL, 'descend');
    V          = V(:,vIdx);
    
    V       = V(:,1:d);
    vL      = vL(1:d);
    
    mW      = V ./ sqrt(vL');
    
    vQ      = -1/N * sum(K, 2) + 1/N^2 * sum(K(:));
%     mZ      = ((1 ./ sqrt(vL)) .* V') * K;
end