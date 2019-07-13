function [cWithAverage, c_input_test] = addEstimatedDiffrenceAverageOldDataTestFullGMM(cInput, c_input_test, vClass)

    tmp = cell2mat(cInput);
    t_Input = reshape(tmp, size(cInput{1}, 1), size(cInput{1}, 2), size(cInput, 2));

%% display PCA
    sample_num = 200;
    %build pca samples
    vec_of_all_samples = [];
    for ii = 1 : size(t_Input,3)
        vec_of_all_samples = [ vec_of_all_samples, t_Input(:, :, ii)' ];
    end
    [eigen_vectors, ~, latent] = pca(vec_of_all_samples');
    
    num_of_pca_vectors = 7;
    t_Input_pca = nan(size(t_Input, 1), num_of_pca_vectors, size(t_Input, 3));
    for ii = 1:size(t_Input, 3)
        t_Input_pca(:, :, ii) = t_Input(:, :, ii) * eigen_vectors(:, 1:num_of_pca_vectors); 
    end
    
%     t_Input_pca_down_sample = downsample(t_Input_pca, 2);
    t_Input_pca_down_sample = t_Input_pca;
    
    t_cov = nan( size(t_Input_pca_down_sample, 2), size(t_Input_pca_down_sample, 2), size(t_Input_pca_down_sample, 3));
    for ii = 1 : size(t_Input , 3)
        t_cov(:, :, ii)  =  cov( t_Input_pca_down_sample(:, :, ii) );
    end

    
%     figure(); imagesc(mean(t_cov(:,:,vClass == 2), 3));
%     figure(); imagesc(mean(t_cov(:,:,vClass == 1), 3));

%     P = riemannianMean(t_cov, 0.01, 200);
%     ret_p = projectToTangentSpace(P, t_cov);

    flattened_cov = symetric2Vec(t_cov);
    
    gmfit = fitgmdist(  flattened_cov'       , 2         ,...
                        'CovarianceType'     , 'full',...
                        'SharedCovariance'   , false     ,...
                        'RegularizationValue', 1e-20      ...
                       );
    clusterX = cluster(gmfit, flattened_cov');
    
%     sum(clusterX == 2 & vClass == 2) / sum(clusterX == 2)
%     sum(clusterX == 1 & vClass == 1) / sum(clusterX == 1)
%     
%     sum(clusterX == 1 & vClass == 2) / sum(clusterX == 1)
%     sum(clusterX == 2 & vClass == 1) / sum(clusterX == 2)

%     tsne_points = tsne(flattened_cov');
%     
%     first_class = 1;
%     seccond_class = 2;
%     figure();
%     scatter( tsne_points(vClass==2,1), tsne_points(vClass==2,2), 100, 'g', 'filled', 'MarkerEdgeColor', 'k' );
%     hold on;
%     scatter( tsne_points(clusterX==seccond_class,1), tsne_points(clusterX==seccond_class,2), 10, 'r','filled', 'MarkerEdgeColor', 'k');
%     title("class 2");
%     
%     figure();
%     scatter( tsne_points(vClass==1,1), tsne_points(vClass==1,2), 100, 'g', 'filled', 'MarkerEdgeColor', 'k' );
%     hold on;
%     scatter( tsne_points(clusterX==first_class,1), tsne_points(clusterX==first_class,2), 10, 'r','filled', 'MarkerEdgeColor', 'k');
%     title("class 1")

    mean1 = mean( t_Input(:, :, clusterX == 1), 3 );
    mean2 = mean( t_Input(:, :, clusterX == 2), 3 );
    
    mean_diff = mean1 - mean2;
    
    cWithAverage = {};
    
    for ii = 1:length(cInput)
        cWithAverage{1, ii} = [cInput{1, ii}, mean_diff]; 
    end
    
    for ii = 1:length(c_input_test)
        c_input_test{1, ii} = [c_input_test{1, ii}, mean_diff]; 
    end
    
    

end

