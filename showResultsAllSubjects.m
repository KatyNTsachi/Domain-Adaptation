close all;
clear;
clc;
addpath("./functions");

%% - load data
% results_path = "./results/pca_results_CVRP_dataset.mat";
dir_path = "./results/all_subjects/";
mat = dir(dir_path + "*.mat");
data = [];
for q = 1:length(mat)
    load(dir_path+mat(q).name);
%     table_to_show()
    if q == 1
        data = table_to_show(1, :);
    end
    data = [data; table_to_show(2:end,:)];
    clearvars table_to_show;
end


%% - put in all subject table
subject1         = data(2:end, 1);
session1         = data(2:end, 2);

subject2         = data(2:end, 3);
session2         = data(2:end, 4);

original          = data(2:end, 5);
with_real_mean    = data(2:end, 6);
with_train_mean   = data(2:end, 7);
with_PCA          = data(2:end, 8);
with_sepatate_PCA = data(2:end, 9);

T = table( subject1, session1, subject2, session2, original, with_train_mean, with_real_mean, with_PCA, with_sepatate_PCA);
% disp(T);

%% -show on graph

subject1_num        = str2num( char(subject1) );
session1_num        = str2num( char(session1) );
subject2_num        = str2num( char(subject2) );
session2_num        = str2num( char(session2) );

original_num          = str2num( char(original) );
with_real_mean_num    = str2num( char(with_real_mean) );
with_train_mean_num   = str2num( char(with_train_mean) );
with_PCA_num          = str2num( char(with_PCA) );
with_sepatate_PCA_num = str2num( char(with_sepatate_PCA) );

%- arrange 
all_res    = {};
all_res{1} = original_num;
all_res{2} = with_real_mean_num;
all_res{3} = with_train_mean_num;
all_res{4} = with_PCA_num;
all_res{5} = with_sepatate_PCA_num;

%% -calc var
num_of_1_subjects = size( unique( subject1_num ), 1 );

all_var_all_subject  = zeros( 5, num_of_1_subjects);
all_mean_all_subject = zeros( 5, num_of_1_subjects);

all_var_all_session  = zeros( 5, num_of_1_subjects);
all_mean_all_session = zeros( 5, num_of_1_subjects);

unique_1_subjects = unique( subject1_num );
for data_type = 1:5
    
    for tmp_subject_num = 1 : length(unique_1_subjects)
        
        %- get relevant idx
        relevant_idx_all_subject = find( subject1_num == unique_1_subjects(tmp_subject_num)...
        & subject2_num ~= unique_1_subjects(tmp_subject_num ));
    
        relevant_idx_all_session = find( subject1_num == unique_1_subjects(tmp_subject_num)...
        & subject2_num == unique_1_subjects(tmp_subject_num));
        
        %- get relevant data 
        tmp_data = all_res{data_type};
        
        %- calc var
        tmp_var_all_subject  = var( tmp_data( relevant_idx_all_subject ) );
        tmp_mean_all_subject = mean( tmp_data( relevant_idx_all_subject ) );
        
        tmp_var_all_session  = var( tmp_data( relevant_idx_all_session ) );
        tmp_mean_all_session = mean( tmp_data( relevant_idx_all_session ) );
        %- update table
        all_var_all_subject( data_type, tmp_subject_num)  = tmp_var_all_subject;
        all_mean_all_subject( data_type, tmp_subject_num) = tmp_mean_all_subject;
        
        all_var_all_session( data_type, tmp_subject_num)  = tmp_var_all_session;
        all_mean_all_session( data_type, tmp_subject_num) = tmp_mean_all_session;
    end
    
end

%% all subject
% all_res{1} = original_data_num;
% all_res{2} = mean_data_num;
% all_res{3} = two_mean_data_num;
% all_res{4} = mean_diff_data_num;
% all_res{5} = pca_data_num;

figure();
errorbar(   1:num_of_1_subjects                 , all_mean_all_subject(1, :)   ,...
            all_var_all_subject(1, :)           , -all_var_all_subject(1, :)   ,...
            'MarkerEdgeColor'                   , 'k'                          ,...
            'LineWidth'                         , 3.0);
hold on;
errorbar(   1:num_of_1_subjects                 , all_mean_all_subject(2, :)   ,...
            all_var_all_subject(2, :)           , -all_var_all_subject(2, :)   ,...
            'MarkerEdgeColor'                   , 'k'                          ,...
            'LineWidth'                         , 3.0);
hold on;
errorbar(   1:num_of_1_subjects                 , all_mean_all_subject(3, :)   ,...
            all_var_all_subject(3, :)           , -all_var_all_subject(3, :)   ,...
            'MarkerEdgeColor'                   , 'k'                          ,...
            'LineWidth'                         , 3.0);
hold on;
errorbar(   1:num_of_1_subjects                 , all_mean_all_subject(4, :)   ,...
            all_var_all_subject(4, :)           , -all_var_all_subject(4, :)   ,...
            'MarkerEdgeColor'                   , 'k'                          ,...
            'LineWidth'                         , 3.0);
hold on;
errorbar(    1:num_of_1_subjects                 , all_mean_all_subject(5, :) ,...
             all_var_all_subject(5, :)           , -all_var_all_subject(5, :) ,...
             'MarkerEdgeColor'                   , 'k'                        ,...
             'LineWidth'                         , 3.0);


legend('Original', 'With real mean', 'With train mean', 'With PCA', 'With separate PCA',  'FontSize', 20);
title('Average Precision of ERP between subjects', 'FontSize', 30);
xlabel('Subject', 'FontSize', 20);
ylabel('Precision', 'FontSize', 20);




%% all sessions
% all_res{1} = original_data_num;
% all_res{2} = mean_data_num;
% all_res{3} = two_mean_data_num;
% all_res{4} = mean_diff_data_num;
% all_res{5} = pca_data_num;

figure();
errorbar(   1:num_of_1_subjects                 , all_mean_all_session(1, :)   ,...
            all_var_all_session(1, :)           , -all_var_all_session(1, :)   ,...
            'MarkerEdgeColor'                   , 'k'                          ,...
            'LineWidth'                         , 3.0);
hold on;
errorbar(   1:num_of_1_subjects                 , all_mean_all_subject(2, :)   ,...
            all_var_all_session(2, :)           , -all_var_all_session(2, :)   ,...
            'MarkerEdgeColor'                   , 'k'                          ,...
            'LineWidth'                         , 3.0);
hold on;
errorbar(   1:num_of_1_subjects                 , all_mean_all_session(3, :)   ,...
            all_var_all_session(3, :)           , -all_var_all_session(3, :)   ,...
            'MarkerEdgeColor'                   , 'k'                          ,...
            'LineWidth'                         , 3.0);
hold on;
errorbar(   1:num_of_1_subjects                 , all_mean_all_session(4, :)   ,...
            all_var_all_session(4, :)           , -all_var_all_session(4, :)   ,...
            'MarkerEdgeColor'                   , 'k'                          ,...
            'LineWidth'                         , 3.0);
hold on;
errorbar(    1:num_of_1_subjects                 , all_mean_all_subject(5, :) ,...
             all_var_all_session(5, :)           , -all_var_all_session(5, :) ,...
             'MarkerEdgeColor'                   , 'k'                        ,...
             'LineWidth'                         , 3.0);


legend('Original', 'With real mean', 'With train mean', 'With PCA', 'With separate PCA',  'FontSize', 20);
title('Average Precision of ERP between sessions', 'FontSize', 30);
xlabel('Subject', 'FontSize', 20);
ylabel('Precision', 'FontSize', 20);




