function [ v_short_classifier, bad_features ] = AddImportantDimensions( v_classifier,...
                                                                        description,...
                                                                        vClass,...
                                                                        epsilon,...
                                                                        min_dim_number )
    

    file_name1 = "RD " + "v_short_classifier " + description; 
    file_path1 = "../data/" + file_name1 ;
    
    file_name2 = "RD " + "bad_features " + description; 
    file_path2 = "../data/" + file_name2 ;

    %-- if exists, load
    if exist( file_path1 + ".mat", 'file' ) && exist( file_path2 + ".mat", 'file' )
       
        tmp = load(  file_path1 + ".mat" );
        v_short_classifier = tmp.v_short_classifier;
        
        tmp = load(  file_path2 + ".mat" );
        bad_features = tmp.bad_features;
        
        return;
        
    end
    
    base_func          = "linear";
    N                  = 1;
    ii                 = 0;
    v_short_classifier = []; % v_classifier;
    bad_features       = 1:size(v_classifier,1);
    dims               = 0;
    
    %-- calc base loss
    prev_sum_of_loss = size(vClass, 1);

    %-- each iter add one feature
    while( size( v_short_classifier, 1 ) <  size(v_classifier, 1) )
        tic;
        ii                    = ii+1;
        add_another_feature   = false;
        curr_prev_sum_of_loss = N;
        
        for ii_feature = 1:size( v_classifier, 1 )

            tmp_classifier = [v_short_classifier; v_classifier(ii_feature, :)];
            sum_of_loss    = 0;
            
            for jj = 1 : N

                s_tmp = showSvmResultsAllTraining(    tmp_classifier,...
                                                      vClass,...
                                                      "linear",...
                                                      base_func ) ;
                                                  
                sum_of_loss = sum_of_loss + str2num ( s_tmp(3) );

            end
            
            % adding a feature improves loss
            if sum_of_loss < prev_sum_of_loss + epsilon 
                add_another_feature = true;
            end
            
            % choose best feature to add
            if sum_of_loss < curr_prev_sum_of_loss + epsilon
                feature_to_add        = ii_feature;
                curr_prev_sum_of_loss = sum_of_loss;
            end

        end
        
        if (add_another_feature == false) && ( dims > min_dim_number )
            
            break;
            
        else
            
            v_short_classifier              = [v_short_classifier; v_classifier(feature_to_add, :)];
            bad_features(feature_to_add)    = [];
            v_classifier(feature_to_add, :) = [];
            dims                            = dims + 1;
            prev_sum_of_loss                = curr_prev_sum_of_loss;
            
        end    
        
        time  = toc;
        s_tmp = [   "iter: "+ num2str(ii) , "took: " + num2str(time/60) + " min" ,...
                    "loss is: " + num2str( prev_sum_of_loss / N ),"new size is: " + num2str( size( v_short_classifier, 1 ) ) ];
        
        disp(s_tmp)
        
    end
    
    save( file_path1 + ".mat", 'v_short_classifier' );
    save( file_path2 + ".mat", 'bad_features' );
    
end

 