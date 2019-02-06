function [ v_short_classifier, good_features ] = keepImportantDimensions2( v_classifier, vClass)

    base_func          = "linear";
    epsilon            = 0;
    N                  = 10;
    ii                 = 0;
    v_short_classifier = v_classifier;
    good_features      = 1:size(v_classifier,1);
    
    %-- calc base loss
    prev_sum_of_loss = 0;
    for jj = 1 : N

        s_tmp = showSvmResults(   v_short_classifier,...
                                  vClass,...
                                  "linear",...
                                  base_func ) ;
        prev_sum_of_loss = prev_sum_of_loss + str2num ( s_tmp(3) );

    end
    %-- each iter remove one feature
    %s_tmp = [];
    while( size( v_short_classifier, 1 ) > 1 )
        tic;
        ii              = ii+1;
        break_the_while = true;
        for ii_feature = 1:size( v_short_classifier, 1 )

            tmp_classifier                  = v_short_classifier;
            tmp_classifier( ii_feature, : ) = [];
            sum_of_loss                     = 0;

            for jj = 1 : N

                s_tmp = showSvmResults(   tmp_classifier,...
                                          vClass,...
                                          "linear",...
                                          base_func ) ;
                sum_of_loss = sum_of_loss + str2num ( s_tmp(3) );

            end

            if sum_of_loss <= prev_sum_of_loss + epsilon
                %good_features(ii_feature) = [];
                feature_to_remove         = ii_feature;
                prev_sum_of_loss          = sum_of_loss;
                %v_short_classifier        = tmp_classifier;
                break_the_while           = false;
                
            end

        end
        
        if break_the_while == true
            break;
        else
            good_features(feature_to_remove) = [];
            v_short_classifier( feature_to_remove, : ) = [];
        end    
        
        time  = toc;
        s_tmp = [   "iter: "+ num2str(ii) , "took: " + num2str(time/60) + " min" ,...
                    "loss is: " + num2str( prev_sum_of_loss / N ),"new size is: " + num2str( size( v_short_classifier, 1 ) ) ];
        
        disp(s_tmp)
    end   


end

 