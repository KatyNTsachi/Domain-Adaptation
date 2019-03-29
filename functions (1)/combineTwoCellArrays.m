function [ c_combined_data ] = combineTwoCellArrays( c_a, c_b)

    c_combined_cellarray   = {};
    idx = 1;

    for ii = 1:length(c_a)
        c_combined_data{idx} = c_a{ii};
        idx = idx + 1;
    end
    
    for ii = 1:length(c_b)
        c_combined_data{idx} = c_b{ii};
        idx = idx + 1;
    end

end

 