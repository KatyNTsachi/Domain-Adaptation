% close all;
% clear;
clc;
addpath("./functions");



%% - load data multiple files
% results_path = "./results/pca_results_CVRP_dataset.mat";
% dir_path = "./results/ERP/one session/";
% num_of_subjects = 24;

dir_path = "./results/CVEP/one session/";
num_of_subjects = 9;

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

%4,5,6,7,9,10,11

%% - put in table
subject            = data(2:end, 1);
session            = data(2:end, 2);
validation         = data(2:end, 3);
original_data      = data(2:end, 4);
mean_data          = data(2:end, 5);
two_mean_data      = data(2:end, 6);
mean_diff_data     = data(2:end, 7);
mean_data_oracel   = data(2:end, 9);
seperate_pca_data  = data(2:end, 10);
train_pca          = data(2:end, 11);




% T = table( subject, session, validation, original_data, mean_data, two_mean_data, mean_diff_data, pca_data);
% disp(T);

%% -show on graph

subject_num           = str2num( char(subject) );
session_num           = str2num( char(session) );
validation_num        = str2num( char(validation) );
original_data_num     = str2num( char(original_data) );
mean_data_num         = str2num( char(mean_data) );
two_mean_data_num     = str2num( char(two_mean_data) );
mean_diff_data_num    = str2num( char(mean_diff_data) );
mean_data_oracel_num  = str2num( char(mean_data_oracel) );
seperate_pca_data_num = str2num( char(seperate_pca_data) );
train_pca_num         = str2num( char(train_pca) );



%- arrange  1,2,3,6,7
all_res    = {};
all_res{1} = original_data_num; 
all_res{2} = mean_data_oracel_num; 
all_res{3} = mean_diff_data_num; 
all_res{4} = seperate_pca_data_num; 
all_res{5} = train_pca_num;           

all_res{6} = mean_data_num;
all_res{7} = two_mean_data_num;



%% -calc var
num_of_subjects = size( unique( subject_num ), 1 );

all_var  = zeros( 8, num_of_subjects);
all_mean = zeros( 8, num_of_subjects);

unique_subjects = unique( subject_num );
for data_type = 1:length(all_res)
    
    for tmp_subject_num = 1 : length(unique_subjects)
        
        %- get relevant idx
        relevant_idx = find( subject_num == unique_subjects(tmp_subject_num) );
        
        %- get televant data 
        tmp_data = all_res{data_type};
%         figure();
%         scatter(1:size(tmp_data, 1), tmp_data);
        %- calc var
        all_result      = tmp_data( relevant_idx );
        real_result_idx = find(all_result ~= -1);
        real_result     = all_result(real_result_idx);
        if size(real_result, 1) == 0 
            real_result = nan;
        end
        tmp_var  = var( real_result );
        tmp_mean = mean( real_result );
        %- update table
        all_var( data_type, tmp_subject_num)  = tmp_var;
        all_mean( data_type, tmp_subject_num) = tmp_mean;
    end
    
end
%% -calc var
num_of_subjects = size( unique( subject_num ), 1 );

var_summary  = zeros( 8, 1);
mean_summary = zeros( 8, 1);


for data_type = 1:length(all_res)
            
        %- get televant data 
        tmp_data = all_res{data_type};

        %- calc var
        all_result      = tmp_data;
        real_result_idx = find(all_result ~= -1);
        real_result     = all_result(real_result_idx);
        if size(real_result, 1) == 0 
            real_result = nan;
        end
        tmp_var  = var( real_result );
        tmp_mean = mean( real_result );
        
        %- update table
        var_summary( data_type, 1)  = sqrt(tmp_var);
        mean_summary( data_type, 1) = tmp_mean;
    
end

disp([mean_summary, var_summary]);
%%


colormap jet;
cmap=colormap;
tmp_colors = [cmap(10,:);...
              cmap(20,:);...
              cmap(33,:);...
              cmap(55,:);...
              cmap(63,:);...
              cmap(43,:);...
              cmap(60,:);...
              cmap(45,:)];
          

all_mean = all_mean(:, 1:num_of_subjects);
all_var  = all_var(:, 1:num_of_subjects);
figure();

errorbar(   1:num_of_subjects                   , all_mean(1, :)   ,...
            all_var(1, :)                       , -all_var(1, :)   ,...
            'MarkerEdgeColor'                   , 'k'              ,...
            'LineWidth'                         , 3.0              ,...
            'Color'                             , tmp_colors(1, :));
hold on;
errorbar(   1:num_of_subjects                   , all_mean(2, :)   ,...
            all_var(2, :)                       , -all_var(2, :)   ,...
            'MarkerEdgeColor'                   , 'k'              ,...
            'LineWidth'                         , 3.0              ,...
            'Color'                             , tmp_colors(2, :));
hold on;
errorbar(   1:num_of_subjects                   , all_mean(3, :)   ,...
            all_var(3, :)                       , -all_var(3, :)   ,...
            'MarkerEdgeColor'                   , 'k'              ,...
            'LineWidth'                         , 3.0              ,...
            'Color'                             , tmp_colors(3, :));
hold on;
errorbar(   1:num_of_subjects                   , all_mean(4, :)   ,...
            all_var(4, :)                       , -all_var(4, :)   ,...
            'MarkerEdgeColor'                   , 'k'              ,...
            'LineWidth'                         , 3.0              ,...
            'Color'                             , tmp_colors(4, :));
hold on;
errorbar(   1:num_of_subjects                   , all_mean(5, :)   ,...
            all_var(5, :)                       , -all_var(5, :)   ,...
            'MarkerEdgeColor'                   , 'k'              ,...
            'LineWidth'                         , 3.0              ,...
             'Color'                            , tmp_colors(5, :));
hold on;
errorbar(   1:num_of_subjects                   , all_mean(6, :)   ,...
            all_var(6, :)                       , -all_var(6, :)   ,...
            'MarkerEdgeColor'                   , 'k'              ,...
            'LineWidth'                         , 3.0              ,...
             'Color'                            , tmp_colors(6, :));
hold on;
errorbar(   1:num_of_subjects                   , all_mean(7, :)   ,...
            all_var(7, :)                       , -all_var(7, :)   ,...
            'MarkerEdgeColor'                   , 'k'              ,...
            'LineWidth'                         , 3.0              ,...
             'Color'                            , tmp_colors(7, :));

legend( "Original                     (" + num2str(mean_summary(1), '%1.2f') + ", " + num2str(var_summary(1), '%1.2f') + ")",...
        "Oracle                       (" + num2str(mean_summary(2), '%1.2f') + ", " + num2str(var_summary(2), '%1.2f') + ")",...
        "Train sub mean        (" +  num2str(mean_summary(3), '%1.2f') + ", " + num2str(var_summary(3), '%1.2f') + ")",...
        "Seperate PCA          (" + num2str(mean_summary(4), '%1.2f') + ", " + num2str(var_summary(4), '%1.2f') + ")",...
        "Train PCA                (" + num2str(mean_summary(5), '%1.2f') + ", " + num2str(var_summary(5), '%1.2f') + ")",...
        "Mean                        (" + num2str(mean_summary(5), '%1.2f') + ", " + num2str(var_summary(5), '%1.2f') + ")",...
        "Two means              (" + num2str(mean_summary(5), '%1.2f') + ", " + num2str(var_summary(5), '%1.2f') + ")",...
        'FontSize', 20);

    
set(gca, 'FontSize', 20);   
grid on;
title('Precision of ERP', 'FontSize', 30);

xlabel('Subject', 'FontSize', 20);
ylabel('Precision', 'FontSize', 20);





