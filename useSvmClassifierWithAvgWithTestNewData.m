close all
clear
addpath("./functions");
addpath("./functions/npy");
addpath("./functions/clustering");



table_to_show = [];
table_to_show = [table_to_show; [   ...
                                    "description"                    ,...
                                    "regular"                        ,...
                                    "with mean"                      ,...                                    
                                    "with two mean"                  ,...
                                    "with mean diff"                 ,...
                                    "with cluster mean diff"         ,...
                                    "with cluster mean diff full GMM",...
                                    "with PCA mean"                  ,...
                                    "with PCA and GMM mean"          ,...

                                ]
                ];

%%


%% prepare for calc
NUM_OF_DATA = 8;
subjects = 1:7;
session = 1:8;

for subject = subjects
    
    for sess = session
        
        [Events, vClass]  = getERPEvents(subject, sess);
        EventsMat         = cell2mat(Events);

        n_time     = size(Events{1}, 1);
        n_channels = size(Events{1}, 2);

        EventsMat         = reshape(EventsMat, n_time, n_channels, [] );

        %permute
        N = size(vClass,1);
        p = randperm(N);
        tmp_res = zeros(NUM_OF_DATA, 1);
        k = 10;
        test_size = int32(linspace(1, N, k+1 ));
        for ii = 1:k

            test_start_i = test_size(ii);
            test_end_i   = test_size(ii + 1);

            if test_start_i == 1
                p_train = p(test_end_i + 1 : end);
            elseif  test_end_i == N
                p_train = p(1 : test_start_i - 1);
            else 
                p_train = [p(1 : test_start_i - 1), p(test_end_i + 1 : end)];
            end
            p_test  =  p(test_start_i : test_end_i);

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

            [Events_train_with_mean, Events_test_with_mean] = addAverageTest( Events_train,...
                                                                              Events_test,...
                                                                              vClass_train);
                                                                          
                                                                          
                                                                          
            [Events_train_with_two_mean, Events_test_with_two_mean] = addTwoAverageTest(    Events_train,...
                                                                                            Events_test,...
                                                                                            vClass_train);


            [Events_train_with_mean_difference,...
             Events_test_with_mean_difference] = addDiffrenceAverageOldDataTest(    Events_train,...
                                                                                    Events_test,...
                                                                                    vClass_train);  

            [Events_train_with_cluster_difference,...
             Events_test_with_cluster_difference] = addEstimatedDiffrenceAverageOldDataTest(Events_train,...
                                                                                            Events_test ,...
                                                                                            vClass_train);  

            [Events_train_with_cluster_differenceFULL,...
             Events_test_with_cluster_differenceFULL] = addEstimatedDiffrenceAverageOldDataTestFullGMM( Events_train,...
                                                                                                        Events_test ,...
                                                                                                        vClass_train);  

            [Events_train_with_PCA_mean,...
             Events_test_with_PCA_mean] = addPCAAverageOldDataTest( Events_train,...
                                                                    Events_test ,...
                                                                    vClass_train);   
                                                                
                                                                
            [Events_train_with_PCA_GMM_mean,...
             Events_test_with_PCA_GMM_mean] = addPCAGMMAverageOldDataTest(  Events_train,...
                                                                            Events_test ,...
                                                                            vClass_train);   

                                                                                                                               
                                                                                        
            %% doing covariance correlation and partial correlation
            c_data_for_classifier  = {};
            c_description_for_data = {};

            funcs       = { @covFromCellArrayOfEvents};
            funcs_names = { "Covariance"};

           
            tmp_description  = "subject " + num2str(subject) + "    session " + num2str(sess) + "    k(not relevant) " + num2str(ii);
            events_names    = {
                                "Events train "                     + tmp_description,...
                                "Events test "                      + tmp_description,...
                                "Events train with mean "           + tmp_description,...
                                "Events test with  mean "           + tmp_description,...
                                "Events train with two mean "       + tmp_description,...
                                "Events test with two mean "        + tmp_description,...
                                "Events train with mean difference" + tmp_description,...
                                "Events test with mean difference"  + tmp_description,...
                                "Events train cluster"              + tmp_description,...
                                "Events test  cluster"              + tmp_description,...
                                "Events train cluster FULL"         + tmp_description,...
                                "Events test  cluster FULL"         + tmp_description,...
                                "Events train with PCA mean"        + tmp_description,...
                                "Events test with PCA mean"         + tmp_description,...
                                "Events train with PCA GMM mean"    + tmp_description,...
                                "Events test with PCA GMM mean"     + tmp_description,...
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
                                Events_train_with_cluster_difference    ,...
                                Events_test_with_cluster_difference     ,...
                                Events_train_with_cluster_differenceFULL,...
                                Events_test_with_cluster_differenceFULL ,...
                                Events_train_with_PCA_mean              ,...
                                Events_test_with_PCA_mean               ,...
                                Events_train_with_PCA_GMM_mean          ,...
                                Events_test_with_PCA_GMM_mean           ,...                                
                              };

            %set base functions
            all_base_functions = ["linear"];

            %extract the features
            [c_data_for_classifier, c_description_for_data] = extractFeatures( events_cell, events_names,...
                                                                                 funcs, funcs_names, vClass );



            %% just run svm

            for res_idx = 1 : NUM_OF_DATA
         
                tmp_res(res_idx) = tmp_res(res_idx) + calPrecision(...
                                                                    c_data_for_classifier{(res_idx-1)*2+1},...
                                                                    c_data_for_classifier{(res_idx-1)*2+2},...
                                                                    vClass_train                          ,...
                                                                    vClass_test                            ...
                                                                    );          
            end




            
            
            
        end
        
        tmp_str = [];
        
        for tmp_str_num = 1 : NUM_OF_DATA
        
            tmp_str = [ string(tmp_str) ,...
                        num2str(tmp_res(tmp_str_num)/k)];
            
        end
        
        table_to_show = [table_to_show; [   ...
                                            "subject: " + num2str(subject) + "session: " + num2str(sess),...
                                            tmp_str                                        
                                        ]
                        ]
    end
end

disp(table_to_show);



%%

function [pre] = calPrecision(X, X_test,y, y_test)
    
    t             = templateSVM('Standardize', false, 'KernelFunction', 'linear');
    Mdl           = fitcecoc( X', ...
                              y, ...
                              'Learners', t);
    predicted_label = predict( Mdl, X_test' );

    tp  = sum((y_test == 2) & (predicted_label == 2));
    fp  = sum((y_test == 1) & (predicted_label == 2));
    pre = tp / (tp + fp);

end



