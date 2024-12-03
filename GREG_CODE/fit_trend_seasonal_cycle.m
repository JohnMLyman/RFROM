function [mod_coeffs,dat_res] = fit_trend_seasonal_cycle(dyr,dat_ser,flag1,mid_year)
% function [model_coeffs,dat_res] = fit_trend_seasonal_cycle(dyr,dat_ser,flag1,mid_year)
%
% Input is dyr, a vector of time in decimal year; dat_ser, the
% data at each time in the time vector that are to be modeled; flag1, 
% which indicates whether or not to remove the trend, and mid_year, 
% the central year for the fit.   The model is a mean (computed at the mean
% time of the series), a trend in yr-1 over the length of the record, and a
% seasonal cycle comprised of harmonics at 
% 1, 2, 3, 5, 5, and 6 cycles per year, first the sin and then the cos in
% the fit. If flag1 is set to 1, the trend is not removed, otherwise it is 
% removed.
%
% output is model_coeffs: mean, trends, sin(2*pi*time), cos(2*time),
% sin(4*pi), ... sin(12*pi*t), cos(12*pi*t) and dat_res, the residual left
% over after the model has been subtracted from the data.


dyr=dyr(:);
dat_ser=dat_ser(:);

% heres the model with a mean, a trend, and a bunch of harmonics

model=[ones(size(dyr)),dyr-mid_year,sin(2*pi*dyr),cos(2*pi*dyr),sin(4*pi*dyr),cos(4*pi*dyr),sin(6*pi*dyr),cos(6*pi*dyr),sin(8*pi*dyr),cos(8*pi*dyr),sin(10*pi*dyr),cos(10*pi*dyr),sin(12*pi*dyr)];

% take the 
pmodel=pinv(model);

mod_coeffs=pmodel*dat_ser;

if flag1(1)==1
    model_ser=mod_coeffs(1)+0*mod_coeffs(2)*(dyr-mid_year)+mod_coeffs(3)*sin(2*pi*dyr)+mod_coeffs(4)*cos(2*pi*dyr)+mod_coeffs(5)*sin(4*pi*dyr)+mod_coeffs(6)*cos(4*pi*dyr)+mod_coeffs(7)*sin(6*pi*dyr)+mod_coeffs(8)*cos(6*pi*dyr)+mod_coeffs(9)*sin(8*pi*dyr)+mod_coeffs(10)*cos(8*pi*dyr)+mod_coeffs(11)*sin(10*pi*dyr)+mod_coeffs(12)*cos(10*pi*dyr)+mod_coeffs(13)*sin(12*pi*dyr);
else
    model_ser=mod_coeffs(1)+mod_coeffs(2)*(dyr-mid_year)+mod_coeffs(3)*sin(2*pi*dyr)+mod_coeffs(4)*cos(2*pi*dyr)+mod_coeffs(5)*sin(4*pi*dyr)+mod_coeffs(6)*cos(4*pi*dyr)+mod_coeffs(7)*sin(6*pi*dyr)+mod_coeffs(8)*cos(6*pi*dyr)+mod_coeffs(9)*sin(8*pi*dyr)+mod_coeffs(10)*cos(8*pi*dyr)+mod_coeffs(11)*sin(10*pi*dyr)+mod_coeffs(12)*cos(10*pi*dyr)+mod_coeffs(13)*sin(12*pi*dyr);
end

dat_res=dat_ser-model_ser;

end

