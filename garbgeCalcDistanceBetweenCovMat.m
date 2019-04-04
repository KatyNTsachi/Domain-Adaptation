function [ret_distance] = calDistanceBetweenTwoCovVec( X )
    
    N            = size(group_cov, 3);
    ret_distance = nan(N, 1);
    
    parfor ii=1 : N
        Pi               = group_cov(:,:,ii);
        %in_log          = inv_mean*tmp_cov;
        eig_value        = eig(Pi, mean); %eig(in_log);
        ret_distance(ii) = norm(log(eig_value))
    
    
end

