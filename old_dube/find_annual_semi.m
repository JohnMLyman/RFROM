function [y_model,amp_annual,phase_annual,amp_semi,phase_semi]=find_annual_semi(t,yin)

% remove mean

y=yin-nanmean(yin);

% take out a linear trend

 [y_model,y_model_err_95,slope_error,slope]=j_fit(t,y,1);
y=y-y_model;

% fit an annual and a semi annual cycle



[y_model,amp_annual,phase_annual,amp_semi,phase_semi]=j_fit_sin_heat(t,y);