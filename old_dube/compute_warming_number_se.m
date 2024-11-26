function [slope,slope_se]=compute_warming_number_se(mean_ohca,total_error_ohca,tgrid_ohca)
 area_of_earth=5.1e14;

good=find(isfinite(mean_ohca)==1);
mean_ohca=mean_ohca(good);
tgrid_ohca=tgrid_ohca(good);
total_error_ohca=total_error_ohca(good);

hc=mean_ohca.*1e22;
std_error=total_error_ohca.*1e22;
tgrid=tgrid_ohca;

t_scale=std(tgrid_ohca,1)
t_scale=1;

tgrid=tgrid;
scale_fit_hc=std(hc,1)./std(tgrid,1);
scale_fit_hc=std(hc,1);
scale_fit_hc=1;
%scale_fit_hc=std(hc,1);

hc_2=hc;
%[y_model,y_model_err_95,slope_error,slope]=j_fit(tgrid,hc_2,1)


%std_erroSr=std_error./std(hc_2,1);
%std_error(2:end-1)=std_error(2:end-1).*100000e4444;
%std_error=std_error./100;
%std_error=std_error./std(hc,1);
%std_error=std_error./max(std_error);
w_hc=1./(std_error.^2);

%w_hc=w_hc./max(w_hc);
 [y_model,y_model_err_95,slope_error_hc,sl_hc]=j_fit_weighted_se2(tgrid,hc_2,w_hc)
%[y_model,y_model_err_95,slope_error_hc,sl_hc]=j_fit(tgrid,hc_2,w_hc);
%[y_model,y_model_err,slope_error_hc,sl_hc,dof]=j_fit_tim(tgrid,hc_2)
 slope_error_hc=slope_error_hc./(area_of_earth);
sl_hc=sl_hc./(area_of_earth);

w3=sl_hc/86400/365.25;
w3_err=slope_error_hc/86400/365.25;
 slope=w3;
 slope_se=w3_err;