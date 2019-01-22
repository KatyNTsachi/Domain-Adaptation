function [] = showSvmResults( input_data, input_lable, input_title)
    %calc svm and show confusion matrix
    Mdl       = fitcecoc( input_data', ...
                          input_lable, ...
                          'KFold', 10);
    avr_loss = kfoldLoss(Mdl);
    disp(['The average value of the loss of ' ,input_title, ' is: ',num2str(avr_loss)]);
%     %-- for showing confusion mat
%     predicted_label = predict( Mdl.Trained{1}, input_data' );
%     figure;
%     confusionchart( input_lable, predicted_label,'RowSummary','row-normalized','ColumnSummary','column-normalized');
%     title( input_title );
end



