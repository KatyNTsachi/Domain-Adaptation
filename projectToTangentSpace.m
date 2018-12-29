function [ret_p] = projectToTangentSpace(p,pi)
    %p is the point in which we create the tangent plane
    %pi the point on the riemannian plane
    %we return the projectToTangentSpace

    %prepare for loop
    p_pow_half=mpower(p,0.5);
    p_minus_pow_half=mpower(p,-0.5);
    
    %is it list of mat or just one?
    if size(size(pi),2)==3
        ret_p=zeros(size(pi,1),size(pi,2),size(pi,3));
        num_of_matrics=size(pi,1);
    else
        ret_p=zeros(size(pi,1),size(pi,2));
        num_of_matrics=0;
    end
    
    if num_of_matrics~=0
        parfor i=1:num_of_matrics
            tmp_pi=squeeze(pi(i,:,:));
            in_log=p_minus_pow_half*tmp_pi*p_minus_pow_half;
            log_mat=logm(in_log);
            ret_p(i,:,:)=p_pow_half*log_mat*p_pow_half;
        end
    
    else
        in_log=p_minus_pow_half*pi*p_minus_pow_half;
        log_mat=logm(in_log);
        ret_p(:,:)=p_pow_half*log_mat*p_pow_half;
    end
  
end