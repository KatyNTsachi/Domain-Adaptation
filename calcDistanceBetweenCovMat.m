function [ret_distance] = calcDistanceBetweenCovMat(mean,group_cov)
    
    ret_distance = zeros(size(group_cov,3),1);
    num_of_iter  = size(group_cov,3);
    %inv_mean     = inv(mean);
    
    parfor ii=1:num_of_iter
        tmp_cov                 = group_cov(:,:,ii);
        %in_log                 = inv_mean*tmp_cov;
        eig_value               =  eig(tmp_cov,mean);%eig(in_log);
        eig_value_log           = log(eig_value);
        eig_value_log           = eig_value_log.^2;
        eig_value_log_sum       = sum(eig_value_log);
        eig_value_log_sum_sqrt  = sqrt(eig_value_log_sum);
        ret_distance(ii)        = eig_value_log_sum_sqrt;
    end
    
end

