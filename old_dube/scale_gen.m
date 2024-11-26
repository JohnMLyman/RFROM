function [mean_map,std_map,std_error_map,mean_rep,std_rep,std_error_rep,...
    mean_slope_error_map,mean_slope_error_rep,mean_slope_error_ave,...
    stde_slope_error_map,stde_slope_error_rep]=...
    scale_gen(scale,start_year,end_year,min_mean_year,max_mean_year,type)



dof=floor((end_year-start_year)./scale);
N=end_year-scale-start_year+1;

mean_map=[];
mean_rep=[];
mean_slope_error_rep=[];
mean_slope_error_map=[];
mean_slope_error_ave=[];

std_map=[];
std_rep=[];
std_slope_error_rep=[];
std_slope_error_map=[];


for min_scale_year=start_year:end_year-scale
    
  
    max_scale_year=min_scale_year+scale;
    
   eval(['[mean_diff_rep,std_diff_rep,mean_diff_map,std_diff_map,',...
    'mean_error_map,mean_error_rep,mean_error_ave,std_error_map,std_error_rep]=',...
   'heat_',type,'_gen(min_scale_year,max_scale_year,min_mean_year,max_mean_year);']);
    
    mean_map(min_scale_year-start_year+1)=mean_diff_map;
    std_map(min_scale_year-start_year+1)=std_diff_map;
    
    mean_rep(min_scale_year-start_year+1)=mean_diff_rep;
    std_rep(min_scale_year-start_year+1)=std_diff_rep;

    mean_slope_error_rep(min_scale_year-start_year+1)=mean_error_rep;
    std_slope_error_rep(min_scale_year-start_year+1)=std_error_rep;

    mean_slope_error_map(min_scale_year-start_year+1)=mean_error_map;
    std_slope_error_map(min_scale_year-start_year+1)=std_error_map;

    mean_slope_error_ave(min_scale_year-start_year+1)=mean_error_ave;


end


dof_aviso_timeseries=10;

if dof<1 
dof =1;
end
mean_slope_error_map=student(dof_aviso_timeseries)*mean(mean_slope_error_map)./sqrt(dof);
mean_slope_error_rep=student(dof_aviso_timeseries)*mean(mean_slope_error_rep)./sqrt(dof);
mean_rep=mean(mean_rep);
mean_map=mean(mean_map);
%w_in_map=1./(mean_slope_error_map.^2);
%w_in_rep=1./(mean_slope_error_rep.^2);
%junk_time=[start_year:start_year+N-1];
% [mean_map_junk,mean_slope_error_map]=j_fit_weighted_mean(junk_time,mean_map,w_in_map,dof)
% [mean_rep_junk,mean_slope_error_rep]=j_fit_weighted_mean(junk_time,mean_rep,w_in_rep,dof_aviso_timeseries)
%mean_map=mean_map_junk;
%mean_rep=mean_rep_junk;

%mean_slope_error_rep=student(dof_aviso_timeseries).*mean_slope_error_rep;
%mean_slope_error_mep=student(dof_aviso_timeseries).*mean_slope_error_map;

%if dof<2 

%mean_slope_error_rep=mean_slope_error_rep./N;
%mean_slope_error_rep=mean_slope_error_rep./N;
%end

%mean_map=mean_map./N;
std_map=sqrt(mean(std_map));
std_error_map=std_map./sqrt(dof);

%mean_rep=mean_rep./N;
std_rep=sqrt(mean(std_rep));
std_error_rep=std_rep./sqrt(dof);

%mean_slope_error_rep=mean_slope_error_rep./N;
std_slope_error_rep=sqrt(mean(std_slope_error_rep));
stde_slope_error_rep=std_slope_error_rep./sqrt(dof);

%mean_slope_error_map=mean_slope_error_map./N;
std_slope_error_map=sqrt(mean(std_slope_error_map));
stde_slope_error_map=std_slope_error_map./sqrt(dof);

% so that mean_slope_error_ave is expressed at the 95% interval it is multiplied by a student t diftribution% it should be the same at all scales becase the long time scale have the degrees of freedom of the whole 
% time series and the short time scales, have meny relization but still can't have more degrees of freedom 
% than the whole tim series.  The degrees of freedom were estimated by j_fit_95 and should be the same as
% used in the other calculations.

mean_slope_error_ave=student(dof_aviso_timeseries).*mean(mean_slope_error_ave)./sqrt(dof);
mean_slope_error_map=sqrt(mean_slope_error_ave.^2+mean_slope_error_map.^2);
mean_slope_error_rep=sqrt(mean_slope_error_ave.^2+mean_slope_error_rep.^2);
