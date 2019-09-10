function [Y w] = BOE( X )
% FUNCTION applies BOE weighting to event count vector matrix.
%
%   [Y w] = BOE( X );
%
% INPUT :
%   X        - event count vectors (one column = one segment)
%
% OUTPUT :
%   Y        - weighted segment-event BOE matrix
%   w        -  weights (useful to process other segment)
%

% get weight
w = CalWeight( X );

% TF * IDF
Y = ef( X ) .* repmat( w, 1, size(X,2) );






