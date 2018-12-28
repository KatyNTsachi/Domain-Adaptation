function [ret_p] = projectToRiemannianSpace(p,s)
    %p is the point in which we create the tangent plane
    %s is the projection of the point from the riemannian plane
    
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
            in_exp=p_minus_pow_half*s*p_minus_pow_half;
            exp_mat=expm(in_exp);
            ret_p(i,:,:)=p_pow_half*exp_mat*p_pow_half;
        end
    
    else
        in_exp=p_minus_pow_half*s*p_minus_pow_half;
        exp_mat=expm(in_exp);
        ret_p(:,:)=p_pow_half*exp_mat*p_pow_half;
    end        
end




