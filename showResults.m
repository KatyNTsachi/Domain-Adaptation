close all;
clear;
clc;
addpath("./functions");

%% - load data
results_path = "./results/pca_results_ERP_dataset.mat";
load(results_path);
data = table_to_show;

%% - put in table
subject         = data(2:end, 1);
session         = data(2:end, 2);
validation      = data(2:end, 3);
original_data   = data(2:end, 4);
mean_data       = data(2:end, 5);
pca_data        = data(2:end, 6);

T = table( subject, session, validation, original_data, mean_data, pca_data);
disp(T);

%% -show on graph

subject_num       = str2num( char(subject) );
session_num       = str2num( char(session) );
validation_num    = str2num( char(validation) );
original_data_num = str2num( char(original_data) );
mean_data_num     = str2num( char(mean_data) );
pca_data_num      = str2num( char(pca_data) );

%- arrange 
all_res    = {};
all_res{1} = original_data_num;
all_res{2} = mean_data_num;
all_res{3} = pca_data_num;
%% -calc var
num_of_subjects = size( unique( subject_num ), 1 );

all_var  = zeros( 3, num_of_subjects);
all_mean = zeros( 3, num_of_subjects);

unique_subjects = unique( subject_num );
for data_type = 1:3
    
    for tmp_subject_num = 1 : length(unique_subjects)
        
        %- get relevant idx
        relevant_idx = find( subject_num == unique_subjects(tmp_subject_num) );
        
        %- get televant data 
        tmp_data = all_res{data_type};
        
        %- calc var
        tmp_var  = var( tmp_data( relevant_idx ) );
        tmp_mean = mean( tmp_data( relevant_idx ) );
        %- update table
        all_var( data_type, tmp_subject_num)  = tmp_var;
        all_mean( data_type, tmp_subject_num) = tmp_mean;
    end
    
end

%%

figure();
errorbar(   1:num_of_subjects                   , all_mean(1, :)   ,...
            all_var(1, :)                       , -all_var(1, :)   ,...
            'Color'                             , 'b'              ,...
            'MarkerEdgeColor'                   , 'k');
hold on;
errorbar(   1:num_of_subjects                   , all_mean(2, :)   ,...
            all_var(2, :)                       , -all_var(2, :)   ,...
            'Color'                             , 'r'              ,...
            'MarkerEdgeColor'                   , 'k');
hold on;
errorbar(   1:num_of_subjects                   , all_mean(3, :)   ,...
            all_var(3, :)                       , -all_var(3, :)   ,...
            'Color'                             , 'g'              ,...
            'MarkerEdgeColor'                   , 'k');

legend('Original', 'With mean', 'With PCA');
title('Precision of dataset 1');
xlabel('Subject');
ylabel('Precision');




