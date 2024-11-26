
% Then you need to rename ../SAL/Floats/argo/ to ../SAL/Floats/argo_20??/ and than make a new ../SAL/Floats/argo/ 


%%% effectively deleting the  ind_den_den*mat and den_den*mat files in  ../SAL/Floats/argo/
% and rename pfloat_sal_density_density_surface in ../Floats/Argo/CORIOLIS/
% to pfloat_sal_density_density_surface_20??


 path_sal='K:\data\SAL\';
 


% % %  getprofiles_sal_density_density_surface_0_1_2_orca
% % 
 clearvars -except path_sal
 cd(path_sal)
% % %  putfloats_density_surface_orca
% % %  
% % % % 
% % %  qc_WOD05_floats_surface_orca
% % % % % % 
% % % 
% % % %% make out the mean surface salinity
filename='surface_sal_Jan_2024' % NEED TO CHANGE THIS EVERY YEAR!!!!
% % % 
% % % 


surface_sal_files_new_WOA13v2_orca
 clearvars -except filename path_sal
%% map the surface salinity
lon_grid=[-180:.5:180];
lat_grid=[-90:.5:90];


time_grid=[2002.5:2023.5];
file_path=path_sal;
file_name=filename;
[iyear]=load_and_grid_matlab_surface_sal(file_path,file_name,lat_grid,lon_grid,time_grid);
% load_and_grid_matlab_surface_sal_gary has a strange time interval con't
% remeber why
%[iyear]=load_and_grid_matlab_surface_sal_gary(file_path,file_name,lat_grid,lon_grid,time_grid)


%% THIS SECTION PLOTS SAL MAPS!!!

% year_of_oco_pub=2022;
% slope_min_year=2005;
% file_surface_name=[file_name,'_',num2str(time_grid(1)-.5),'_',num2str(time_grid(end)-.5)];%    MUST CHANGE TO MATCH SAL MAPPING
% %  NEED TO CHANGE year_of_oco_pub OR TREND WONT CHANGE AND PLOTS WILL BE WRITEN OVER
% %      NEED TO MAKE SURE THAT:
% YEARS_plot_maps=[ 2020 2021] %  NEED TO CHANGE TO REFLECT CURRENT YEARS 
% 
% %MUST DELETE ['slope_salt_',file_surface_name,'_', year_of_oco_pub,'.mat']
% %IF YOU RAN THIS WITH OUT CHANGING year_of_oco_pub
%MUST change 

% % % sal_plot_2018_all
