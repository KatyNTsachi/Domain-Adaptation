function [current_time_means] = customKmean(t_time, init_func, vClass)
   
    MAX_NUM_OF_ITER    = 30;
    counter            = 0;
    current_cov_means  = nan;

    
    t_cov = nan( size(t_time, 2), size(t_time, 2), size(t_time, 3));
    for ii = 1 : size(t_time, 3)
        t_cov(:, :, ii)  =  cov( t_time(:, :, ii) );
    end
    
    new_means          = nan(size(t_cov, 1), size(t_cov, 2), 2);
    
%     sample_num1 = 1;
%     sample_num2 = 1;
%     
%     while sample_num1 == sample_num2
%         
%         sample_num1 = randsample(size(t_cov, 3), 1);
%         sample_num2 = randsample(size(t_cov, 3), 1);       
%         
%     end 
%     
%     new_cov_means(:, :, 1) = t_cov(:, :, sample_num1);%mean(t_cov(:, :, 1:int32(size(t_cov,3)/2)), 3);
%     new_cov_means(:, :, 2) = t_cov(:, :, sample_num2);%mean(t_cov(:, :, int32(size(t_cov,3)/2):end), 3);
%     
%     current_time_means = nan( size(t_time, 1), size(t_time, 2), 2 );
%     current_time_means(:, :, 1) = t_time(:, :, sample_num1);
%     current_time_means(:, :, 2) = t_time(:, :, sample_num2);
    

    [mean1, cluster1, mean2, cluster2] = init_func(t_time, vClass);
    new_cov_means(:, :, 1) = mean(t_cov(:, :, cluster1), 3);
    new_cov_means(:, :, 2) = mean(t_cov(:, :, cluster2), 3);
    
    current_time_means = nan( size(t_time, 1), size(t_time, 2), 2 );
    
    current_time_means(:, :, 1) = mean1;
    current_time_means(:, :, 2) = mean2;



    while ~isequal(current_cov_means, new_cov_means) && counter < MAX_NUM_OF_ITER
        
        current_cov_means       = new_cov_means;
        [labels, new_cov_means] = oneIteration( t_cov,...
                                                t_time,...
                                                current_cov_means,...
                                                current_time_means);
        counter                 = counter + 1;
        
        %calc time mean for next iter
        if sum(labels == 1) >= 1
            current_time_means(:, :, 1) = mean(t_time(:, :, labels == 1), 3);
        end
        if sum(labels == 2) >= 1
            current_time_means(:, :, 2) = mean(t_time(:, :, labels == 2), 3);
        end
        
        %print counter
        disp(counter)
        
    end
    
    current_time_means          = nan( size(t_time, 1), size(t_time, 2), 2 );
    current_time_means(:, :, 1) = mean(t_time(:, :, labels == 1), 3);
    current_time_means(:, :, 2) = mean(t_time(:, :, labels == 2), 3);

end



function [labels, new_cov_means] = oneIteration(t_cov, t_time, current_cov_means, current_time_means)
    
    %arrange data for subtraction mean
    
    % prepare time data
    t_time_sub   = t_time                      - current_time_means(:, :, 1);
    sub_mean     = current_time_means(:, :, 2) - current_time_means(:, :, 1);
    
    % prepare cov data
    
    %initilize
    t_cov_sub             = nan( size(t_time_sub, 2), size(t_time_sub, 2), size(t_time_sub, 3));
    current_cov_means_sub = nan( size(t_time_sub, 2), size(t_time_sub, 2), 1); 
    
    %calc
    for ii = 1 : size(t_time_sub, 3)
        t_cov_sub(:, :, ii)  =  cov( t_time_sub(:, :, ii) );
    end
    
    current_cov_means_sub = cov(sub_mean);
    
    
    % lable    
    dist_1 = calcDistanceBetweenCovMat(current_cov_means_sub(:, :), t_cov_sub);
    dist_2 = calcDistanceBetweenCovMat(current_cov_means(:, :, 1) , t_cov);
    labels = int32(dist_1 < dist_2) + 1;
        
    % calc new means
    new_cov_means = current_cov_means;
    epsilon           = 1e-6;
    max_iter          = 200;
    
    if sum(labels == 1) >= 1 
        new_cov_means(:, :, 1) = riemannianMean(t_cov(:, :, labels == 1), epsilon, max_iter);
    end
    
    if sum(labels == 2) >= 1 
        new_cov_means(:, :, 2) = riemannianMean(t_cov(:, :, labels == 2), epsilon, max_iter);
    end
    
    disp(sum(labels == 1));
    disp(sum(labels == 2));
end
