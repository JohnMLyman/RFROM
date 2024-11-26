function [y_model,amp_annual,phase_annual,amp_semi,phase_semi,amp_third,phase_third,slope,mean,model_err]=j_fit_annual_tree(t,yin,tbig)
% this code is a linear least square fit
% this is how you reconcrtuct y from model
%y_model=amp_annual*sin((2*pi*t./period)+phase_annual)+amp_semi*sin((2*t*pi./period2)+phase_semi)+...
%   amp_third*sin((2*pi*t./period3)+phase_third)+slope*t+mean;
%       real B's see Wunch inverse modeling book
%
%       INPUTS
% t which is time in years
% y the data which it is fit to a semiannual and annual signal. REMOVE MEAN
% FRIST!!!!


%       OUTPUTS


% normalize the varience in the x and y directions.


% September 2007, DOUBLE CHEAK 95% ERROR CALCULATION!!!!!
y=yin;




period=1;
period2=1/2;
period3=1/3;



E=[(sin(t*2*pi/period))',(cos(t*2*pi/period))',(sin(t*2*pi/period2))',(cos(t*2*pi/period2))',...
    (sin(t*2*pi/period3))',(cos(t*2*pi/period3))',t',ones(size(t))'];
%E=[t',ones(size(t))'];

covmat_inv=inv(E'*E);
model=covmat_inv*E'*y';
res=E*model-y';
size(E,2);
% this part computes the degrees of freedom taking into account the scale
%   factor and subtracted from the number of elemnts that are fit to.

[N_star,auto_corr]=j_auto_corr(res);
%N_star

dof=(N_star-size(E,2));

if dof<1
	dof=1;
end

chisqr=sum(res.^2)/dof;
model_err=sqrt(diag(covmat_inv)*chisqr);
if exist('tbig','var')

    y_model=(model(1)*sin(tbig*2*pi/period)+model(2)*cos(tbig*2*pi/period)+model(3)*sin(tbig*2*pi/period2)+model(4)*cos(tbig*2*pi/period2)+...
        model(5)*sin(tbig*2*pi/period3)+model(6)*cos(tbig*2*pi/period3)+tbig*model(7)+model(8));
else
    y_model=(model(1)*sin(t*2*pi/period)+model(2)*cos(t*2*pi/period)+model(3)*sin(t*2*pi/period2)+model(4)*cos(t*2*pi/period2)+...
        model(5)*sin(t*2*pi/period3)+model(6)*cos(t*2*pi/period3)+t*model(7)+model(8));
end
annual_amp_sin=model(1);
%annual_amp_sin_err=student(dof)*model_err(1);

annual_amp_cos=model(2);
%annual_amp_cos_err=student(dof)*model_err(2);

semiannual_amp_sin=model(3);
%semiannual_amp_sin_err=student(dof)*model_err(1);

semiannual_amp_cos=model(4);
%semiannual_amp_cos_err=student(dof)*model_err(2);
% this part plots the fit (use if you want to check that every thing is A
%   okay)

phase_annual=-1.*atan(-1.*model(2)/model(1));

amp_annual=(model(1))./cos(phase_annual);


phase_semi=-1.*atan(-1.*model(4)/model(3));

amp_semi=(model(3))./cos(phase_semi);

phase_third=-1.*atan(-1.*model(6)/model(5));

amp_third=(model(5))./cos(phase_third);

slope=model(7);
mean=model(8);






%plot(t,y.,'r.',t,y_model,'b-',t,y_model+y_model_err_95,'m--',t,y_model- y_model_err_95,'m--')

