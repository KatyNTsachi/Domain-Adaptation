close all
clear
addpath("./functions");

%%
for subject = 8:24 %1:7
    for sess = 1:1 %1:8
        load("../DATASET/new_dataset2_2/"   + num2str(subject) + "session_" + num2str(sess) + ".mat");
        load("../DATASET/new_dataset2_2/y_" + num2str(subject) + "session_" + num2str(sess) + ".mat");

        mX = X;
        vY = y;
        Data = 1e6 * mX;
        %% 
        Data = Data - mean(Data, 3);

        L       = size(Data, 1);
        clear Covs;
        Covs{L} = [];

        vIdx = vY == 1;

        mE1 = squeeze( mean(Data(vIdx,1:16,:), 1) );
        mE2 = squeeze( mean(Data(vIdx == false,1:16,:), 1) );
        mE = mE1 - mE2;


        %%
        for ll = 1 : L
            mXi = squeeze( Data(ll,1:16,:) );

        %     mXX = mXi;

            mXX = [mE;
                   mXi];

            Covs{ll} = cov(mXX');
        end

        %%
        mX = prepareForClassification( cat(3, Covs{:}) );

        %%
        % mZ = tsne(mX')';
        mZ = pca(mX, 'NumComponents', 2)';
        figure; scatter(mZ(1,:), mZ(2,:), 100, vY,  'Fill', 'MarkerEdgeColor', 'k');
        title("subject: " + num2str(subject) + " session: " + num2str(sess));
    end
end