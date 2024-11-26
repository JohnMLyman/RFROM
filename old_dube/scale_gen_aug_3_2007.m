function [mean_map,std_map,std_error_map,mean_rep,std_rep,std_error_rep,...
    mean_slope_error_map,mean_slope_error_rep,mean_slope_error_ave,...
    stde_slope_error_map,stde_slope_error_rep]=...
    scale_gen(scale,start_year,end_year,min_mean_year,max_mean_year,type)



dof=floor((end_year-start_year)./scale);
N=end_year-scale-start_year+1;

mean_map=0;
mean_rep=0;
mean_slope_error_rep=0;
mean_slope_error_map=0;
mean_slope_error_ave=0;

std_map=0;
std_rep=0;
std_slope_error_rep=0;
std_slope_error_map=0;


for min_scale_year=start_year:end_year-scale
    
  
    max_scale_year=min_scale_year+scale;
    
   eval(['[mean_diff_rep,std_diff_rep,mean_diff_map,std_diff_map,',...
    'mean_error_map,mean_error_rep,mean_error_ave,std_error_map,std_error_rep]=',...
   'heat_',type,'_gen(min_scale_year,max_scale_year,min_mean_year,max_mean_year);']);
    
    mean_map=mean_diff_map+mean_map;
    std_map=std_diff_map.^2+std_map;
    
    mean_rep=mean_diff_rep+mean_rep;
    std_rep=std_diff_rep.^2+std_rep;

    mean_slope_error_rep=mean_error_rep+mean_slope_error_rep;
    std_slope_error_rep=std_slope_error_rep+std_error_rep.^2;

    mean_slope_error_map=mean_error_map+mean_slope_error_map;
    std_slope_error_map=std_slope_error_map+std_error_map.^2;

    mean_slope_error_ave=mean_slope_error_ave+mean_error_ave;


end

mean_map=mean_map./N;
std_map=sqrt(std_map./N);
std_error_map=std_map./sqrt(dof);

mean_rep=mean_rep./N;
std_rep=sqrt(std_rep./N);
std_error_rep=std_rep./sqrt(dof);

mean_slope_error_rep=mean_slope_error_rep./N;
std_slope_error_rep=sqrt(std_slope_error_rep./N);
stde_slope_error_rep=std_slope_error_rep./sqrt(dof);

mean_slope_error_map=mean_slope_error_map./N;
std_slope_error_map=sqrt(std_slope_error_map./N);
stde_slope_error_map=std_slope_error_map./sqrt(dof);

mean_slope_error_ave=mean_slope_error_ave./N;
