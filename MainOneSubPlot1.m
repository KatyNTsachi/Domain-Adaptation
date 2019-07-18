% close all
clear

addpath('../');
addpath('../RiemannianTools/');
addpath('./py.BI.EEG.2013-GIPSA-master/');

%%
% load Subject4Session1.mat
load Subject18Session1.mat
Data = 1e6 * mX;
Data = Data - mean(Data, 3);

L       = size(Data, 1);
Covs{L} = [];

vIdx = vY == 1;

mE  = squeeze( mean(Data(vIdx,1:16,:), 1) );
mE2 = squeeze( mean(Data(:,1:16,:), 1) );

%%
mP = nan(size(mE));
for ii = 1 : 16
    mX       = squeeze(Data(:,ii,:));
    mP(ii,:) = pca(mX, 'NumComponents', 1);
end


%%
for ll = 1 : L
    mXi = squeeze( Data(ll,1:16,:) );

%     mXX = mXi;
    
    mXX = [mP;
           mXi];
           
    Covs{ll} = cov(mXX');
end

%%
mX = CovsToVecs(cat(3, Covs{:}));

%%
% mZ = tsne(mX')';
mZ = pca(mX, 'NumComponents', 2)';
figure; scatter(mZ(1,:), mZ(2,:), 100, vY,  'Fill', 'MarkerEdgeColor', 'k');
% figure; scatter(mZ(1,:), mZ(2,:), 100, 1:L, 'Fill', 'MarkerEdgeColor', 'k');

