function [table_to_show] = calcSvmLossAllTraining(  c_data_for_classifier, vClass,...
                                                    description_for_data, all_base_functions,...
                                                    table_to_show )
    
    for ii = 1 : length(c_data_for_classifier)
    
        %-- SVM Kernal
        for base_func = all_base_functions

            table_to_show = [ table_to_show;
                              showSvmResultsAllTraining(  c_data_for_classifier{ii},...
                                                          vClass,...
                                                          description_for_data(ii),...
                                                          base_func ) ];

        end
    end
end

