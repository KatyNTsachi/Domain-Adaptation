function [ v_short_classifier, bad_features ] = AddImportantDimensions( v_classifier, vClass, epsilon)

    base_func          = "linear";
    N                  = 1;
    ii                 = 0;
    v_short_classifier = []; % v_classifier;
    bad_features       = 1:size(v_classifier,1);
    
    %-- calc base loss
    prev_sum_of_loss = size(vClass, 1);

    %-- each iter add one feature
    while( size( v_short_classifier, 1 ) <  size(v_classifier, 1) )
        tic;
        ii              = ii+1;
        break_the_while = true;
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

            if sum_of_loss < prev_sum_of_loss + epsilon
                feature_to_add            = ii_feature;
                prev_sum_of_loss          = sum_of_loss;
                break_the_while           = false;
                
            end

        end
        
        if break_the_while == true
            break;
        else
            v_short_classifier              = [v_short_classifier; v_classifier(feature_to_add, :)];
            bad_features(feature_to_add)    = [];
            v_classifier(feature_to_add, :) = [];
        end    
        
        time  = toc;
        s_tmp = [   "iter: "+ num2str(ii) , "took: " + num2str(time/60) + " min" ,...
                    "loss is: " + num2str( prev_sum_of_loss / N ),"new size is: " + num2str( size( v_short_classifier, 1 ) ) ];
        
        disp(s_tmp)
    end   


end

 