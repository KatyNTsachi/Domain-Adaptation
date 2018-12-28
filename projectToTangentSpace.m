function [ret_p] = projectToTangentSpace(p,pi)
    %p is the point in which we create the tangent plane
    %pi the point on the riemannian plane
    %we return the projectToTangentSpace

    %prepare for loop
    p_pow_half=mpower(p,0.5);
    p_minus_pow_half=mpower(p,-0.5);
    
    %is it list of mat or just one?
    if size(size(s),2)==3
        ret_p=zeros(size(s,1),size(s,2),size(s,3));
        num_of_matrics=size(s,1);
    else
        ret_p=zeros(size(s,1),size(s,2));
        num_of_matrics=0;
    end
    
    if num_of_matrics~=0
        parfor i=1:num_of_matrics
            in_log=p_minus_pow_half*pi*p_minus_pow_half;
            log_mat=logm(in_log);
            ret_p(i,:,:)=p_pow_half*log_mat*p_pow_half;
        end
    
    else
        in_log=p_minus_pow_half*pi*p_minus_pow_half;
        log_mat=logm(in_log);
        ret_p(:,:)=p_pow_half*log_mat*p_pow_half;
    end
  
end