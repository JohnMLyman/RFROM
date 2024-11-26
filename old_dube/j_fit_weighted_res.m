function [res,N_star_small]=j_fit_weighted_res(t,y,w_in)
% this code is a linear least square fit  Y=BX+e
% E is a matrix of the X's that you are fitting to 
% model is a vector of the B's
% model_err is the stard devation of the varience of the B's to the the
%       real B's see Wunch inverse modeling book
% Right now the code is set up to fit a line with an off set
%
%       INPUTS
% t which is time 
% w_in are the weights which are usally set 1/varience 
% y the data which it is fit to 
% scale the number of elements in t are divided by scale to give the number
%   of dregrees of freedom (set to 4 in this case). 
%

%       OUTPUTS
% y_model the line
% y_model_err_95 the 95% interval of the error on y_model 
% slope the slope of the line 
% slope_error the 95% confidence on the slope


% if no scale set = to 4

scale=1.
%w_in=w_in./w_in
%w_in
W=diag(w_in);

E=[t',ones(size(t))'];
covmat_inv=inv(E'*W'*E);
model=covmat_inv*E'*W'*y';
res=E*model-y';


[N_star_small,auto_corr]=j_auto_corr(res);
