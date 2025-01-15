function [y_model,y_model_err_90,slope_error,slope]=j_fit_90(t,yin,scale)
% this code is a linear least square fit  Y=BX+e
% E is a matrix of the X's that you are fitting to 
% model is a vector of the B's
% model_err is the stard devation of the varience of the B's to the the
%       real B's see Wunch inverse modeling book
% Right now the code is set up to fit a line with an off set
%
%       INPUTS
% t which is time 
% y the data which it is fit to 
% scale the number of elements in t are divided by scale to give the number
%   of dregrees of freedom. 


%       OUTPUTS
% y_model the line
% y_model_err_90 the 90% interval of the error on y_model 
% slope the slope of the line 
% slope_error the 90% interval of the error confidence on the slope

% scale=4;
% 
% % normalize the varience in the x and y directions.
% 
 y=yin;
% 
% scale_fit=std(y)./std(t);
% 
% 
% y=y./scale_fit;
% 
% scale_fit
scale=1;

scale_fit=1;


E=[t',ones(size(t))'];

covmat_inv=inv(E'*E);

model=covmat_inv*E'*y';
res=E*model-y';
size(E,2);
% this part computes the degrees of freedom taking into account the scale
%   factor and subtracted from the number of elemnts that are fit to.

dof=(size(E,1)/scale-size(E,2));
[N_star,auto_corr]=j_auto_corr(res);
N_star

dof=(N_star-size(E,2))

if dof<1
	dof=1;
end

chisqr=sum(res.^2)/dof;
model_err=sqrt(diag(covmat_inv)*chisqr);

%t_test=[1:100];
y_model=(t*model(1)+model(2)).*scale_fit;
y_model_err_90=(student90(dof)*sqrt(model_err(2)+((t- mean(t))*model_err(1)).^2)).*scale_fit;

% y_model=(t*model(1)+model(2)).*scale_fit;
% y_model_err_95=(student(dof)*sqrt(model_err(2)+((t- mean(t))*model_err(1)).^2)).*scale_fit;
% 
slope=model(1);
slope_error=model_err(1);

slope_error=student90(dof)*model_err(1);

slope_error=slope_error*scale_fit;
slope=slope*scale_fit;

% this part plots the fit (use if you want to check that every thing is A
%   okay)


%plot(t,y.*scale_fit,'r.',t,y_model,'b-',t,y_model+y_model_err_95,'m--',t,y_model- y_model_err_95,'m--')

