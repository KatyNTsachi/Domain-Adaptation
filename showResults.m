close all;
clear;
clc;
addpath("./functions");



%% - load data multiple files
% results_path = "./results/pca_results_CVRP_dataset.mat";
dir_path = "./results/erp/onefile/";
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



%% - put in table
subject            = data(2:end, 1);
session            = data(2:end, 2);
validation         = data(2:end, 3);
original_data      = data(2:end, 4);
mean_data          = data(2:end, 5);
two_mean_data      = data(2:end, 6);
mean_diff_data     = data(2:end, 7);
pca_data           = data(2:end, 8);
mean_data_oracel   = data(2:end, 9);
seperate_pca_data  = data(2:end, 10);

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
pca_data_num          = str2num( char(pca_data) );
mean_data_oracel_num  = str2num( char(mean_data_oracel) );
seperate_pca_data_num = str2num( char(seperate_pca_data) );


%- arrange 
all_res    = {};
all_res{1} = original_data_num;
all_res{2} = mean_data_num;
all_res{3} = two_mean_data_num;
all_res{4} = mean_diff_data_num;
all_res{5} = pca_data_num;
all_res{6} = mean_data_oracel_num;
all_res{7} = seperate_pca_data_num;

%% -calc var
num_of_subjects = size( unique( subject_num ), 1 );

all_var  = zeros( 7, num_of_subjects);
all_mean = zeros( 7, num_of_subjects);

unique_subjects = unique( subject_num );
for data_type = 1:7
    
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

%%

% all_res{1} = original_data_num;
% all_res{2} = mean_data_num;
% all_res{3} = two_mean_data_num;
% all_res{4} = mean_diff_data_num;
% all_res{5} = pca_data_num;
% all_res{6} = reference_num;

colormap jet;
cmap=colormap;
tmp_colors = [cmap(10,:);cmap(1,:);cmap(60,:);cmap(33,:);cmap(45,:);cmap(20,:);cmap(12,:);cmap(11,:)];

all_mean = all_mean(:, 1:24);
all_var  = all_var(:, 1:24);
num_of_subjects = 24;
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

% legend('Original', 'With train mean', 'With two train mean', 'With train sub mean', 'With combined PCA', 'Reference results', 'FontSize', 20);
legend('Original', 'With train mean', 'With two train mean', 'With train sub mean', 'With combined PCA','Oracel', 'With seperate PCA', 'FontSize', 20);

title('Precision of ERP', 'FontSize', 30);


xlabel('Subject', 'FontSize', 20);
ylabel('Precision', 'FontSize', 20);




