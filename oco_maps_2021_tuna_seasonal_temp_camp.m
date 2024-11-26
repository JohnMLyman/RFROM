%% set the path and file names be ware

file_name_argo='pfloat_sal_greg_jan_2022_QC'
path_OHCA_data_out='C:\data\OHCA\'
path_OHCA_data_in='C:\OHCA\'
%%  YOU MUST DOWNLOAD ARGO AND AVISO DATA AND PUT THEM IN THE CORRECT LOCATIONS!!!!
%%%%  Do I need the next line I dont think so!!!  11/14/2017

%%
% YOU MUST CHANE THE FILE_NAME TO THE CURRNET DATE EVERY TIME YOU CHANGE
% LAYERBOUNDS AND/OR FILE_NAME_ARGO SO THAT THE FILES DO NOT GET OVER WRITEN!!!!!
% file_nmae=argo_year_month_day_qc


file_name='argo_2021_02_02_QC'
file_name_season=[file_name,'_seasonal']
%layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000]% layer_bounds must be in assending order
%layer_bounds=[0,100,300,700,900,1800] % layer_bounds must be in assending order
layer_bounds=[0, 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125,...
    135, 145, 155, 165, 175, 190, 210, 230, 250, 270, 290, 310, 330 , ...
    350, 370 , 390, 410,  430, 450, 475, 525, 575, 625, 675, 725, 775,...
    825, 875, 925, 975, 1025, 1075, 1125, 1175, 1225, 1275, 1325, 1375,...
    1450, 1550, 1650, 1750, 1850, 1950, 2000]% layer_bounds must be in assending order

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
min_year_maps=1990;

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

file_EN3_type='_cheng_EN4_2014'
path_EN4_in=[path_OHCA_data_in,'EN4\Cheng_2014\'];
path_EN4_out=[path_OHCA_data_out,'EN4\Cheng_2014\'];
allheat_extra='_new'
file_WOD_suf=file_EN3_type;


%%
min_year=min_year_mean;
max_year=max_year_mean;

% define the varibiles to be saved and read

temp_var_name=[];

for ilayer=2:length(layer_bounds)
    
    temp_var_name=[temp_var_name,' temp_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
temp_var_name=[temp_var_name,' '];
    
ind_var_name=[];

for ilayer=2:length(layer_bounds)
    
    ind_var_name=[ind_var_name,' ind_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
ind_var_name=[ind_var_name,' '];

bad_temp_var_name=[];

for ilayer=2:length(layer_bounds)
    
    bad_temp_var_name=[bad_temp_var_name,' bad_temp_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
bad_temp_var_name=[bad_temp_var_name,' '];

mean_temp_var_name=[];

for ilayer=2:length(layer_bounds)
    
    mean_temp_var_name=[mean_temp_var_name,' mean_temp_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
mean_temp_var_name=[mean_temp_var_name,' '];


temp_anom_var_name=[];

for ilayer=2:length(layer_bounds)
    
    temp_anom_var_name=[temp_anom_var_name,' temp_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer)),'_anom'];
    
end
temp_anom_var_name=[temp_anom_var_name,' '];
    
temp_wod_var_name=[];

for ilayer=2:length(layer_bounds)
    
    temp_wod_var_name=[temp_wod_var_name,' temp_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer)),'_wod'];
    
end
temp_wod_var_name=[temp_wod_var_name,' '];
    
t_var_name=[];

for ilayer=2:length(layer_bounds)
    
    t_var_name=[t_var_name,' t_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
t_var_name=[t_var_name,' '];
    
mean_temp_oa_name=[];

for ilayer=2:length(layer_bounds)
    
    mean_temp_oa_name=[mean_temp_oa_name,' mean_temp_oa_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
mean_temp_oa_name=[mean_temp_oa_name,' '];

tdiffvar_name=[];

for ilayer=2:length(layer_bounds)
    
    tdiffvar_name=[tdiffvar_name,' tdiff',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
tdiffvar_name=[tdiffvar_name,' '];


%% Make the SSH files
%  getalltp_oco_realtime_oco_2020_tuna_test

 clearvars -except file_path file_path_out path_OHCA_data_out  file_name file_name_mean ...
     file_path_hdata max_year min_year file_WOD_suf path_EN4_in path_EN4_out file_path_in ...
     max_year_maps min_year_maps alltemp_extra layer_bounds ...
     bad_temp_var_name ind_var_name temp_var_name ...
     lon_grid_mean lat_grid_mean mean_temp_var_name ...
     temp_anom_var_name temp_wod_var_name t_var_name mean_temp_oa_name ...
     tdiffvar_name file_EN3_type file_name_argo  min_year_mean max_year_mean ...
     file_name_season

%% YOU ONLY NEED TO UNCOMMENT THIS SECTION IF YOU HAVEN'T RUN THE NORMAL OLD VERSION FIRST WITH THE SAME file_name AND file_name_argo
% % % %% Make the argo flaot filedata


%   getprofiles_greg_QC_oco_tuna
% % %  clearvars -except file_path file_path_out path_OHCA_data_out  file_name file_name_mean ...
% % %      file_path_hdata max_year min_year file_WOD_suf path_EN4_in path_EN4_out file_path_in ...
% % %      max_year_maps min_year_maps alltemp_extra layer_bounds ...
% % %      bad_temp_var_name ind_var_name temp_var_name ...
% % %      lon_grid_mean lat_grid_mean mean_temp_var_name ...
% % %      temp_anom_var_name temp_wod_var_name t_var_name mean_temp_oa_name ...
% % %      tdiffvar_name file_EN3_type file_name_argo  min_year_mean max_year_mean ...
% % %      file_name_season
% % % 
% % % 
% % % %% make the temp content file
% % % 
% % % % UNCOMMENT TO RERUN!!! 
% % %  %pfloat_temp_height_oco_itp


% % good for temp
 pfloat_temp_oco_itp_TEOS10_new_layers_1_tuna
 'cat'
% % %  
% % %  clearvars -except file_path file_path_out path_OHCA_data_out  file_name file_name_mean ...
% % %      file_path_hdata max_year min_year file_WOD_suf path_EN4_in path_EN4_out file_path_in ...
% % %      max_year_maps min_year_maps alltemp_extra layer_bounds ...
% % %      bad_temp_var_name ind_var_name temp_var_name ...
% % %      lon_grid_mean lat_grid_mean mean_temp_var_name ...
% % %      temp_anom_var_name temp_wod_var_name t_var_name mean_temp_oa_name ...
% % %      tdiffvar_name file_EN3_type file_name_argo  min_year_mean max_year_mean ...
% % %      file_name_season
% % % 
% % %  
% % % %% basic qc of temp content
% % % 
% % % 
% % %  'qc'
% % % % UNCOMMENT TO RERUN!!!
% % % 
% % % 
% % % %%% QC CODE NEED WORK TO RUN WITH LAYER_BOUNDS
%     qc_argo_temp_oco_new_layers_1_tuna 
    'cat'
% % %  clearvars -except file_path file_path_out path_OHCA_data_out  file_name file_name_mean ...
% % %      file_path_hdata max_year min_year file_WOD_suf path_EN4_in path_EN4_out file_path_in ...
% % %      max_year_maps min_year_maps alltemp_extra layer_bounds...?
% % %      bad_temp_var_name ind_var_name temp_var_name ...
% % %      lon_grid_mean lat_grid_mean mean_temp_var_name ...
% % %      temp_anom_var_name temp_wod_var_name t_var_name mean_temp_oa_name ...
% % %      tdiffvar_name file_EN3_type file_name_argo  min_year_mean max_year_mean ...
% % %      file_name_season
% % % 
% % % 
% % % 
% % % 
% % % %% grid the mean temp content of the Argo floats using a gausian filter
% % %  
% % %   'mean_oco'
% % % % UNCOMMENT TO RERUN!!!
% % % %%% MEAN_temp CODE NEED WORK TO RUN WITH LAYER_BOUNDS
% % % 
% % % % % % % %      mean_temp_oco_new_layers_1_tuna
% % %  clearvars -except file_path file_path_out path_OHCA_data_out  file_name file_name_mean ...
% % %      file_path_hdata max_year min_year file_WOD_suf path_EN4_in path_EN4_out file_path_in ...
% % %      max_year_maps min_year_maps alltemp_extra layer_bounds...
% % %      bad_temp_var_name ind_var_name temp_var_name ...
% % %      lon_grid_mean lat_grid_mean mean_temp_var_name ...
% % %      temp_anom_var_name temp_wod_var_name t_var_name mean_temp_oa_name ...
% % %      tdiffvar_name file_EN3_type file_name_argo  min_year_mean max_year_mean ...
% % %      file_name_season
% % % 
% % % 
% % % 
% % %  
% % % % remove mean from Argo




%%%%%%%%%%%%%%%%%%
%%% RAN TO HERE ON JULY 12th
%%%%%%%%%%%%%%%%%%%








% % % 
% % % 'make_mean_feilds_bin_oa'
% % % 
% % % % compute the SSH mean and files
% % % 
% % % 
% % % 
% % %  
% % % % UNCOMMENT WHEN NEW EN3 IS AVAILBLE 
'getwod'
%  getwod_temp_oco_EN3_teos10_new_layers_1_tuna

 'cat_out'
% % % %%% 
% % %   clearvars -except file_path file_path_out path_OHCA_data_out  file_name file_name_mean ...
% % %      file_path_hdata max_year min_year file_WOD_suf path_EN4_in path_EN4_out file_path_in ...
% % %      max_year_maps min_year_maps alltemp_extra layer_bounds...
% % %      bad_temp_var_name ind_var_name temp_var_name ...
% % %      lon_grid_mean lat_grid_mean mean_temp_var_name ...
% % %      temp_anom_var_name temp_wod_var_name t_var_name mean_temp_oa_name ...
% % %      tdiffvar_name file_EN3_type file_name_argo  min_year_mean max_year_mean ...
% % %      file_name_season
% % % 




min_year=min_year_maps;
max_year=max_year_maps;





% 
% 
% 
argo_remove_bad_profiles_layers_seasonal_tuna_temp
% 
% 
% 
% 
%  
%  %% UNCOMMENT TO RERUN!!!
% %%%%%???
bin_EN4_2021_new_layers_tuna_seasonal_temp



'interpx WOD'
   clearvars -except file_path file_path_out path_OHCA_data_out  file_name file_name_mean ...
     file_path_hdata max_year min_year file_WOD_suf path_EN4_in path_EN4_out file_path_in ...
     max_year_maps min_year_maps alltemp_extra layer_bounds...
     bad_temp_var_name ind_var_name temp_var_name ...
     lon_grid_mean lat_grid_mean mean_temp_var_name ...
     temp_anom_var_name temp_wod_var_name t_var_name mean_temp_oa_name ...
     tdiffvar_name file_EN3_type file_name_argo  min_year_mean max_year_mean ...
     file_name_season

interptpx_argo_mean_oco_WOD_2021_new_layers_seasonal_tuna_temp
   clearvars -except file_path file_path_out path_OHCA_data_out  file_name file_name_mean ...
     file_path_hdata max_year min_year file_WOD_suf path_EN4_in path_EN4_out file_path_in ...
     max_year_maps min_year_maps alltemp_extra layer_bounds...
     bad_temp_var_name ind_var_name temp_var_name ...
     lon_grid_mean lat_grid_mean mean_temp_var_name ...
     temp_anom_var_name temp_wod_var_name t_var_name mean_temp_oa_name ...
     tdiffvar_name file_EN3_type file_name_argo  min_year_mean max_year_mean ...
     file_name_season



'mapdiff WOD'

mapdiff_argo_mean_oco_EN4_2021_new_layers_seasonal_tuna_temp

  clearvars -except file_path file_path_out path_OHCA_data_out  file_name file_name_mean ...
     file_path_hdata max_year min_year file_WOD_suf path_EN4_in path_EN4_out file_path_in ...
     max_year_maps min_year_maps alltemp_extra layer_bounds...
     bad_temp_var_name ind_var_name temp_var_name ...
     lon_grid_mean lat_grid_mean mean_temp_var_name ...
     temp_anom_var_name temp_wod_var_name t_var_name mean_temp_oa_name ...
     tdiffvar_name file_EN3_type file_name_argo  min_year_mean max_year_mean ...
     file_name_season


%% make the maps


% % % % 
% % % % 'map'
% % % % %  
% % % % % 
% % % % % 
% % % % % %  
% % % % % map_t_EN3_junk_2015_new_layers_1
% % % % % 
% % % % 
% % % % 
% % % % %% run plots
% % % % year_of_oco_pub=20222; %  NEED TO CHANGE year_of_oco_pub OR TREND WONT CHANGE AND PLOTS WILL BE WRITEN OVER
% % % % %      NEED TO MAKE SURE THAT: 
% % % % %      heat_slope_file=['slope_heat_',num2str(year_of_oco_pub),'_insitu_',num2str(depth_top_plot),'_',num2str(depth_bot_plot)];
% % % % %      has been errased if you want the slope to be recomputed
% % % % %        in general the year_of_oco_pub is 2-years newer than the last year of maps
% % % % 
% % % % OHCA_map_name=['hdata_new_layers__ishii_EN3_2014_',file_name,'1990_2020_'] %NEED TO CHANGE TO MATCH OUTPUT OF OCO_MAPS_2017_2
% % % % YEARS_plot_maps=[2019 2020] %  NEED TO CHANGE TO REFLECT CURRENT YEARS 
% % % % 
% % % % depth_top_plot=0;
% % % % depth_bot_plot=700;
% % % % slope_min_year=1993; %MUST BE GREATER THAN MIN MAP YEAR IN OHCA_map_name (ie the second to last year in the name) !!!
% % % % 
% % % % 
% % % % % heat_plots_2018
% % % % 
% % % % 
