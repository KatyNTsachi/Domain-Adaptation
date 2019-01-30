function [string_return] = showSvmResults( input_data, input_lable, input_title, base_func)
    %calc svm and show confusion matrix
    t             = templateSVM('Standardize', false, 'KernelFunction', base_func);
    Mdl           = fitcecoc( input_data', ...
                              input_lable, ...
                              'KFold', 10, ...
                              'Learners', t);
    avr_loss      = kfoldLoss(Mdl);
    string_return = [ input_title,  base_func, num2str(avr_loss) ];
    

%     %-- for showing confusion mat
%     predicted_label = predict( Mdl.Trained{1}, input_data' );
%     figure;
%     confusionchart( input_lable, predicted_label,'RowSummary','row-normalized','ColumnSummary','column-normalized');
%     title( input_title );
end



