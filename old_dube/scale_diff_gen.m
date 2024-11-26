function [mean_map,std_map,std_error_map,mean_rep,std_rep,std_error_rep]=...
    scale_diff_gen(scale,start_year,end_year,min_mean_year,max_mean_year)



dof=floor((end_year-start_year)./scale)
N=end_year-scale-start_year+1

mean_map=0;
mean_rep=0;
std_map=0;
std_rep=0;



for min_scale_year=start_year:end_year-scale
    
    max_scale_year=min_scale_year+scale
    
    [mean_diff_rep,std_diff_rep,mean_diff_map,std_diff_map]=...
    heat_diff_gen(min_scale_year,max_scale_year,min_mean_year,max_mean_year);
    
    mean_map=mean_diff_map+mean_map;
    std_map=std_diff_map.^2+std_map;
    
    mean_rep=mean_diff_rep+mean_rep;
    std_rep=std_diff_rep.^2+std_rep;

end

mean_map=mean_map./N;
std_map=sqrt(std_map./N);
std_error_map=std_map./sqrt(N);

mean_rep=mean_rep./N;
std_rep=sqrt(std_rep./N);
std_error_rep=std_rep./sqrt(N);
