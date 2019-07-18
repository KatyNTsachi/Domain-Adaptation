close all
clear

load '../DATASET/new_dataset2_2/15session_1.mat'
load '../DATASET/new_dataset2_2/y_15session_1.mat'

mX = X;
vY = y;
Data = 1e6 * mX;
Data = Data - mean(Data, 3);

L       = size(Data, 1);
Covs{L} = [];

vIdx = vY == 2;

mE  = squeeze( mean(Data(vIdx,1:16,:), 1) );

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
    
    mXX = [mE;
           mXi];
           
    Covs{ll} = cov(mXX');
end

%%
mX = symetric2Vec(cat(3, Covs{:}));

%%
% mZ = tsne(mX')';
mZ = pca(mX, 'NumComponents', 2)';
figure; scatter(mZ(1,:), mZ(2,:), 100, vY,  'Fill', 'MarkerEdgeColor', 'k');
% figure; scatter(mZ(1,:), mZ(2,:), 100, 1:L, 'Fill', 'MarkerEdgeColor', 'k');

