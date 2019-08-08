close all
clear
addpath("./functions");
%%
NUM_OF_DATA = 5;
table_to_show = [];
table_to_show = [table_to_show; [   ...
                                    "subject"                        ,...
                                    "session"                        ,...
                                    "validationIteration"            ,...
                                    "regular"                        ,...
                                    "mean"                           ,...
                                    "two mean"                       ,...                                    
                                    "mean diff"                      ,...                                    
                                    "PCA mean"                       ,...
                                ]
                ];

%%


%% prepare for calc
subjects = 1:7;
session = 1:8;

for subject = subjects
    
    for sess = session

%         [Events, vClass]  = getCVEPEvents(subject, sess);
        [Events, vClass]  = getERPEvents(subject, sess);

        EventsMat         = cell2mat(Events);

        n_time     = size(Events{1}, 1);
        n_channels = size(Events{1}, 2);

        EventsMat = reshape(EventsMat, n_time, n_channels, [] );
        
        repetitions = 10;
        test_presentage = 0.3;
        
        %% each repetition we permute and take the first part, here we get the indices...
        % of the first part of the permutation
        indices_of_positive = find(vClass~=1);
        indices_of_negative = find(vClass==1);  
        p_test_end = ceil( test_presentage * length(indices_of_positive) );
        n_test_end = ceil( test_presentage * length(indices_of_negative) );
                
        for ii = 1:repetitions
            %permute
            N = size(vClass,1);
            tmp_res = zeros(NUM_OF_DATA, 1);
                      
            % shafel positive and negative
            p_positive = randperm(length(indices_of_positive));
            p_negative = randperm(length(indices_of_negative)); 
            
            indices_of_positive = indices_of_positive(p_positive);
            indices_of_negative = indices_of_negative(p_negative);
            
            % get indices of train and test
            p_test           =  [indices_of_positive(1:p_test_end)    ; indices_of_negative(1:n_test_end)    ];
            p_train          =  [indices_of_positive(p_test_end+1:end); indices_of_negative(n_test_end+1:end)];
            
            % devide events mat to train and test
            EventsMat_train = EventsMat(:, :, p_train);
            EventsMat_test  = EventsMat(:, :, p_test);

            vClass_train = vClass(p_train);
            vClass_test  = vClass(p_test);

            % put events mats back to cell array
            EventsMat_train = reshape(EventsMat_train, n_time, [] );
            EventsMat_test  = reshape(EventsMat_test , n_time, [] );

            rowDest_train =  n_channels * ones(size(p_train));
            rowDest_test  =  n_channels * ones(size(p_test));

            Events_train = mat2cell(EventsMat_train, n_time, rowDest_train);
            Events_test  = mat2cell(EventsMat_test , n_time,  rowDest_test);



            %% extract relevant classes
            class_1 = 1;
            class_2 = 2;

            good_idx     = vClass_train == class_1 | vClass_train == class_2;
            Events_train = Events_train( good_idx(:) );
            vClass_train = vClass_train(good_idx);

            good_idx     = vClass_test == class_1 | vClass_test == class_2;
            Events_test  = Events_test( good_idx(:) );
            vClass_test  = vClass_test(good_idx);
            %% add the average

            [Events_train_with_mean_difference,...
             Events_test_with_mean_difference] = addDiffrenceAverageOldDataTest(    Events_train,...
                                                                                    Events_test,...
                                                                                    vClass_train);  
                                                                                
            [Events_train_with_mean,...
             Events_test_with_mean] =    addAverageTest(    Events_train,...
                                                            Events_test,...
                                                            vClass_train); 
            [Events_train_with_two_mean,...
             Events_test_with_two_mean] =    addTwoAverageTest( Events_train,...
                                                                Events_test,...
                                                                vClass_train); 

            [Events_train_with_PCA_mean,...
             Events_test_with_PCA_mean] = addPCAAverageTest( Events_train, Events_test);   
                                                                
                                                                

                                                                                                                               
                                                                                        
            %% doing covariance correlation and partial correlation
            c_data_for_classifier  = {};
            c_description_for_data = {};

            funcs       = { @covFromCellArrayOfEvents};
            funcs_names = { "Covariance"};

           
            tmp_description  = "subject " + num2str(subject) + "    session " + num2str(sess) + "    k(not relevant) " + num2str(ii);
            events_names    = {
                                "Events train "                     + tmp_description,...
                                "Events test "                      + tmp_description,...
                                "Events train mean"                 + tmp_description,...
                                "Events test mean"                  + tmp_description,...
                                "Events train two mean"             + tmp_description,...
                                "Events test two mean"              + tmp_description,...
                                "Events train with mean diff "      + tmp_description,...
                                "Events test with  mean diff "      + tmp_description,...
                                "Events train with PCA"             + tmp_description,...
                                "Events test with PCA"              + tmp_description,...
                              };

            events_cell     = { 
                                Events_train                            ,...
                                Events_test                             ,...
                                Events_train_with_mean                  ,...
                                Events_test_with_mean                   ,...
                                Events_train_with_two_mean              ,...
                                Events_test_with_two_mean               ,...                                
                                Events_train_with_mean_difference       ,...
                                Events_test_with_mean_difference        ,...
                                Events_train_with_PCA_mean              ,...
                                Events_test_with_PCA_mean               ,...
                              };

                          
                          
                          
            %set base functions
            all_base_functions = ["linear"];

            %extract the features
            [c_data_for_classifier, c_description_for_data] = extractFeatures( events_cell, events_names,...
                                                                                 funcs, funcs_names );



            %% just run svm
            tmp_res = zeros(NUM_OF_DATA, 1);
            
            for res_idx = 1 : NUM_OF_DATA

                tmp_res(res_idx) = calPrecision(...
                                                    c_data_for_classifier{(res_idx-1)*2+1},...
                                                    c_data_for_classifier{(res_idx-1)*2+2},...
                                                    vClass_train                          ,...
                                                    vClass_test                            ...
                                                );          
            end


            tmp_str = [];
        
            for tmp_str_num = 1 : NUM_OF_DATA

                tmp_str = [ string(tmp_str) ,...
                            num2str(tmp_res(tmp_str_num))];

            end

            table_to_show = [table_to_show; [   ...
                                                num2str(subject),...
                                                num2str(sess)   ,...
                                                num2str(ii)     ,...
                                                tmp_str                                        
                                            ]
                            ];

            
            
        end    
   
    end
    
end

save pca_results_ERP_dataset table_to_show;



%%

function [pre] = calPrecision(X, X_test,y, y_test)
    
    t             = templateSVM('Standardize', false, 'KernelFunction', 'linear');
    Mdl           = fitcecoc( X', ...
                              y, ...
                              'Learners', t);
    predicted_label = predict( Mdl, X_test' );
    
    tp  = sum((y_test == 2) & (predicted_label == 2));
    fp  = sum((y_test == 1) & (predicted_label == 2));

    if tp + fp ~= 0 
        pre = tp / (tp + fp);
    else
       pre = 0;
    end
end



