close all;
clear;
clc;
addpath("./functions");

%% - load data
results_path = "./results/pca_results_ERP_dataset.mat";
% results_path = "./results/pca_results_CVRP_dataset.mat";
load(results_path);
data = table_to_show;

%% - put in table
subject         = data(2:end, 1);
session         = data(2:end, 2);
validation      = data(2:end, 3);
original_data   = data(2:end, 4);
mean_data       = data(2:end, 5);
two_mean_data   = data(2:end, 6);
mean_diff_data  = data(2:end, 7);
pca_data        = data(2:end, 8);

T = table( subject, session, validation, original_data, mean_data, two_mean_data, mean_diff_data, pca_data);
disp(T);

%% -show on graph

subject_num        = str2num( char(subject) );
session_num        = str2num( char(session) );
validation_num     = str2num( char(validation) );
original_data_num  = str2num( char(original_data) );
mean_data_num      = str2num( char(mean_data) );
two_mean_data_num  = str2num( char(two_mean_data) );
mean_diff_data_num = str2num( char(mean_diff_data) );
pca_data_num       = str2num( char(pca_data) );

%- arrange 
all_res    = {};
all_res{1} = original_data_num;
all_res{2} = mean_data_num;
all_res{3} = two_mean_data_num;
all_res{4} = mean_diff_data_num;
all_res{5} = pca_data_num;
%% -calc var
num_of_subjects = size( unique( subject_num ), 1 );

all_var  = zeros( 5, num_of_subjects);
all_mean = zeros( 5, num_of_subjects);

unique_subjects = unique( subject_num );
for data_type = 1:5
    
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
% all_res{1} = original_data_num;
% all_res{2} = mean_data_num;
% all_res{3} = two_mean_data_num;
% all_res{4} = mean_diff_data_num;
% all_res{5} = pca_data_num;

figure();
% errorbar(   1:num_of_subjects                   , all_mean(1, :)   ,...
%             all_var(1, :)                       , -all_var(1, :)   ,...
%             'MarkerEdgeColor'                   , 'k');
hold on;
errorbar(   1:num_of_subjects                   , all_mean(2, :)   ,...
            all_var(2, :)                       , -all_var(2, :)   ,...
            'MarkerEdgeColor'                   , 'k');
hold on;
errorbar(   1:num_of_subjects                   , all_mean(3, :)   ,...
            all_var(3, :)                       , -all_var(3, :)   ,...
            'MarkerEdgeColor'                   , 'k');
hold on;
errorbar(   1:num_of_subjects                   , all_mean(4, :)   ,...
            all_var(4, :)                       , -all_var(4, :)   ,...
            'MarkerEdgeColor'                   , 'k');
hold on;
% errorbar(   1:num_of_subjects                   , all_mean(5, :)   ,...
%             all_var(5, :)                       , -all_var(5, :)   ,...
%             'MarkerEdgeColor'                   , 'k');

% legend('Original', 'With one mean', 'With two mean', 'With mean sub', 'With PCA', 'FontSize', 20);
legend('With one mean', 'With two mean', 'With mean sub', 'FontSize', 20);
title('Precision of ERP', 'FontSize', 30);
xlabel('Subject', 'FontSize', 20);
ylabel('Precision', 'FontSize', 20);




