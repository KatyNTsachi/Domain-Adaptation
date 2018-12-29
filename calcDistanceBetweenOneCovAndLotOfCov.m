function [ret_distance] = calcDistanceBetweenOneCovAndLotOfCov(mean,group_cov)
    
    ret_distance=zeros(size(group_cov,1),1);
    num_of_iter=size(group_cov,1);
    inv_mean=inv(mean);
    
    parfor i=1:num_of_iter
        tmp_cov=squeeze(group_cov(i,:,:));
        in_log=inv_mean*tmp_cov;
        eig_value=eig(in_log);
        eig_value_log=log(eig_value);
        eig_value_log_sum=sum(eig_value_log);
        eig_value_log_sum_sqrt=sqrt(eig_value_log_sum);
        ret_distance(i)=eig_value_log_sum_sqrt;
    end
    
end

