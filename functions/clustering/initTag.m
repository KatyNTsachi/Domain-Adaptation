function [mean1, cluster1, mean2, cluster2] = initTag(t_time, vClass)
  
    current_time_means = nan( size(t_time, 1), size(t_time, 2), 2 );
    
    
    cluster1 = vClass == 1; 
    cluster2 = vClass == 2; 
    
    mean1 = mean(t_time(:, :, cluster1), 3);
    mean2 = mean(t_time(:, :, cluster2), 3);

    
end


