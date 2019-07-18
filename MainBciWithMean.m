% close all;
clear;

addpath('../RiemannianTools');
addpath('../');

%% Load Data:
S1 = 7;
D1 = 2;

disp('Load Data');
[Events, vClass] = GetEvents(S1, D1);
% vClassIdx        = ismember(vClass, [1, 2]);
% Events           = Events(vClassIdx);
% vClass           = vClass(vClassIdx);
Covs             = CalcCovs(Events);
N                = length(Events);

%% No OT
mX = CovsToVecs(cat(3, Covs{:}));

%%
mTSNE = tsne(mX')';
figure; scatter(mTSNE(1,:), mTSNE(2,:), 50, vClass, 'Fill', 'MarkerEdgeColor', 'k');

%% Mean
vIdx1      = vClass == 1;
vIdx2      = vClass == 2;
vIdx3      = vClass == 3;
vIdx4      = vClass == 4;
mEvents    = cat(3, Events{:});
mMean1     = mean(mEvents(:,:,vIdx1), 3);
mMean2     = mean(mEvents(:,:,vIdx2), 3);
mMean3     = mean(mEvents(:,:,vIdx3), 3);
mMean4     = mean(mEvents(:,:,vIdx4), 3);

mAugEvents = cat(2, mEvents, repmat(mMean1, 1, 1, N), repmat(mMean2, 1, 1, N), repmat(mMean3, 1, 1, N), repmat(mMean4, 1, 1, N));

figure; hold on;
plot(mean(mMean1, 2), 'b', 'LineWidth', 2);
plot(mean(mMean2, 2), 'r', 'LineWidth', 2);
plot(mean(mMean3, 2), 'g', 'LineWidth', 2);
plot(mean(mMean4, 2), 'k', 'LineWidth', 2);

%%
CovsAug = CalcCovs( squeeze(num2cell(mAugEvents, [1, 2])) );
mAugX   = CovsToVecs(cat(3, CovsAug{:}));

%%
mTSNE = tsne(mAugX')';
figure; scatter(mTSNE(1,:), mTSNE(2,:), 50, vClass, 'Fill', 'MarkerEdgeColor', 'k');

%%
mData1 = [mX;
          vClass;];
      
      
mPCA   = pca(mAugX, 'NumComponents', 288)';
mData2 = [mPCA;
          vClass;];
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function Covs = CalcCovs(Events)
    for ii = 1 : length(Events)
        mX       = Events{ii}';
        Covs{ii} = cov(mX');
    end
end

%%
function PlotData(mX, vClass, vS)

    vMarker = 'od';
    vColorS = 'br';
    vColorC = 'gmyk';
    
    vUniqueS  = unique(vS);
        
    %--
    subplot(1,2,2);
    for cc = 1 : 4
        vIdxC = vClass == cc;
        for ss = 1 : 2
            marker = vMarker(ss);
            vIdxS  = vS == vUniqueS(ss);
            color  = vColorS(ss);
            vIdx   = vIdxS & vIdxC;
            scatter(mX(1,vIdx), mX(2,vIdx), 50, color, marker, 'Fill', 'MarkerEdgeColor', 'k'); hold on;
        end
    end
    
    h = legend({['Subject - ', num2str(vUniqueS(1))];
                ['Subject - ', num2str(vUniqueS(2))]}, ...
                'FontSize', 12, 'Location', 'Best'); set(h, 'Color', 'None');
    axis tight;
    
    %--
    subplot(1,2,1);
    for ss = 1 : 2
        marker = vMarker(ss);
        vIdxS  = vS == vUniqueS(ss);
        for cc = 1 : 4
            color  = vColorC(cc);
            vIdxC = vClass == cc;
            vIdx  = vIdxS & vIdxC;
            scatter(mX(1,vIdx), mX(2,vIdx), 50, color, marker, 'Fill', 'MarkerEdgeColor', 'k'); hold on;
        end
    end
    
    h = legend({'Left Hand', 'Right Hand', 'Foot', 'Tongue'}, 'FontSize', 12, 'Location', 'Best'); set(h, 'Color', 'None');
    axis tight;
end
