function [cWithAverage, c_input_test] = addPCAGMMAverageOldDataTest(cInput, c_input_test, vClass)
    %ADDAVERAGE Summary of this function goes here
    %   Detailed explanation goes here
    
    %calc mean of vClass == 1
    
    
    mat = cat(3, cInput{:});
    vec_of_all_samples = [];
    
    for ii = 1 : size(mat,3)
        
        vec_of_all_samples = [ vec_of_all_samples, mat(:, :, ii)' ];
        
    end
    
    [eigen_vectors, ~, latent] = pca(vec_of_all_samples');
    
%     sum(latent(1:7)) / sum(latent)
    
    num_of_pca_vectors = 10;
    t_Input_pca = nan(size(mat, 1), num_of_pca_vectors, size(mat, 3));
    
    for ii = 1 : size(mat, 3)
        
        t_Input_pca(:, :, ii) = mat(:, :, ii) * eigen_vectors(:, 1:num_of_pca_vectors);
        
    end

    
    
    
    
    average_chanels = nan( size(t_Input_pca, 1), size(t_Input_pca, 2) );
    
    for chanel_num = 1 : size(t_Input_pca, 2)
        
        tmp = squeeze(t_Input_pca(:, chanel_num, :));
        [eigen_vectors, ~, latent] = pca(tmp');
        
%         tmp = 10;
%         figure();
%         subplot(3,1,1);
%         plot( eigen_vectors(:, 1:tmp) );
%         subplot(3,1,2);
%         plot( mean( eigen_vectors(:, 1:tmp), 2 ) );
%         subplot(3,1,3);
%         plot( mean( squeeze( mat(:, chanel_num,:) ), 2 ) );
        
        num_of_pca_vectors = 10;
        eigen_vectors_to_use = eigen_vectors(:, 1:num_of_pca_vectors);
        average_chanels(:, chanel_num) = mean(eigen_vectors_to_use, 2);
        
    end
    
    extended_mat = nan( size(t_Input_pca, 1), size(t_Input_pca, 2) * 2, size(t_Input_pca, 3));
    for ii = 1 : size(extended_mat, 3)
        extended_mat(:, :, ii) = [t_Input_pca(:, :, ii), average_chanels];
    end
    
    t_cov = nan( size(extended_mat, 2), size(extended_mat, 2), size(extended_mat, 3));
    for ii = 1 : size(extended_mat , 3)
        t_cov(:, :, ii)  =  cov( extended_mat(:, :, ii) );
    end
    
    
    flattened_cov = symetric2Vec(t_cov);
    
    gmfit = fitgmdist(  flattened_cov'       , 2         ,...
                        'CovarianceType'     , 'diagonal',...
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
    
    
    mean1 = mean( mat(:, :, clusterX == 1), 3 );
    mean2 = mean( mat(:, :, clusterX == 2), 3 );
    
    mean_diff = -( mean1 - mean2 );
   
    %add mean to every cell
    cWithAverage = {};
    for data_i = 1:length(cInput)

        cWithAverage{data_i} = [cInput{data_i}, mean_diff];

    end
    
    for data_i = 1:length(c_input_test)

        c_input_test{data_i} = [c_input_test{data_i}, mean_diff];

    end

end

