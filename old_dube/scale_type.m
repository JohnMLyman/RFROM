function [mean_map,std_map,std_error_map,mean_rep,std_rep,std_error_rep,...
 mean_slope_error_map,mean_slope_error_rep,mean_slope_error_ave,...
    stde_slope_error_map,stde_slope_error_rep]=...
    scale_type(start_year,end_year,min_mean_year,max_mean_year,type,scales)

%type is a string ether:

% 'diff' for the difference estimate (resluts in w/m^2)
% 'slope for the least squares (w/m^2)
% 'std'  for the standaerdevation zeta joules


mean_map=[];
std_map=[];
std_error_map=[];

mean_rep=[];
std_rep=[];
std_error_rep=[];

mean_slope_error_map=[];
mean_slope_error_rep=[];
mean_slope_error_ave=[];

stde_slope_error_map=[];
stde_slope_error_rep=[];

for iscale=1:length(scales)
    
    scale=scales(iscale);

[jmean_map,jstd_map,jstd_error_map,jmean_rep,jstd_rep,jstd_error_rep,...
jmean_slope_error_map,jmean_slope_error_rep,jmean_slope_error_ave,...
jstde_slope_error_map,jstde_slope_error_rep]=...
    scale_gen(scale,start_year,end_year,min_mean_year,max_mean_year,type);

mean_map=[mean_map,jmean_map];
std_map=[std_map,jstd_map];
std_error_map=[std_error_map,jstd_error_map];

mean_rep=[mean_rep,jmean_rep];
std_rep=[std_rep,jstd_rep];
std_error_rep=[std_error_rep,jstd_error_rep];

mean_slope_error_map=[mean_slope_error_map,jmean_slope_error_map];
mean_slope_error_rep=[mean_slope_error_rep,jmean_slope_error_rep];
mean_slope_error_ave=[mean_slope_error_ave,jmean_slope_error_ave];

stde_slope_error_map=[stde_slope_error_map,jstde_slope_error_map];
stde_slope_error_rep=[stde_slope_error_rep,jstde_slope_error_rep];
end
