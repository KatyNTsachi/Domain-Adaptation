close all
clear

%% prepare for calc 
day               = 1;
subject           = 8;
[Events, vClass]  = GetEvents( subject, day );
N                 = length(Events);

%-- Create Forier Events 
F_Events{N} = [];
Fourier_and_Time = {};
parfor ii = 1 : N
    F_Events{ii} = abs( fft( Events{ii} ) );
end

funcs       = { @covFromCellArrayOfEvents, @correlationFromCellArrayOfEvents, @partialCorrelationFromCellArrayOfEvents };
funcs_names = { "Covariance"             , "Correlation"                    , "Partial Correlation"  };


events_names    = {" on time series", " on Furier transform"};
events_cell     = { Events          , F_Events              };
table_to_show   = [];
titles          = { 'feature', 'baseFunction', 'averageLoss' };
%%
%-- Fourier or not
for ii = 1 : length(events_cell)
    
    %-- Covarience Correlation or Partial Correlation
    for func_idx = 1 : length(funcs)
        
        vectors_of_features = funcs{func_idx}(events_cell{ii});
        v_classifier = prepareForClassification( vectors_of_features );
        
        %-- show
        tsne_points = tsne(v_classifier');
        figure;
        scatter( tsne_points(:,1), tsne_points(:,2),...
                 50, vClass, 'Fill',...
                 'MarkerEdgeColor', 'k');
             
             
        description_of_classifier_and_fetures = funcs_names{func_idx} + events_names{ii};
        title(description_of_classifier_and_fetures);

        
        
        %-- SVM Kernal
        for base_func = ["linear", "gaussian", "polynomial"]
            
            
  
            table_to_show = [ table_to_show;
                              showSvmResults( v_classifier,...
                                              vClass,...
                                              description_of_classifier_and_fetures,...
                                              base_func ) ];
                                                                  
            table_to_show = [ table_to_show; 
                                showSvmResultsNoDiag( v_classifier,...
                                                      vClass,...
                                                      description_of_classifier_and_fetures,...
                                                      base_func,...
                                                      size(vectors_of_features,1)) ];
        end
    end 
    
end

%% time
table_to_show = [];
m_features1   = funcs{1}(events_cell{1});
v_classifier1 = prepareForClassification( m_features1 );

tsne_points1  = tsne(v_classifier1');
figure;
scatter( tsne_points1(:,1), tsne_points1(:,2),...
         50, vClass, 'Fill',...
         'MarkerEdgeColor', 'k');
description_of_classifier_and_fetures = "time";
title(description_of_classifier_and_fetures);

%--clasification
table_to_show = [ table_to_show;
                              showSvmResults( v_classifier1,...
                                              vClass,...
                                              description_of_classifier_and_fetures,...
                                              base_func ) ];
                                          
                                       
%% fourier

m_features2 = funcs{1}(events_cell{2});
v_classifier2 = prepareForClassification( m_features2 );

tsne_points2 = tsne(v_classifier2');
figure;
scatter( tsne_points2(:,1), tsne_points2(:,2),...
         50, vClass, 'Fill',...
         'MarkerEdgeColor', 'k');
description_of_classifier_and_fetures = "fourier";
title(description_of_classifier_and_fetures);

%--clasification
table_to_show = [ table_to_show;
                              showSvmResults( v_classifier2,...
                                              vClass,...
                                              description_of_classifier_and_fetures,...
                                              base_func ) ];

%% combine time and fourier

v_classifier = [v_classifier1; v_classifier2];
tsne_points = tsne(v_classifier');

%-- show
figure;
scatter( tsne_points(:,1), tsne_points(:,2),...
         50, vClass, 'Fill',...
         'MarkerEdgeColor', 'k');
description_of_classifier_and_fetures = "time + fourier searies with cov";
title(description_of_classifier_and_fetures);

%--clasification
table_to_show = [ table_to_show;
                              showSvmResults( v_classifier,...
                                              vClass,...
                                              description_of_classifier_and_fetures,...
                                              base_func ) ];

%%

%--show table

T                          = table( table_to_show(:,1),...
                                    table_to_show(:,2),...
                                    table_to_show(:,3) );
T.Properties.VariableNames = titles
%%
%% -------------------------------------------------------------------------------------------------------------------------------
%% -------------------------------------------------------------------------------------------------------------------------------
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
     

%%

clc
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
random        = [X; 10 * rand(5,100) ] ;
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

[ new_random, goot_fe ] = keepImportantDimensions( random, x_class );