function [cWithAverage1, cWithAverage2] = addPCAGMMAverageTest(cInput1, cInput2, vClass1, vClass2)
    %ADDAVERAGE Summary of this function goes here
    %   Detailed explanation goes here
    
    %calc mean of vClass == 1
    
    all_cInput = {cInput1{:} cInput2{:}};
    mat = cat(3, all_cInput{:});
    vec_of_all_samples = [];
    
    for ii = 1 : size(mat,3)
        
        vec_of_all_samples = [ vec_of_all_samples, mat(:, :, ii)' ];
        
    end
    
    [eigen_vectors, ~, latent] = pca(vec_of_all_samples');
    
    num_of_pca_vectors = 10;
    t_Input_pca = nan(size(mat, 1), num_of_pca_vectors, size(mat, 3));
    
    for ii = 1 : size(mat, 3)
        
        t_Input_pca(:, :, ii) = mat(:, :, ii) * eigen_vectors(:, 1:num_of_pca_vectors);
        
    end

    
    
    
    
    average_chanels = nan( size(t_Input_pca, 1), size(t_Input_pca, 2) );
    
    for chanel_num = 1 : size(t_Input_pca, 2)
        
        tmp = squeeze(t_Input_pca(:, chanel_num, :));
        [eigen_vectors, ~, latent] = pca(tmp');
               
        num_of_pca_vectors = 9;
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
    
    
    flattened_cov = prepareForClassification(t_cov);
    
    gmfit = fitgmdist(  flattened_cov'       , 2         ,...
                        'CovarianceType'     , 'diagonal',...
                        'SharedCovariance'   , false     ,...
                        'RegularizationValue', 1e-20      ...
                       );
    clusterX = cluster(gmfit, flattened_cov');

    mean1 = mean( mat(:, :, clusterX == 1), 3 );
    mean2 = mean( mat(:, :, clusterX == 2), 3 );
    
    mean_diff = ( mean1 - mean2 );
   
    %add mean to every cell
    cWithAverage1 = {};
    cWithAverage2 = {};
    for data_i = 1:length(cInput1)

        cWithAverage1{data_i} = [cInput1{data_i}, mean_diff];
        
    end
    
   for data_i = 1:length(cInput2)

       cWithAverage2{data_i} = [cInput2{data_i}, mean_diff];
        
    end


end

