function [ret_distance] = calDistanceBetweenTwoCovVec( X, Y )
    
    %--prepare
    N            = size( Y, 1 );
    new_X        = reshape( X, 22, 22, [] );
    new_Y        = reshape( Y', 22, 22 ,[] );
    ret_distance = nan( N, 1 );
    
    for ii=1 : N

        %-- calc
        eig_value        = eig( new_X, new_Y( :, :, ii ) ); 
        ret_distance(ii) = norm( log( eig_value ) );
    
    end
end

