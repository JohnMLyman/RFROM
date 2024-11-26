function [txt]=compute_warming_no_weight_3(mean_ohca,total_error_ohca,tgrid_ohca)
%computes tho slope and the 90% confidence on the slope  


area_of_earth=5.1e14;

good=find(isfinite(mean_ohca)==1);
mean_ohca=mean_ohca(good);
tgrid_ohca=tgrid_ohca(good);
total_error_ohca=total_error_ohca(good);

hc=mean_ohca.*1e22;
std_error=total_error_ohca.*1e22;
tgrid=tgrid_ohca;
scale_fit_hc=std(hc)./std(tgrid);
hc_2=hc./scale_fit_hc;
std_error=std_error./scale_fit_hc;
w_hc=1./(std_error.^2);
[y_model,y_model_se,slope_error_hc,sl_hc]=j_fit_90(tgrid,hc_2,1);
 
 
 slope_error_hc=slope_error_hc*scale_fit_hc./area_of_earth;
sl_hc=sl_hc*scale_fit_hc./area_of_earth;

w3=num2str(sl_hc/86400/365.25,'%8.6f');
w3_err=num2str(slope_error_hc/86400/365.25,'%5.3f');
 
txt={'warming rates:'; ...
 ['            ',w3,'\pm',w3_err,' W/m^2']}