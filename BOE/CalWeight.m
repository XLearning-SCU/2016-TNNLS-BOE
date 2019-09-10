function I = CalWeight(X)
% SUBFUNCTION computes weight

% count the number of events in each frame
nz = sum( ( X > 0 ), 2 );

% compute iff for each segment
I = log( size(X,2) ./ (nz(:) + 1) );