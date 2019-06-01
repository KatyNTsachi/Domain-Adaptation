function [] = showTSNE2class(  c_data_for_classifier, vClass, c_description_for_data )
    
    for ii = 1 : length(c_data_for_classifier)
        %-- show
        tsne_points = tsne(c_data_for_classifier{ii}');
        figure();
        %scatter( tsne_points(:,1), tsne_points(:,2), 50, vClass, 'filled', 'MarkerEdgeColor', 'k' );
        scatter( tsne_points(vClass==0,1), tsne_points(vClass==0,2), 100, 'b', 'filled', 'MarkerEdgeColor', 'k' );
        hold on;
        scatter( tsne_points(vClass==1,1), tsne_points(vClass==1,2), 100, 'g','filled', 'MarkerEdgeColor', 'k');
        
        title("TSNE of " + c_description_for_data{ii}, 'FontSize',44);
        legend('dont see','see', 'FontSize',25)
        set(gca,'xtick',[])
        set(gca,'ytick',[])
    end
    
end

