close all
clear

%% prepare for calc 
day               = 1;
subject           = 8;
[Events, vClass]  = GetEvents( subject, day );
N                 = length(Events);
%-- Create STFT Events
STFTEvents            = getSTFTEvents(Events, vClass);
STFTEvents_whole_time = getSTFTEventsWholeTime(Events, vClass);
%-- Create Forier Events 
parfor ii = 1 : N
    F_Events{ii} = abs( fft( Events{ii} ) );
end

%% preprocessing - dimentionality reduction
acc = 0.99;
[pca_reduce_data_Events               , pca_mat1] = pcaReduceData( Events               , acc, "EventsAfterPca");
[pca_reduce_data_STFTEvents           , pca_mat2] = pcaReduceData( STFTEvents           , acc, "STFTEventsAfterPca");
[pca_reduce_data_STFTEvents_whole_time, pca_mat3] = pcaReduceData( STFTEvents_whole_time, acc, "STFTEvents_whole_timeAfterPca" );
[pca_reduce_data_F_Events             , pca_mat4] = pcaReduceData( F_Events             , acc, "F_EventsAfterPca" );

%% preprocessing - add more features

extended_pca_reduce_data_Events                = extendData(pca_reduce_data_Events);
extended_pca_reduce_data_STFTEvents            = extendData(pca_reduce_data_STFTEvents);
extended_pca_reduce_data_STFTEvents_whole_time = extendData(pca_reduce_data_STFTEvents_whole_time);
extended_pca_reduce_data_F_Events              = extendData(pca_reduce_data_F_Events);


%% doing covariance correlation and partial correlation

% funcs       = { @covFromCellArrayOfEvents, @correlationFromCellArrayOfEvents, @partialCorrelationFromCellArrayOfEvents };
% funcs_names = { "Covariance"             , "Correlation"                    , "Partial Correlation"  };
funcs       = { @covFromCellArrayOfEvents};
funcs_names = { "Covariance"};

% events_names    = {"on time series"                                   , "on STFT transform",...
%                    "on STFTEvents whole_time"                         , "F Events",...
%                    "on pca_reduce data_Events"                        , "pca reduce data STFTEvents",...
%                    "on pca_reduce data STFTEvents whole time"         , "pca reduce data F Events",...
%                    "on extended pca reduce data Events"               , "on extended pca reduce data STFTEvents",...
%                    "on extended pca reduce data STFTEvents whole time", "on extended pca reduce data F Events"};

% events_cell     = { Events                                         , STFTEvents,...
%                     STFTEvents_whole_time                          , F_Events,...
%                     pca_reduce_data_Events                         , pca_reduce_data_STFTEvents,...
%                     pca_reduce_data_STFTEvents_whole_time          , pca_reduce_data_F_Events,...
%                     extended_pca_reduce_data_Events                , extended_pca_reduce_data_STFTEvents,...
%                     extended_pca_reduce_data_STFTEvents_whole_time ,extended_pca_reduce_data_F_Events};
events_names    = {"on time series"                                   , "on STFT transform",...
                   "on extended pca reduce data Events"            };

events_cell     = { Events                                         , STFTEvents,...
                    extended_pca_reduce_data_Events                };



%set base functions
% all_base_functions = ["linear", "gaussian", "polynomial"];
all_base_functions = ["linear"];

%extract the features
[c_data_for_classifier, c_description_for_data] = extractFeatures( events_cell, events_names,...
                                                                   funcs, funcs_names, vClass)

%% add more data
% c_data_for_classifier{3}  = [c_data_for_classifier{1}; c_data_for_classifier{2}];
% c_description_for_data{3} = "time and furier";

%% preprocessing - dimentionality reduction
[ v_short_classifier, good_features ] = AddImportantDimensions( c_data_for_classifier{1}, vClass);
                   















%% run svm on all training
%get svm loss for the funcs and input the we set up here
table_to_show = [];
table_to_show = calcSvmLossAllTraining( c_data_for_classifier, vClass,...
                             c_description_for_data, all_base_functions,...
                             table_to_show)
                         
%% just run svm
%get svm loss for the funcs and input the we set up here
table_to_show = [];
table_to_show = calcSvmLoss( c_data_for_classifier, vClass,...
                             c_description_for_data, all_base_functions,...
                             table_to_show)
%%

% for ii=1:length(Events)
%     a=[a,Events{ii}(:) ];
%     
%     
% end
% 
% b=showSvmResults( a,...
%                 vClass,...
%                 "raw data",...
%                 "linear" ) ;


%% -------------------------------------------------------------------------------------------------------------------------------
%% -------------------------------------------------------------------------------------------------------------------------------
%% -------------------------------------------------------------------------------------------------------------------------------
%% -------------------------------------------------------------------------------------------------------------------------------
%% -------------------------------------------------------------------------------------------------------------------------------

%% testing


table_to_show = [];
base_func     = "linear";
X             = double( rand(1, 100) > 0.5 );
random        = [X; 10 * rand(100,100) ] ;
tsne_points1  = tsne(random');
x_class       = X;
%-- show
figure;
scatter( tsne_points1( :, 1 ), tsne_points1( :, 2 ),...
         50, x_class, 'Fill',...
         'MarkerEdgeColor', 'k');
description_of_classifier_and_fetures = "random";
title(description_of_classifier_and_fetures);

%--do calsification
table_to_show = [ table_to_show;
                              showSvmResults( random,...
                                              x_class,...
                                              description_of_classifier_and_fetures,...
                                              base_func ) ];
T                          = table( table_to_show(:,1),...
                                    table_to_show(:,2),...
                                    table_to_show(:,3) );
T.Properties.VariableNames = titles
%% time - pca check

m_features1 = funcs{1}(events_cell{1});
v_classifier1 = prepareForClassification( m_features1 );
pca_top1 = pca(v_classifier1');
v_top_featurs1 = (v_classifier1' * pca_top1)';

tsne_points = tsne(v_top_featurs1');
figure;
scatter( tsne_points(:,1), tsne_points(:,2),...
         50, vClass, 'Fill',...
         'MarkerEdgeColor', 'k');
base_func = "linear";
N = 10;
table_to_show = [];
for ii = 1:1:21
    sum_of_loss        = 0; 
    v_top_featurs_part = v_top_featurs1(1:ii, :);
    
    for jj = 1 : N
        s_tmp = showSvmResults(   v_top_featurs_part,...
                                  vClass,...
                                  "linear",...
                                  base_func ) ;
        sum_of_loss = sum_of_loss + str2num ( s_tmp(3) );
    end                                          
    description_of_classifier_and_fetures = [ "pca Time" , num2str(ii) , sum_of_loss/N ];
    table_to_show = [ table_to_show; description_of_classifier_and_fetures ]                                          
end   

    
%% Furier - pca check

m_features2 = funcs{1}(events_cell{2});
v_classifier2 = prepareForClassification( m_features2 );
pca_top2 = pca(v_classifier2');
v_top_featurs2 = (v_classifier2' * pca_top2)';

tsne_points = tsne(v_top_featurs2');
figure;
scatter( tsne_points(:,1), tsne_points(:,2),...
         50, vClass, 'Fill',...
         'MarkerEdgeColor', 'k');
base_func = "linear";
N = 10;
table_to_show = [];
for ii = 1:1:25
    sum_of_loss        = 0;
    v_top_featurs_part = v_top_featurs2(1:ii, :);
    
    for jj = 1 : N
        s_tmp = showSvmResults(   v_top_featurs_part,...
                                  vClass,...
                                  "linear",...
                                  base_func ) ;
        sum_of_loss = sum_of_loss + str2num ( s_tmp(3) );
    end                                          
    description_of_classifier_and_fetures = [ "pca Fourier" , num2str(ii) , sum_of_loss/N ];
    table_to_show = [ table_to_show; description_of_classifier_and_fetures ]                                          
end   


    
%% 
% combine pca of Furier and time 
table_to_show                 = [];

v_time_top_featurs            = v_top_featurs1(1:253 , :);
v_Furier_top_featurs          = v_top_featurs2(1:3, :);
base_func                     = "linear";
v_top_featurs_Furier_and_time = [v_Furier_top_featurs; v_time_top_featurs];

description_of_classifier_and_fetures = "pca time and Furier combined";
    table_to_show = [ table_to_show;
                      showSvmResults( v_top_featurs_Furier_and_time,...
                                      vClass,...
                                      description_of_classifier_and_fetures,...
                                      base_func ) ]
%% knn


m_features1  = funcs{1}(events_cell{1});
v_classifier = prepareForClassification( m_features1 );

m_features1  = reshape(m_features1, [], 288);
s_result     = [];
for k = 1:3:30
    
    
    %estimated distance
    KNNMdl       = fitcknn( v_classifier', vClass ,...
                            'NumNeighbors', k,...
                            'KFold', 10, ...
                            'Standardize',false);
    avr_loss     = kfoldLoss( KNNMdl );
    s_tmp        = [ "estimated distance k is: " , num2str( k ) , "    error: " , num2str( avr_loss ) ];
    s_result     = [ s_result; s_tmp ];
    
    %original distance
    KNNMdl       = fitcknn( m_features1', vClass ,...
                            'Distance', @calDistanceBetweenTwoCovVec,...
                            'NumNeighbors', k,...
                            'KFold', 10, ...
                            'Standardize',false);
    avr_loss     = kfoldLoss( KNNMdl );
    s_tmp        = [ "###original distance k is: " , num2str( k ) , "    error: " , num2str( avr_loss ) ] ;
    s_result     = [ s_result; s_tmp ];

end

s_result
                            
%% time searies and time square series and pca

table_to_show  = [];
N              = size(events_cell{1},2);
new_event_cell = {};
for ii = 1 : N
    tmp = events_cell{1}(ii);
    new_event_cell{ii} = [ tmp{1}, tmp{1}.^2 ];
end


m_features    = funcs{1}(new_event_cell);
v_classifier  = prepareForClassification( m_features );
base_func     = "linear";
% tsne_points1  = tsne(v_classifier1');
% figure;
% scatter( tsne_points1(:,1), tsne_points1(:,2),...
%          50, vClass, 'Fill',...
%          'MarkerEdgeColor', 'k');
% description_of_classifier_and_fetures = "time";
% title(description_of_classifier_and_fetures);

%--clasification
pca_top = pca(v_classifier');
v_top_featurs = (v_classifier' * pca_top)';

N             = 10;
table_to_show = [];

for ii = 240:5:280
    sum_of_loss        = 0;
    v_top_featurs_part = v_top_featurs(1:ii, :);
    
    for jj = 1 : N
        s_tmp = showSvmResults(   v_top_featurs_part,...
                                  vClass,...
                                  "linear",...
                                  base_func ) ;
        sum_of_loss = sum_of_loss + str2num ( s_tmp(3) );
    end                                          
    description_of_classifier_and_fetures = [ "pca for time and sqare time" , num2str(ii) , sum_of_loss/N ];
    table_to_show                         = [ table_to_show; description_of_classifier_and_fetures ]                                          
end   

                              
               

%% reduce dimentinality by our technique
clc 
table_to_show  = [];
N              = size(events_cell{1},2);
new_event_cell = {};
for ii = 1 : N
    tmp = events_cell{1}(ii);
    new_event_cell{ii} = [ tmp{1}, tmp{1}.^2 ];
end

m_features    = funcs{1}(new_event_cell);
v_classifier  = prepareForClassification( m_features );
base_func     = "linear";
     

[v_new_classifier, good_features] = keepImportantDimensions( v_classifier, vClass );
save( "good_features", good_features );    
table_to_show = [ table_to_show;
                  showSvmResults( v_new_classifier,...
                                  vClass,...
                                  description_of_classifier_and_fetures,...
                                  base_func ) ];                              
table_to_show                     
                                                            


%% testing 2 
clc
table_to_show = [];
base_func     = "linear";
X             = double( rand(1, 100) > 0.5 );
random        = 10 * rand( 50, 100 );
random        = random + X;
random(1,:)   = X;
tsne_points1  = tsne(random');
x_class       = X;
%-- show
figure;
scatter( tsne_points1( :, 1 ), tsne_points1( :, 2 ),...
         50, x_class, 'Fill',...
         'MarkerEdgeColor', 'k');
description_of_classifier_and_fetures = "random";
title(description_of_classifier_and_fetures);

%--do calsification
table_to_show = [ table_to_show;
                  showSvmResults( random,...
                                  x_class,...
                                  description_of_classifier_and_fetures,...
                                  base_func ) ];
T  = table( table_to_show(:,1),...
            table_to_show(:,2),...
            table_to_show(:,3) )

[ new_random, goot_fe ] = keepImportantDimensions2( random, x_class );