
function [] = pcaReduceCovData(data_for_classifier, description_for_data, vClass)
     [ mat_pca, ~, eig_value ] = pca(data_for_classifier);
     figure();
     idx_color_a = find(vClass == 0);
     idx_color_b = find(vClass == 1);
     scatter(mat_pca(idx_color_a, 1), mat_pca(idx_color_a, 2), 100, 'b', 'filled', 'MarkerEdgeColor', 'k');
     hold on;
     scatter(mat_pca(idx_color_b, 1), mat_pca(idx_color_b, 2), 100, 'r', 'filled', 'MarkerEdgeColor', 'k');
     title(description_for_data);
end

