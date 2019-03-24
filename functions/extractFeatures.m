function [c_data_for_classifier, c_description_for_data] = extractFeatures( events_cell,...
                                                                            events_names,...
                                                                            funcs,...
                                                                            funcs_names,...
                                                                            vClass)
    
    data_counter = 1;
    for ii = 1 : length(events_cell)
    
        %-- Covarience Correlation or Partial Correlation
        for func_idx = 1 : length(funcs)
            
            %check if exists
            file_name = "EF " + func2str(funcs{func_idx}) + " " + events_names{ii}; 
            file_path = "../data/" + file_name ;
            
            %if exist( file_path + ".mat", 'file' )
            if false
                tmp          = load(  file_path + ".mat" );
                v_classifier = tmp.v_classifier;
                
            else 

                vectors_of_features = funcs{func_idx}(events_cell{ii});
                v_classifier = prepareForClassification( vectors_of_features );
              
%                 %if func2str( funcs{func_idx} ) == "covNoMean"
%                 a = [[1 0];[0 1]];
%                 b = ones( size(vectors_of_features,1) / 2 );
%                 mask = kron(a,b); 
%                 vec_mask = symetric2Vec(mask);
%                 v_classifier = 10 * v_classifier.*vec_mask;
%                 %end
                
            end

            %-- show
%             tsne_points = tsne(v_classifier');
%             figure;
%             scatter( tsne_points(:,1), tsne_points(:,2),...
%                      50, vClass, 'Fill',...
%                      'MarkerEdgeColor', 'k');


            description_of_classifier_and_fetures = funcs_names{func_idx} + events_names{ii};
            %title(description_of_classifier_and_fetures);
            
            %the return data
            c_data_for_classifier{data_counter} =  v_classifier;
            c_description_for_data{data_counter}  = description_of_classifier_and_fetures;
            
            data_counter = data_counter + 1;
            
            %save the calculation
            if exist( file_path + ".mat", 'file' ) ~= 2
                save( file_path + ".mat", 'v_classifier' );
            end
        end 

    end

end

