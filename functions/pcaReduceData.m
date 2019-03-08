function [ events, mat_pca ] = pcaReduceData( events, acc, s_events)
    
    if exist( "../data/" + s_events + ".mat", 'file' )
        events  = load(  "../data/" + s_events + ".mat" );
        mat_pca = load(  "../data/" + s_events + "PCA.mat" );
        mat_pca = mat_pca.mat_pca;
        events  = events.events;
        return
    end
    %--cells to one matrix
    new_mat = [];
    for mat_i = events
       new_mat = [ new_mat; mat_i{1} ];
    end
    
    [ mat_pca, ~, eig_value ] = pca(new_mat);
    
    sum_of_all_eig = sum( eig_value );
    tmp_sum        = 0;
    num_of_dim     = size(eig_value,1);
    
    for ii=1:size(eig_value,1)
        tmp_sum = tmp_sum + eig_value(ii);
        if tmp_sum / sum_of_all_eig > acc
            num_of_dim = ii;
            break;
        end
    end
    
    %top components
    parfor ii = 1 : length(events)
        events{ii} = events{ii} * mat_pca( :, 1 : num_of_dim );
    end
    save( "../data/" + s_events+".mat", 'events' );
    save( "../data/" + s_events+"PCA.mat", 'mat_pca' );
end

