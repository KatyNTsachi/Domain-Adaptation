function [cWithAverage, c_input_test] = addEstimatedDiffrenceAverageOldDataTest(cInput, c_input_test, vClass)

    tmp = cell2mat(cInput);
    t_Input = reshape(tmp, size(cInput{1}, 1), size(cInput{1}, 2), size(cInput, 2));

%% display PCA
    sample_num = 200;
    [eigen_vectors, ~, latent] = pca( t_Input(:, :, sample_num) );
    
    num_of_pca_vectors = 9;
    t_Input_pca = nan(size(t_Input, 1), num_of_pca_vectors, size(t_Input, 3));
    for ii = 1:size(t_Input, 3)
        t_Input_pca(:, :, ii) = t_Input(:, :, ii) * eigen_vectors(:, 1:num_of_pca_vectors); 
    end
    
%     t_Input_pca = t_Input * eigen_vectors; multiple
%     new_data = t_Input(:, :, sample_num)* eigen_vectors;
%     figure();   subplot(18,1,1); plot(t_Input(:, :, sample_num)); title('1');
%                 subplot(18,1,2); plot(new_data                 ); title('2');
% 
%     for ii = 3:18
%         subplot(18,1,ii); plot(new_data(:, ii)); title(num2str(ii) );
%     end
    t_Input_pca_down_sample = downsample(t_Input_pca, 2);

%     for chanel = 1:16
%         disp("######################################################")
%         disp (chanel)
%         gmfit = fitgmdist(  squeeze(t_Input_pca_down_sample(:, chanel, :))'  , 2         ,...
%                             'CovarianceType'  , 'diagonal',...
%                             'SharedCovariance', false   ...
%                            );
%         clusterX = cluster(gmfit, squeeze(t_Input_pca_down_sample(:, chanel, :))');
% 
%         sum( clusterX == 1 & vClass == 1) / sum( clusterX == 1)
%         sum( clusterX == 2 & vClass == 2) / sum( clusterX == 2)
%         
%         sum( clusterX == 2 & vClass == 1) / sum( clusterX == 2)
%         sum( clusterX == 1 & vClass == 2) / sum( clusterX == 1)
% 
%         
%     end 
    
    t_cov = nan( size(t_Input_pca_down_sample, 2), size(t_Input_pca_down_sample, 2), size(t_Input_pca_down_sample, 3));
    for ii = 1 : size(t_Input , 3)
        t_cov(:, :, ii)  =  cov( t_Input_pca_down_sample(:, :, ii) );
    end

    
    figure(); imagesc(mean(t_cov(:,:,vClass == 2), 3));
    figure(); imagesc(mean(t_cov(:,:,vClass == 1), 3));

    P = riemannianMean(t_cov, 0.01, 200);
    ret_p = projectToTangentSpace(P, t_cov);

    flattened_cov = symetric2Vec(t_cov);
    
    gmfit = fitgmdist(  flattened_cov'    , 2         ,...
                        'CovarianceType'  , 'diagonal',...
                        'SharedCovariance', false   ...
                       );
    clusterX = cluster(gmfit, flattened_cov');
    
    sum(clusterX == 2 & vClass == 2) / sum(clusterX == 2)
    sum(clusterX == 1 & vClass == 1) / sum(clusterX == 1)
    
    sum(clusterX == 1 & vClass == 2) / sum(clusterX == 1)
    sum(clusterX == 2 & vClass == 1) / sum(clusterX == 2)
    
    
%%


% %%  try to substract mean of all samples from each sample
% % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%     
%     %calc mean of vClass == 1
%     mat = cat(3, cInput{:});
%     mean_1 = mean(mat(:, :, :), 3);
% 
%     
%     %add mean to every cell
%     cWithAverage = {};
%     for data_i = 1:length(cInput)
% 
% %         cWithAverage{data_i} = [cInput{data_i}, mean_1];
%         cWithAverage{data_i} = cInput{data_i} - mean_1;
% 
%     end
%     
% %     for data_i = 1:length(c_input_test)
% % 
% % %         c_test_input{data_i} = [c_test_input{data_i}, mean_1];
% %           c_input_test{data_i} = c_input_test{data_i} - mean_1;
% % 
% %     end
% 
% 
%     % display projection
%     
%     tmp = cell2mat(cWithAverage);
%     t_Input = reshape(tmp, size(cWithAverage{1}, 1), size(cWithAverage{1}, 2), size(cWithAverage, 2));
%     
%     
%     chanel_num = 2;
%     tsne_points = tsne( squeeze( t_Input(:, chanel_num, :) )') ;
%     figure();
%     %scatter( tsne_points(:,1), tsne_points(:,2), 50, vClass, 'filled', 'MarkerEdgeColor', 'k' );
%     scatter( tsne_points(vClass==2,1), tsne_points(vClass==2,2), 100, 'g', 'filled', 'MarkerEdgeColor', 'k' );
%     hold on;
%     scatter( tsne_points(vClass==1,1), tsne_points(vClass==1,2), 100, 'r','filled', 'MarkerEdgeColor', 'k');
%     title("original");
%     
%     for tmp_i = 1:20;
%         idx_1 = find(vClass == 1);
%         idx_2 = find(vClass == 2);
%         figure(); subplot(2,1,1); plot(t_Input(:,idx_1(tmp_i)) ); title('1');
%                   subplot(2,1,2); plot(t_Input(:,idx_2(tmp_i)) ); title('2');
%     end
% % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% %%
% 
% 
%     tmp = cell2mat(cInput);
%     t_Input = reshape(tmp, size(cInput{1}, 1), size(cInput{1}, 2), size(cInput, 2));
%     
% %     t_cov = nan( size(t_Input, 2), size(t_Input, 2), size(t_Input, 3));
% %     for ii = 1 : size(t_Input , 3)
% %         t_cov(:, :, ii)  =  cov( t_Input(:, :, ii) );
% %     end
% %     
% %     P = riemannianMean(t_cov, 0.01, 200);
% %     ret_p = projectToTangentSpace(P, t_cov);
% %     
% %     flattened_cov = symetric2Vec(ret_p);
%     
%     time_input_mean = reshape(t_Input, size(t_Input, 1), [] );
%     big_vClass = kron(vClass, int64(ones(16,1)) );
%     idx_1 = find(big_vClass == 1);
%     idx_2 = find(big_vClass == 2);
%     for tmp_i = 16 * (1:3);
%         figure(); subplot(2,1,1); plot(time_input_mean(:,idx_1(tmp_i))-time_input_mean(:,idx_2(tmp_i)) ); title('1');
% %         subplot(2,1,2);           plot(time_input_mean(:,idx_2(tmp_i)) ); title('2');
%     end
%     
%     gmfit = fitgmdist(  time_input_mean'  , 2         ,...
%                         'CovarianceType'  , 'diagonal',...
%                         'SharedCovariance', false   ...
%                        );
%     clusterX = cluster(gmfit, time_input_mean');
%     
%     sum(clusterX == 2 & big_vClass == 2) / sum(big_vClass == 2)
%     
% %     figure();
% %     imagesc(mean(t_cov(:,:,vClass == 2), 3));
% %     
% %     figure();
% %     imagesc(mean(t_cov(:,:,vClass == 1), 3));
%     
%     
%     tsne_points = tsne(time_input_mean');
%     figure();
%     %scatter( tsne_points(:,1), tsne_points(:,2), 50, vClass, 'filled', 'MarkerEdgeColor', 'k' );
%     scatter( tsne_points(big_vClass==2,1), tsne_points(big_vClass==2,2), 100, 'g', 'filled', 'MarkerEdgeColor', 'k' );
%     hold on;
%     scatter( tsne_points(big_vClass==1,1), tsne_points(big_vClass==1,2), 100, 'r','filled', 'MarkerEdgeColor', 'k');
%     title("original");
%     
%     figure();
%     %scatter( tsne_points(:,1), tsne_points(:,2), 50, vClass, 'filled', 'MarkerEdgeColor', 'k' );
%     scatter( tsne_points(clusterX==2,1), tsne_points(clusterX==2,2), 100, 'g', 'filled', 'MarkerEdgeColor', 'b' );
%     hold on;
%     scatter( tsne_points(clusterX==1,1), tsne_points(clusterX==1,2), 100, 'r','filled', 'MarkerEdgeColor', 'k');
%     title("clusters")
% 
% %     %ADDAVERAGE Summary of this function goes here
% %     %   Detailed explanation goes here
% %     
% %     %calc mean of vClass == 1
% %     mat = cat(3, cInput{:});
% %     mean_1 = mean(mat(:, :, vClass==1 ), 3);
% %     mean_0 = mean(mat(:, :, vClass==2 ), 3);
% % 
% %     %add mean to every cell
% %     cWithAverage = {};
% %     for data_i = 1:length(cInput)
% % 
% %         cWithAverage{data_i} = [cInput{data_i}, mean_0 - mean_1];
% % 
% %     end
% %     
% %     for data_i = 1:length(c_input_test)
% % 
% %         c_input_test{data_i} = [c_input_test{data_i}, mean_0 - mean_1];
% % 
% %     end

end

