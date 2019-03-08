function [] = showTSNE(  c_data_for_classifier, vClass, description_for_data )
    
    for ii = 1 : length(c_data_for_classifier)
        %-- show
        tsne_points = tsne(c_data_for_classifier{ii}');
        figure();
        scatter( tsne_points(:,1), tsne_points(:,2), 50, vClass, 'filled', 'MarkerEdgeColor', 'k' );
        title("TSNE of " + description_for_data );
    end
    
end



