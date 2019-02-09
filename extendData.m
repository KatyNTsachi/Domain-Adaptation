function [extended_data] = extendData(data)
    
    extended_data={};
    for ii = 1 : length(data)
        new_data = [];
        tmp = data(ii);
        tmp = tmp{1};
%         multiplication_permutation = [];
%         for jj = 1 : size(tmp,2)
%             for kk = jj + 1 : size(tmp,2)
%                 tmp_res = [ tmp(:,jj) .* tmp(:,kk)];
%                 multiplication_permutation = [multiplication_permutation, tmp_res];
%             end
%         end
%         new_data = [tmp, tmp.^2,multiplication_permutation];
        new_data = [tmp, tmp.^2];
        extended_data{ii} = new_data;
    end
end

