function [ c_combined_data, c_combined_description ] = combineThreeCellArray(   c_data_for_classifier, c_description_for_data,...
                                                                                c_short_classifier   , c_short_classifier_description,...
                                                                                c_combine_data       , c_description )

    c_combined_cellarray   = {};
    c_combined_description = {};
    idx = 1;

    for ii = 1:length(c_data_for_classifier)
        c_combined_data{idx}        = c_data_for_classifier{ii};
        c_combined_description{idx} = c_description_for_data{ii};
        idx = idx + 1;
    end
    
    for ii = 1:length(c_short_classifier)
        c_combined_data{idx}        = c_short_classifier{ii};
        c_combined_description{idx} = c_short_classifier_description{ii};
        idx = idx + 1;
    end

    for ii = 1:length(c_combine_data)
        c_combined_data{idx}        = c_combine_data{ii};
        c_combined_description{idx} = c_description{ii};
        idx = idx + 1;
    end
  
end

 