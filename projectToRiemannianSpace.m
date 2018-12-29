function [ret_p] = projectToRiemannianSpace(p,s)
    %p is the point in which we create the tangent plane
    %s is the projection of the point from the riemannian plane
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% assuming that the input is
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% list of matrics
    
    %prepare for loop
    p_pow_half=mpower(p,0.5);
    p_minus_pow_half=mpower(p,-0.5);
    num_of_matrics=size(s,1)
    
    %is it list of mat or just one?
    if size(size(s),2)==3
        ret_p=zeros(size(s,1),zeros(size(s,2),zeros(size(s,1))
        
    end
    
    
    for i=1:num_of_matrics
        in_exp=p_minus_pow_half*s*p_minus_pow_half;
        exp_mat=expm(in_exp);
        ret_p(i)=p_pow_half*exp_mat*p_pow_half;
    end
end
