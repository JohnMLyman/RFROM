function [y_model,y_model_err_95,slope_error,slope]=j_fit_weighted_alpha(t,y,w_in)
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


scale=1;
W=diag(w_in);

E=[t'];
covmat_inv=inv(E'*W'*E);
model=covmat_inv*E'*W'*y';
res=E*model-y';

% this part computes the degrees of freedom taking into account the scale
%   factor and subtracted from the number of elemnts that are fit to.

dof=(size(E,1)/scale-size(E,2));
chisqr=sum(res.^2)/dof;
model_err=sqrt(diag(covmat_inv)*chisqr);
y_model=t*model(1);
y_model_err_95=student(dof)*sqrt(((t- mean(t))*model_err(1)).^2);

slope=model(1);
slope_error=model_err(1);



% this part plots the fit (use if you want to check that every thing is A
%   okay)

  plot(t,y,'r.',t,y_model,'b-',t,y_model+y_model_err_95,'m--',t,y_model- y_model_err_95,'m--')

