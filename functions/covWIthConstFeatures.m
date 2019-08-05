function [ c_data_for_classifier ] = covWIthConstFeatures(  c_data_to_add_waves )

    data_i = c_data_to_add_waves;

    %-- add window in time features
    n  = size(data_i{1}, 1);
    start_points = 25;
    lb = -start_points;
    ub = start_points;
    [psi,~] = morlet(lb,ub,n);
    
    bigger_by = 70;
    wavelet_mat = [];
    NUM_OF_ITER = 10;
    for num_of_waves = 1:NUM_OF_ITER
        wavelet_mat = [wavelet_mat; circshift( bigger_by * psi, num_of_waves * (n / NUM_OF_ITER) ) ];
    end
    
    
%     figure();
%     subplot(2,1,1);
%     plot(psi);
%     subplot(2,1,2);
%     F_wavelet = fftshift( abs(fft(wavelet_mat(1, :))) );
%     plot(F_wavelet);
%     hold on;
%     one_mat = data_i{1};
%     plot(fftshift( abs(fft(one_mat(:, 1))) ));

    for sample_i = 1:length(data_i)
        data_i{sample_i} = [data_i{sample_i}, wavelet_mat'];
    end


    %-- add to return cell array
    c_data_for_classifier = data_i;
   
    
end