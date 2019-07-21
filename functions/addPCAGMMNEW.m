function [cWithAverage1, cWithAverage2] = addPCAGMMNEW(cInput, vClass)
    %ADDAVERAGE Summary of this function goes here
    %   Detailed explanation goes here
    
    %calc mean of vClass == 1
    
    mat = cat(3, cInput{:});
    
    average_chanels = nan( size(mat, 1), size(mat, 2) );
    
    for chanel_num = 1 : size(mat, 2)
        
        tmp = squeeze(mat(:, chanel_num, :));
        eigen_vectors = pca(tmp');
               
        num_of_pca_vectors = 10;
        eigen_vectors_to_use = eigen_vectors(:, 1:num_of_pca_vectors);
        average_chanels(:, chanel_num) = mean(eigen_vectors_to_use, 2);
        
    end
    mean1 = mean( mat(:, :, vClass == 1),3 );
    mean2 = mean( mat(:, :, vClass == 2),3 );

    average_chanels = mean1 - mean2;
    
    NUM_OF_ITER = 10;
    for iter_num = 1:NUM_OF_ITER
    
%         figure();
%         plot(average_chanels);
%         title("average chanels at iteration: " + num2str(iter_num - 1) );
        
        extended_mat = nan( size(mat, 1), size(mat, 2) * 2, size(mat, 3));
        for ii = 1 : size(extended_mat, 3)
            extended_mat(:, :, ii) = [mat(:, :, ii), average_chanels];
        end

        t_cov = nan( size(extended_mat, 2), size(extended_mat, 2), size(extended_mat, 3));
        for ii = 1 : size(extended_mat , 3)
            t_cov(:, :, ii)  =  cov( extended_mat(:, :, ii) );
        end

        flattened_cov = prepareForClassification(t_cov, false);
        top_flattened_cov = pca(flattened_cov, 'NumComponents', 400)';
        gmfit = fitgmdist(  top_flattened_cov'       , 2         ,...
                            'CovarianceType'     , 'diagonal',...
                            'SharedCovariance'   , false     ,...
                            'RegularizationValue', 1e-20      ...
                           );
        clusterX = cluster(gmfit, top_flattened_cov');

        mean1 = mean( mat(:, :, clusterX == 1), 3 );
        mean2 = mean( mat(:, :, clusterX == 2), 3 );

        mean_diff = ( mean1 - mean2 );

        average_chanels = mean_diff;

        pre1 = calPrecision(clusterX, vClass);
        other_clusterX = clusterX == 1;
        other_clusterX = other_clusterX + 1;
        pre2 = calPrecision(other_clusterX, vClass);
        disp(max(pre1, pre2));
        
        flattened_cov_pca = pca(flattened_cov, 'NumComponents', 2);
        
        figure();
        scatter(flattened_cov_pca(clusterX == 1, 1), flattened_cov_pca(clusterX == 1, 2), 'r', 'filled', 'MarkerEdgeColor', 'k');
        hold on;
        scatter(flattened_cov_pca(clusterX == 2, 1), flattened_cov_pca(clusterX == 2, 2), 'b', 'filled', 'MarkerEdgeColor', 'k');
        title("iter" + num2str(iter_num));

%         for data_i = 1:length(cInput1)
% 
%             cWithAverage1{data_i} = [cInput1{data_i}, mean_diff];
% 
%         end
    
    end 
    
    
    
    
    
    
    
    %add mean to every cell
    cWithAverage1 = {};
    cWithAverage2 = {};
    for data_i = 1:length(cInput)

        cWithAverage1{data_i} = [cInput{data_i}, mean_diff];
        
    end
    
   for data_i = 1:length(cInput)

       cWithAverage2{data_i} = [cInput{data_i}, mean_diff];
        
    end


end










function [pre] = calPrecision(y_predicted, y)
    
    % calc precision
    tp  = sum((y == 2) & (y_predicted == 2));
    fp  = sum((y == 1) & (y_predicted == 2));
    
    if tp + fp ~= 0 
        pre = tp / (tp + fp);
    else 
        pre = 0;
    end
        
end






