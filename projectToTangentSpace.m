function [ret_p] = projectToTangentSpace(P, Pi)
    %p is the point in which we create the tangent plane
    %pi the point on the riemannian manifold
    %we return the S_i = LogMap_P(Pi)

    %prepare for loop
    p_pow_half       = P^(1/2);
    p_minus_pow_half = P^(-1/2);
    
    %is it list of mat or just one?
    if size(size(Pi), 2) == 3
        ret_p          = nan( size(Pi) );
        num_of_matrics = size(Pi, 3);
    else
        ret_p = nan( size(Pi) );
        num_of_matrics = 0;
    end
    
    if num_of_matrics ~= 0
        parfor i=1:num_of_matrics
            tmp_pi       = Pi(:,:,i);
            in_log       = p_minus_pow_half * tmp_pi * p_minus_pow_half;
            log_mat      = logm(in_log);
            ret_p(:,:,i) = p_pow_half * log_mat * p_pow_half;
        end
    else
        in_log=p_minus_pow_half*Pi*p_minus_pow_half;
        log_mat=logm(in_log);
        ret_p(:,:)=p_pow_half*log_mat*p_pow_half;
    end
  
end