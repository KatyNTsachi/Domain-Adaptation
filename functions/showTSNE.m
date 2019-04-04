function [] = showTSNE(  c_data_for_classifier, vClass, description_for_data )
    
    for ii = 1 : length(c_data_for_classifier)
        %-- show
        tsne_points = tsne(c_data_for_classifier{ii}');
        figure();
        %scatter( tsne_points(:,1), tsne_points(:,2), 50, vClass, 'filled', 'MarkerEdgeColor', 'k' );
        scatter( tsne_points(vClass==1,1), tsne_points(vClass==1,2), 100, 'b', 'filled', 'MarkerEdgeColor', 'k' );
        hold on;
        scatter( tsne_points(vClass==2,1), tsne_points(vClass==2,2), 100, 'g','filled', 'MarkerEdgeColor', 'k');
        scatter( tsne_points(vClass==3,1), tsne_points(vClass==3,2), 100, 'y', 'filled', 'MarkerEdgeColor', 'k' );
        scatter( tsne_points(vClass==4,1), tsne_points(vClass==4,2), 100, 'r', 'filled', 'MarkerEdgeColor', 'k' );
        title("TSNE of " + description_for_data, 'FontSize',44);
        legend('left hand','right hand','both feet','tongue', 'FontSize',25)
        set(gca,'xtick',[])
        set(gca,'ytick',[])
    end
    
end



