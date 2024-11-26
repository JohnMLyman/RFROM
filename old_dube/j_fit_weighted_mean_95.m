function [model_mean,mean_error]=j_fit_weighted_mean_95(t,y,w_in,dof)
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

W=diag(w_in);

E=[ones(size(t))'];
covmat_inv=inv(E'*W'*E);
model=covmat_inv*E'*W'*y';
res=E*model-y';

% this part computes the degrees of freedom taking into account the scale
%   factor and subtracted from the number of elemnts that are fit to.

%[N_star,auto_corr]=j_auto_corr(res);
%N_star

%dof=(N_star-size(E,2));
%if dof < 1
%then dof=1
%end
% figure
% plot(auto_corr)
chisqr=sum(res.^2)/(dof-1);
model_err=sqrt(diag(covmat_inv)*chisqr);



model_mean=model(1);
mean_error=student(dof-1)*model_err(1);




% this part plots the fit (use if you want to check that every thing is A
%   okay)

%  plot(t,y,'r.',t,y_model,'b-',t,y_model+y_model_err_95,'m--',t,y_model- y_model_err_95,'m--')

