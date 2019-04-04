function [Events] = splitInTime(Events, window_size)
    %SPLITINTIME Summary of this function goes here
    %   Detailed explanation goes here
    
    for ii = 1:length(Events)
        %Events{ii} = reshape(Events{ii}, window_size, []);
        tmp = Events{ii};
        start_idx = 1;
        end_idx   = window_size;
        new_mat   = [];
        while start_idx < size(tmp,1)
            if end_idx > size(tmp,1)
                end_idx = size(tmp,1)
            end
            new_mat = [new_mat , tmp( start_idx:end_idx ,:) ];
            start_idx = start_idx + window_size;
            end_idx   = end_idx + window_size;
        end
        Events{ii} = new_mat;
    end
    
end

