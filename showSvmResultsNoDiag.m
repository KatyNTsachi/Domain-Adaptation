function [string_return] = showSvmResultsNoDiag( input_data, input_lable, input_title, base_func,D)
    
    %-- remove diag
    string_return      = []
    ones_size_of_input = ones( D, D );
    pattern_for_factor = ( triu( ones_size_of_input, 1 )==1 );
    pattern_for_factor = pattern_for_factor( triu( ones_size_of_input ) == 1 );
    input_data         = input_data( pattern_for_factor, : );
    
    %calc svm and show confusion matrix
    t = templateSVM('Standardize', 1, 'KernelFunction', base_func);
    Mdl       = fitcecoc( input_data', ...
                          input_lable, ...
                          'KFold', 10, ...
                          'Learners', t);
    avr_loss = kfoldLoss(Mdl);
    string_return = [ input_title,  base_func, num2str(avr_loss) ];

%     %-- for showing confusion mat
%     predicted_label = predict( Mdl.Trained{1}, input_data' );
%     figure;
%     confusionchart( input_lable, predicted_label,'RowSummary','row-normalized','ColumnSummary','column-normalized');
%     title( input_title );
end



