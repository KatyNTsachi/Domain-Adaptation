function [c_data_for_classifier, c_description_for_data] = extractFeatures( events_cell,...
                                                                            events_names,...
                                                                            funcs,...
                                                                            funcs_names);
    
    data_counter = 1;
    for ii = 1 : length(events_cell)
    
        %-- Covarience Correlation or Partial Correlation
        for func_idx = 1 : length(funcs)
            


            vectors_of_features = funcs{func_idx}(events_cell{ii});
            v_classifier = prepareForClassification( vectors_of_features , false);
              
            description_of_classifier_and_fetures = funcs_names{func_idx} + events_names{ii};
            
            %the return data
            c_data_for_classifier{data_counter} =  v_classifier;
            c_description_for_data{data_counter}  = description_of_classifier_and_fetures;
            
            data_counter = data_counter + 1;
            
        end 

    end

end

