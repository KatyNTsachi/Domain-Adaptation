function [cov_projected_on_mean] = prepareForClassification( tesor_of_all_events, remove_extra )
    % prepare data for classifier.
    % each column of data is a sample
    % each row of data is a feature
    % class is the last row of data
    epsilon  = 1e-6;
    max_iter = 100;
    
    mean                  = riemannianMean( tesor_of_all_events, epsilon, max_iter );
    N                     = size(tesor_of_all_events,3);
    p_minus_pow_half      = mean^(-1/2);
    cov_projected_on_mean = nan( size(tesor_of_all_events) );

    %%
    parfor ii=1:N
        tmp_pi        = tesor_of_all_events(:,:,ii);
        in_log        = p_minus_pow_half * tmp_pi * p_minus_pow_half;
        log_mat       = logm(in_log);
        cov_projected_on_mean(:,:,ii) =  log_mat ;
    end
    
    cov_projected_on_mean = symetric2Vec( cov_projected_on_mean, remove_extra );
        
end
