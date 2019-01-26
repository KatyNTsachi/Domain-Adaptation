function [cov_projected_on_mean] = prepareForClassification( tesor_of_all_events )
    % prepare data for classifier.
    % each column of data is a sample
    % each row of data is a feature
    % class is the last row of data
    epsilon  = 1e-6;
    max_iter = 100;
    
    mean                  = riemannianMean( tesor_of_all_events, epsilon, max_iter );
    cov_projected_on_mean = projectToTangentSpace( mean, tesor_of_all_events );
    cov_projected_on_mean = symetric2Vec( cov_projected_on_mean );
        
end
