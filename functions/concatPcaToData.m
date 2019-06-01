function [Events_with_pca] = concatPcaToData(Events, vClass, num_chanells)
    %we calc pca and concatinte to Events
    
    pac_to_add = [];
    %our pca idea
    mat = cat(3, Events{:});    
    for ii = 1:size(Events{1}, 2)
    
        one_dim    = squeeze(mat(:, ii, vClass == 1))';
        pca_res    = pca(one_dim);
        main_dir   = pca_res(:, 1:num_chanells)';
        
        pac_to_add = [pac_to_add; main_dir];
        
    end
%     
%     %or pca idea
%     mat = cat(3, Events{:});
%     reshape_mat = reshape(mat, [size(mat, 1) * size(mat, 2),size(mat, 3)]);
%     pca_res    = pca(reshape_mat);
%     main_dir   = pca_res(:, ii)';
%     pac_to_add = [pac_to_add; main_dir];
    


    pac_to_add = pac_to_add' * 1;
    
    %add mean to every cell
    Events_with_pca = {};
    for data_i = 1:length(Events)

        Events_with_pca{data_i} = [Events{data_i}, pac_to_add];

    end


end

