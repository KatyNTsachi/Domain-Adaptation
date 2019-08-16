close all;
clear;
clc;
addpath("./functions");

%% - load data

% dir_path = "./results/ERP/multiple sessions/";
dir_path = "./results/CVEP/multiple sessions/";



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
oracle            = data(2:end, 6);
with_train_mean   = data(2:end, 7);
with_sepatate_PCA = data(2:end, 8);
with_train_PCA    = data(2:end, 9);


%% -show on graph

subject1_num        = str2num( char(subject1) );
session1_num        = str2num( char(session1) );
subject2_num        = str2num( char(subject2) );
session2_num        = str2num( char(session2) );

original_num          = str2num( char(original) );
oracle_num            = str2num( char(oracle) );
with_train_mean_num   = str2num( char(with_train_mean) );
with_train_PCA_num    = str2num( char(with_train_PCA) );
with_sepatate_PCA_num = str2num( char(with_sepatate_PCA) );

%- arrange 
all_res    = {};
all_res{1} = original_num;
all_res{2} = oracle_num;
all_res{3} = with_train_mean_num;
all_res{4} = with_sepatate_PCA_num;
all_res{5} = with_train_PCA_num;

%% -calc var subjects
num_of_1_subjects = size( unique( subject1_num ), 1 );


mean_summary  = zeros( 5, 1);
var_summary = zeros( 5, 1);

unique_1_subjects = unique( subject1_num );
for data_type = 1:5
    for tmp_subject_num = 1 : length(unique_1_subjects)
        
        %- get relevant idx
        relevant_idx_all_subject = find( subject1_num == unique_1_subjects(tmp_subject_num) &...
                                         subject2_num ~= unique_1_subjects(tmp_subject_num ) ...
                                        );
    
        relevant_idx_all_session = find( subject1_num == unique_1_subjects(tmp_subject_num) &...
                                         subject2_num == unique_1_subjects(tmp_subject_num)  ...
                                        );
        
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
%% -calc for legende
num_of_1_subjects = size( unique( subject1_num ), 1 );


mean_summary  = zeros( 5, 1);
var_summary = zeros( 5, 1);

unique_1_subjects = unique( subject1_num );
for data_type = 1:5
    relevant_idx_summery = [];
    for tmp_subject_num = 1 : length(unique_1_subjects)
        
        %- get relevant idx
        relevant_idx_all_subject = find( subject1_num == unique_1_subjects(tmp_subject_num) &...
                                         subject2_num ~= unique_1_subjects(tmp_subject_num ) ...
                                        );
        relevant_idx_summery = [relevant_idx_summery; relevant_idx_all_subject];
    
        relevant_idx_all_session = find( subject1_num == unique_1_subjects(tmp_subject_num) &...
                                         subject2_num == unique_1_subjects(tmp_subject_num)  ...
                                        );
        
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
    var_summary(data_type) = sqrt( var( tmp_data( relevant_idx_summery ) ) );
    mean_summary(data_type)= mean( tmp_data( relevant_idx_summery ) );

end
%% all subject

colormap jet;
cmap=colormap;
tmp_colors = [cmap(10,:);...
              cmap(20,:);...
              cmap(33,:);...
              cmap(55,:);...
              cmap(63,:)];

errorbar(   1:num_of_1_subjects                 , all_mean_all_subject(1, :)   ,...
            all_var_all_subject(1, :)           , -all_var_all_subject(1, :)   ,...
            'MarkerEdgeColor'                   , 'k'                          ,...
            'LineWidth'                         , 3.0                          ,...
            'Color'                             , tmp_colors(1, :));
hold on;
errorbar(   1:num_of_1_subjects                 , all_mean_all_subject(2, :)   ,...
            all_var_all_subject(2, :)           , -all_var_all_subject(2, :)   ,...
            'MarkerEdgeColor'                   , 'k'                          ,...
            'LineWidth'                         , 3.0                          ,...
            'Color'                             , tmp_colors(2, :));
hold on;
errorbar(   1:num_of_1_subjects                 , all_mean_all_subject(3, :)   ,...
            all_var_all_subject(3, :)           , -all_var_all_subject(3, :)   ,...
            'MarkerEdgeColor'                   , 'k'                          ,...
            'LineWidth'                         , 3.0                          ,...
            'Color'                             , tmp_colors(3, :));
hold on;
errorbar(   1:num_of_1_subjects                 , all_mean_all_subject(4, :)   ,...
            all_var_all_subject(4, :)           , -all_var_all_subject(4, :)   ,...
            'MarkerEdgeColor'                   , 'k'                          ,...
            'LineWidth'                         , 3.0                          ,...
            'Color'                             , tmp_colors(4, :));
hold on;
errorbar(    1:num_of_1_subjects                 , all_mean_all_subject(5, :) ,...
             all_var_all_subject(5, :)           , -all_var_all_subject(5, :) ,...
             'MarkerEdgeColor'                   , 'k'                        ,...
             'LineWidth'                         , 3.0                          ,...
            'Color'                             , tmp_colors(5, :));


legend( "Original                     (" + num2str(mean_summary(1), '%1.2f') + ", " + num2str(var_summary(1), '%1.2f') + ")",...
        "Oracle                       (" + num2str(mean_summary(2), '%1.2f') + ", " + num2str(var_summary(2), '%1.2f') + ")",...
        "train sub mean          (" + num2str(mean_summary(3), '%1.2f') + ", " + num2str(var_summary(3), '%1.2f') + ")",...
        "seperate PCA           (" + num2str(mean_summary(4), '%1.2f') + ", " + num2str(var_summary(4), '%1.2f') + ")",...
        "train PCA                  (" + num2str(mean_summary(5), '%1.2f') + ", " + num2str(var_summary(5), '%1.2f') + ")",...
        'FontSize', 20);
    

title('Average Precision of ERP different subjects', 'FontSize', 30);

xlabel('Subject', 'FontSize', 20);
ylabel('Precision', 'FontSize', 20);
set(gca, 'FontSize', 20);   
grid on;


%% -calc for legende
num_of_1_subjects = size( unique( subject1_num ), 1 );


mean_summary  = zeros( 5, 1);
var_summary = zeros( 5, 1);

unique_1_subjects = unique( subject1_num );
for data_type = 1:5
    relevant_idx_summery = [];
    for tmp_subject_num = 1 : length(unique_1_subjects)
        
        %- get relevant idx
        relevant_idx_all_subject = find( subject1_num == unique_1_subjects(tmp_subject_num) &...
                                         subject2_num ~= unique_1_subjects(tmp_subject_num ) ...
                                        );
        
    
        relevant_idx_all_session = find( subject1_num == unique_1_subjects(tmp_subject_num) &...
                                         subject2_num == unique_1_subjects(tmp_subject_num)  ...
                                        );
        relevant_idx_summery = [relevant_idx_summery; relevant_idx_all_session];
        
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
    var_summary(data_type) = sqrt(var( tmp_data( relevant_idx_summery ) ));
    mean_summary(data_type)= mean( tmp_data( relevant_idx_summery ) );

end

%% all sessions

figure();
errorbar(   1:num_of_1_subjects                 , all_mean_all_session(1, :)   ,...
            all_var_all_session(1, :)           , -all_var_all_session(1, :)   ,...
            'MarkerEdgeColor'                   , 'k'                          ,...
            'LineWidth'                         , 3.0                          ,...
            'Color'                             , tmp_colors(1, :));
hold on;
errorbar(   1:num_of_1_subjects                 , all_mean_all_session(2, :)   ,...
            all_var_all_session(2, :)           , -all_var_all_session(2, :)   ,...
            'MarkerEdgeColor'                   , 'k'                          ,...
            'LineWidth'                         , 3.0                          ,...
            'Color'                             , tmp_colors(2, :));
hold on;
errorbar(   1:num_of_1_subjects                 , all_mean_all_session(3, :)   ,...
            all_var_all_session(3, :)           , -all_var_all_session(3, :)   ,...
            'MarkerEdgeColor'                   , 'k'                          ,...
            'LineWidth'                         , 3.0                          ,...
            'Color'                             , tmp_colors(3, :));
hold on;
errorbar(   1:num_of_1_subjects                 , all_mean_all_session(4, :)   ,...
            all_var_all_session(4, :)           , -all_var_all_session(4, :)   ,...
            'MarkerEdgeColor'                   , 'k'                          ,...
            'LineWidth'                         , 3.0                          ,...
            'Color'                             , tmp_colors(4, :));
hold on;
errorbar(    1:num_of_1_subjects                 , all_mean_all_session(5, :) ,...
             all_var_all_session(5, :)           , -all_var_all_session(5, :) ,...
             'MarkerEdgeColor'                   , 'k'                        ,...
             'LineWidth'                         , 3.0                          ,...
             'Color'                             , tmp_colors(5, :));


legend( "Original                     (" + num2str(mean_summary(1), '%1.2f') + ", " + num2str(var_summary(1), '%1.2f') + ")",...
        "Oracle                       (" + num2str(mean_summary(2), '%1.2f') + ", " + num2str(var_summary(2), '%1.2f') + ")",...
        "train sub mean          (" + num2str(mean_summary(3), '%1.2f') + ", " + num2str(var_summary(3), '%1.2f') + ")",...
        "seperate PCA           (" + num2str(mean_summary(4), '%1.2f') + ", " + num2str(var_summary(4), '%1.2f') + ")",...
        "train PCA                  (" + num2str(mean_summary(5), '%1.2f') + ", " + num2str(var_summary(5), '%1.2f') + ")",...
        'FontSize', 20);
    


title('Average Precision of ERP different sessions', 'FontSize', 30);
xlabel('Subject', 'FontSize', 20);
ylabel('Precision', 'FontSize', 20);
set(gca, 'FontSize', 20);   
grid on;




