close all
clear

%%
N = 200;
D = 70;

% mX1 = randn(D, N) - 2;
% mX2 = randn(D, N) + 2;
% mX3 = randn(D, N) + [2; -2];

mX1 = randn(D, N) - 0.5;
mX2 = randn(D, N) + 0.0;
mX3 = randn(D, N) + 0.5;

vY  = [1 * ones(N, 1);
       2 * ones(N, 1);
       3 * ones(N, 1)];
   
mX  = [mX1, mX2, mX3];

%%
Data = [vY'; mX];

%%
figure; scatter(mX(1,:), mX(2,:), 50, vY, 'Fill', 'MarkerEdgeColor', 'k');

%%
mZ = tsne(mX')';
% mZ = pca(mX, 'NumComponents', 2)';
figure; scatter(mZ(1,:), mZ(2,:), 50, vY, 'Fill', 'MarkerEdgeColor', 'k');