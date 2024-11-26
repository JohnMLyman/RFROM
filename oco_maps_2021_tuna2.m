%% set the path and file names be ware

file_name_argo='pfloat_sal_greg_oct_2021_QC'
path_OHCA_data_out='C:\data\OHCA\'
path_OHCA_data_in='C:\OHCA\'
%%  YOU MUST DOWNLOAD ARGO AND AVISO DATA AND PUT THEM IN THE CORRECT LOCATIONS!!!!
%%%%  Do I need the next line I dont think so!!!  11/14/2017

%%
% YOU MUST CHANE THE FILE_NAME TO THE CURRNET DATE EVERY TIME YOU CHANGE
% LAYERBOUNDS AND/OR FILE_NAME_ARGO SO THAT THE FILES DO NOT GET OVER WRITEN!!!!!
% file_nmae=argo_year_month_day_qc
file_name='argo_2020_10_14_QC'
file_name='argo_2021_01_01_QC'

layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000] % layer_bounds must be in assending order
%layer_bounds=[0,100,300,700,900,1800] % layer_bounds must be in assending order


% grid for first-order large scale mean
lon_grid_mean=[-180:5:180];
lat_grid_mean=[-90:5:90];

% range for the large scale mean in Avsio and Argo
%   it is also the time range for which the Aviso and Argo
%   are correlated for means of infilling

max_year_mean=2021;
min_year_mean=2005;


%range for annual maps


max_year_maps=2021;
min_year_maps=2002;

%% NEED TO CHANGE THE PLOT INFO AT THE BOTTOM OF THIS FILE!!!!!




%set paths
% file_path='/Volumes/ThunderBay/Data/Globalhc/Floats/Argo/CORIOLIS/'
% file_path_out='/Volumes/ThunderBay/Data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
file_path=[path_OHCA_data_out,'OHCA_profiles\'];
file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
file_path_in=path_OHCA_data_in;
% I think you can change file_anme_mean if you want to run a diffent mean but not
% 100% sure doubble check
file_name_mean=file_name;
file_path_hdata=[path_OHCA_data_out,'OHCA_maps\'];
file_WOD_suf='_cheng_EN4_2014'
file_EN3_type='_cheng_EN4_2014'
path_EN4_in=[path_OHCA_data_in,'EN4\Cheng_2014\'];
path_EN4_out=[path_OHCA_data_out,'EN4\Cheng_2014\'];
allheat_extra='_new'



%%
min_year=min_year_mean;
max_year=max_year_mean;

% define the varibiles to be saved and read

heat_var_name=[];

for ilayer=2:length(layer_bounds)
    
    heat_var_name=[heat_var_name,' heat_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
heat_var_name=[heat_var_name,' '];
    
ind_var_name=[];

for ilayer=2:length(layer_bounds)
    
    ind_var_name=[ind_var_name,' ind_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
ind_var_name=[ind_var_name,' '];

bad_heat_var_name=[];

for ilayer=2:length(layer_bounds)
    
    bad_heat_var_name=[bad_heat_var_name,' bad_heat_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
bad_heat_var_name=[bad_heat_var_name,' '];

mean_heat_var_name=[];

for ilayer=2:length(layer_bounds)
    
    mean_heat_var_name=[mean_heat_var_name,' mean_heat_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
mean_heat_var_name=[mean_heat_var_name,' '];


heat_anom_var_name=[];

for ilayer=2:length(layer_bounds)
    
    heat_anom_var_name=[heat_anom_var_name,' heat_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer)),'_anom'];
    
end
heat_anom_var_name=[heat_anom_var_name,' '];
    
heat_wod_var_name=[];

for ilayer=2:length(layer_bounds)
    
    heat_wod_var_name=[heat_wod_var_name,' heat_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer)),'_wod'];
    
end
heat_wod_var_name=[heat_wod_var_name,' '];
    
ht_var_name=[];

for ilayer=2:length(layer_bounds)
    
    ht_var_name=[ht_var_name,' ht_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
ht_var_name=[ht_var_name,' '];
    
mean_heat_oa_name=[];

for ilayer=2:length(layer_bounds)
    
    mean_heat_oa_name=[mean_heat_oa_name,' mean_heat_oa_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
mean_heat_oa_name=[mean_heat_oa_name,' '];

htdiff_var_name=[];

for ilayer=2:length(layer_bounds)
    
    htdiff_var_name=[htdiff_var_name,' htdiff_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
htdiff_var_name=[htdiff_var_name,' '];


%% Make the SSH files
% % % % %  getalltp_oco_realtime_oco_2020_tuna

 clearvars -except file_path file_path_out path_OHCA_data_out  file_name file_name_mean ...
     file_path_hdata max_year min_year file_WOD_suf path_EN4_in path_EN4_out file_path_in ...
     max_year_maps min_year_maps allheat_extra layer_bounds ...
     bad_heat_var_name ind_var_name heat_var_name ...
     lon_grid_mean lat_grid_mean mean_heat_var_name ...
     heat_anom_var_name heat_wod_var_name ht_var_name mean_heat_oa_name ...
     htdiff_var_name file_EN3_type file_name_argo  min_year_mean max_year_mean


%% Make the argo flaot filedata
% % % % %   getprofiles_greg_QC_oco_tuna
 clearvars -except file_path file_path_out path_OHCA_data_out  file_name file_name_mean ...
     file_path_hdata max_year min_year file_WOD_suf path_EN4_in path_EN4_out file_path_in ...
     max_year_maps min_year_maps allheat_extra layer_bounds ...
     bad_heat_var_name ind_var_name heat_var_name ...
     lon_grid_mean lat_grid_mean mean_heat_var_name ...
     heat_anom_var_name heat_wod_var_name ht_var_name mean_heat_oa_name ...
     htdiff_var_name file_EN3_type file_name_argo  min_year_mean max_year_mean


%% make the heat content file

% UNCOMMENT TO RERUN!!! 
 %pfloat_heat_height_oco_itp
% % % % %  pfloat_heat_height_oco_itp_TEOS10_new_layers_1_tuna
 
 clearvars -except file_path file_path_out path_OHCA_data_out  file_name file_name_mean ...
     file_path_hdata max_year min_year file_WOD_suf path_EN4_in path_EN4_out file_path_in ...
     max_year_maps min_year_maps allheat_extra layer_bounds ...
     bad_heat_var_name ind_var_name heat_var_name ...
     lon_grid_mean lat_grid_mean mean_heat_var_name ...
     heat_anom_var_name heat_wod_var_name ht_var_name mean_heat_oa_name ...
     htdiff_var_name file_EN3_type file_name_argo  min_year_mean max_year_mean

 
%% basic qc of heat content


 'qc'
% UNCOMMENT TO RERUN!!!


%%% QC CODE NEED WORK TO RUN WITH LAYER_BOUNDS
% % % % %     qc_argo_heat_oco_new_layers_1_tuna 
 clearvars -except file_path file_path_out path_OHCA_data_out  file_name file_name_mean ...
     file_path_hdata max_year min_year file_WOD_suf path_EN4_in path_EN4_out file_path_in ...
     max_year_maps min_year_maps allheat_extra layer_bounds...?
     bad_heat_var_name ind_var_name heat_var_name ...
     lon_grid_mean lat_grid_mean mean_heat_var_name ...
     heat_anom_var_name heat_wod_var_name ht_var_name mean_heat_oa_name ...
     htdiff_var_name file_EN3_type file_name_argo  min_year_mean max_year_mean




%% grid the mean heat content of the Argo floats using a gausian filter
 
  'mean_oco'
% UNCOMMENT TO RERUN!!!
%%% MEAN_HEAT CODE NEED WORK TO RUN WITH LAYER_BOUNDS

% % % % %      mean_heat_oco_new_layers_1_tuna
 clearvars -except file_path file_path_out path_OHCA_data_out  file_name file_name_mean ...
     file_path_hdata max_year min_year file_WOD_suf path_EN4_in path_EN4_out file_path_in ...
     max_year_maps min_year_maps allheat_extra layer_bounds...
     bad_heat_var_name ind_var_name heat_var_name ...
     lon_grid_mean lat_grid_mean mean_heat_var_name ...
     heat_anom_var_name heat_wod_var_name ht_var_name mean_heat_oa_name ...
     htdiff_var_name file_EN3_type file_name_argo  min_year_mean max_year_mean



 
% remove mean from Argo




%%%%%%%%%%%%%%%%%%
%%% RAN TO HERE ON JULY 12th
%%%%%%%%%%%%%%%%%%%



'remove_mean'
% UNCOMMENT TO RERUN!!!
% % % % %     remove_argo_mean_oco_new_layers_1_tuna
 clearvars -except file_path file_path_out path_OHCA_data_out  file_name file_name_mean ...
     file_path_hdata max_year min_year file_WOD_suf path_EN4_in path_EN4_out file_path_in ...
     max_year_maps min_year_maps allheat_extra layer_bounds...
     bad_heat_var_name ind_var_name heat_var_name ...
     lon_grid_mean lat_grid_mean mean_heat_var_name ...
     heat_anom_var_name heat_wod_var_name ht_var_name mean_heat_oa_name ...
     htdiff_var_name file_EN3_type file_name_argo  min_year_mean max_year_mean



% make an objective analysis mean





'make_mean_feilds_bin_oa'

% compute the SSH mean and files

%    getalltp_oco_realtime_2014

 
% UNCOMMENT WHEN NEW EN3 IS AVAILBLE 
% % % % %  getwod_heat_oco_EN3_teos10_new_layers_1_tuna
%%% 
  clearvars -except file_path file_path_out path_OHCA_data_out  file_name file_name_mean ...
     file_path_hdata max_year min_year file_WOD_suf path_EN4_in path_EN4_out file_path_in ...
     max_year_maps min_year_maps allheat_extra layer_bounds...
     bad_heat_var_name ind_var_name heat_var_name ...
     lon_grid_mean lat_grid_mean mean_heat_var_name ...
     heat_anom_var_name heat_wod_var_name ht_var_name mean_heat_oa_name ...
     htdiff_var_name file_EN3_type file_name_argo  min_year_mean max_year_mean





min_year=min_year_maps;
max_year=max_year_maps;







% %% bin then OA
%% UNCOMMENT 3 %!!!   TO RERUN!!! John 11/12/2015

% % % % %     [data_grid,lon,lat]=load_and_grid_matlab_season_test3_bin_new_layers_1(file_path_out,...
% % % % %         file_path,file_name_mean,heat_anom_var_name,heat_var_name,layer_bounds);
% [data_grid,lon,lat]=load_and_grid_matlab_season_test3_bin_height(file_path_out,file_path,file_name_mean);

% % % 
%% UNCOMMENT TO RERUN!!!
 
% % % % %    [data_grid_oa,lon,lat]=load_and_grid_matlab_season_test3_oa_new_layers_1(...
% % % % %       file_path,file_name_mean,layer_bounds);
%[data_grid_oa,lon,lat]=load_and_grid_matlab_season_test3_oa_height(file_path_out,file_path,file_name_mean);
% % % 

%% UNCOMMENT TO RERUN!!!
% once oad_and_grid_matlab_season_test3_bin
%      oad_and_grid_matlab_season_test3_bin_height
% and  load_and_grid_matlab_season_test3_oa
%      load_and_grid_matlab_season_test3_oa_height
% have been run once comment them unless you are recomputing the
% climotology and in that case file_name and file_name_mean must be the 
% same 

% % % % %     remove_argo_mean_oa_oco_bin_2013_new_layers_1
%remove_argo_mean_oa_oco_bin_height

% % 
% % 
% % %% bin data on seasonal grid
%% UNCOMMENT TO RERUN!!!

% % % % %     [iyear]=load_and_grid_matlab_season_test2_bin_new_layers_1(file_path_out,...
% % % % %         file_path,file_name_mean,heat_anom_var_name,heat_var_name,layer_bounds);
%[iyear]=load_and_grid_matlab_season_test2_bin_height(file_path_out,file_path,file_name_mean);
% % 
% % 
% % 
% % 
% % %% compute OA bin seasion
% % 
%% UNCOMMENT TO RERUN!!!

% % % % %     [iyear]=load_and_grid_matlab_season_test2_bin_oa_new_layers_1(file_path,...
% % % % %         file_name_mean,layer_bounds);
%[iyear]=load_and_grid_matlab_season_test2_bin_oa_height(file_path_out,file_path,file_name_mean);

% % 
% % 'remove season'
% % 
%% UNCOMMENT TO RERUN!!!
% once load_and_grid_matlab_season_test2_bin
%      load_and_grid_matlab_season_test2_bin_height
% and  load_and_grid_matlab_season_test2_bin_oa
%      load_and_grid_matlab_season_test2_bin_oa_height
% have been run once comment them unless you are recomputing the
% climotology and in that case file_name and file_name_mean must be the
% same
%START CHANGING HERE!!! JUL 12 th

% % % % %  remove_argo_mean_oa_oco_bin_season_2013_new_layers_1
%remove_argo_mean_oa_oco_bin_season_height

% RAN TO HERE Jul 15

% % %% interptpx
% % 
% % 
% % 'interptpx'
% % 
%UNCOMMENT TO RERUN!!!
% % % 
% % % % % interptpx_argo_mean_oco_bin_2014_junk_new_layers_1



%interptpx_argo_mean_oco_bin_height


%% mapdiff

%% UNCOMMENT TO RERUN!!!

% mapdiff_argo_mean_oco_bin
% mapdiff_argo_mean_oco_bin_height
% % 
% % %% monthly grid


%  Combine with WOD
% 
% UNCOMMENT THIS WHOLE SECTION WHEN THE WOD DATA HAS BEEN QC'D
% 'remove mean and sesonal cycle from WOD and add it to Argo and ITPs'

 
 %% UNCOMMENT TO RERUN!!!

remove_seasonal_cycle_WOD_bin_EN3_2013_new_layers_1_tuna


%%remove_argo_mean_oa_seasonal_cycle_WOD_bin_height_EN3

'interpx WOD'
 clearvars -except file_path file_path_out path_OHCA_data_out  file_name file_name_mean ...
     file_path_hdata max_year min_year file_WOD_suf path_EN4_in path_EN4_out file_path_in ...
     max_year_maps min_year_maps allheat_extra layer_bounds...
     bad_heat_var_name ind_var_name heat_var_name ...
     lon_grid_mean lat_grid_mean mean_heat_var_name ...
     heat_anom_var_name heat_wod_var_name ht_var_name mean_heat_oa_name ...
     htdiff_var_name file_EN3_type file_name_argo  min_year_mean max_year_mean

interptpx_argo_mean_oco_WOD_2015_new_layers_2_tuna
 clearvars -except file_path file_path_out path_OHCA_data_out  file_name file_name_mean ...
     file_path_hdata max_year min_year file_WOD_suf path_EN4_in path_EN4_out file_path_in ...
     max_year_maps min_year_maps allheat_extra layer_bounds...
     bad_heat_var_name ind_var_name heat_var_name ...
     lon_grid_mean lat_grid_mean mean_heat_var_name ht_var_name mean_heat_oa_name ...
     htdiff_var_name file_EN3_type file_name_argo min_year_mean max_year_mean



'mapdiff WOD'

mapdiff_argo_mean_oco_no_season_WOD_EN3_2013_new_layers_2

 clearvars -except file_path file_path_out path_OHCA_data_out  file_name file_name_mean ...
     file_path_hdata max_year min_year file_WOD_suf path_EN4_in path_EN4_out file_path_in ...
     max_year_maps min_year_maps allheat_extra layer_bounds...
     bad_heat_var_name ind_var_name heat_var_name ...
     lon_grid_mean lat_grid_mean mean_heat_var_name ...
     heat_anom_var_name heat_wod_var_name ht_var_name mean_heat_oa_name ...
     htdiff_var_name file_EN3_type file_name_argo min_year_mean max_year_mean



%% make the maps

'map'
%  
% 
% 
% %  
% map_ht_EN3_junk_2015_new_layers_1_tuna2



% % %% run plots
% % year_of_oco_pub=20222; %  NEED TO CHANGE year_of_oco_pub OR TREND WONT CHANGE AND PLOTS WILL BE WRITEN OVER
% % %      NEED TO MAKE SURE THAT: 
% % %      heat_slope_file=['slope_heat_',num2str(year_of_oco_pub),'_insitu_',num2str(depth_top_plot),'_',num2str(depth_bot_plot)];
% % %      has been errased if you want the slope to be recomputed
% % %        in general the year_of_oco_pub is 2-years newer than the last year of maps
% % 
% % OHCA_map_name=['hdata_new_layers__ishii_EN3_2014_',file_name,'1990_2020_'] %NEED TO CHANGE TO MATCH OUTPUT OF OCO_MAPS_2017_2
% % YEARS_plot_maps=[2019 2020] %  NEED TO CHANGE TO REFLECT CURRENT YEARS 
% % 
% % depth_top_plot=0;
% % depth_bot_plot=700;
% % slope_min_year=1993; %MUST BE GREATER THAN MIN MAP YEAR IN OHCA_map_name (ie the second to last year in the name) !!!
% % 
% % 
% % heat_plots_2018
% % 

