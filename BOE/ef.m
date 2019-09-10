function Y = ef( X )
% SUBFUNCTION computes event frequencies

Y = X ./ repmat( sum(X,1), size(X,1), 1 );
Y( isnan(Y) ) = 0;