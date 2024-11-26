function x=nans(x,varargin);

% NANS   NaNs array.
%    NANS(N) is an N-by-N matrix of NaNs.
%    NANS(M,N) or NANS([M,N]) is an M-by-N matrix of NaNs.
%    NANS(M,N,P,...) or NANS([M N P ...]) is an M-by-N-by-P-by-...
%    array of NaNs.
%    NANS(SIZE(A)) is the same size as A and all NaNs.
% 
%    See also ZEROS, and ONES.


x=NaN*ones(x,varargin{:});
