file_path='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/'
file_path_out='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
file_name='pfloat_sal_greg_jan_2012'
file_path_hdata='/Users/johnlyman/data/Globalhc/HC/'


max_year=2011;
min_year=2004;


%% bin then OAs
%% UNCOMMENT TO RERUN!!!

  [data_grid,lon,lat]=load_and_grid_matlab_season_test3_bin(file_path_out,file_path,file_name);
  [data_grid,lon,lat]=load_and_grid_matlab_season_test3_bin_height(file_path_out,file_path,file_name);
% % % 
% % % data_grid_bin=data_grid;
% % % 
%% UNCOMMENT TO RERUN!!!
 
 [data_grid_oa,lon,lat]=load_and_grid_matlab_season_test3_oa(file_path_out,file_path,file_name);
 [data_grid_oa,lon,lat]=load_and_grid_matlab_season_test3_oa_height(file_path_out,file_path,file_name);
% % % 
% % % % %%  multi covarence function OA
% % % % 
% % % % 
% % % % %[data_grid,lon,lat]=load_and_grid_matlab_season_test3_oa_only(file_path_out,file_path,file_name);
% % % % 
% % % % 
% % % % %% remove mean
% % % % 

%% UNCOMMENT TO RERUN!!!
remove_argo_mean_oa_oco_bin
clearvars -except file_path file_path_out file_name file_path_hdata max_year min_year

remove_argo_mean_oa_oco_bin_height
clearvars -except file_path file_path_out file_name file_path_hdata max_year min_year


% % 
% % 
% % %% bin data on seasonal grid
%% UNCOMMENT TO RERUN!!!

 [iyear]=load_and_grid_matlab_season_test2_bin(file_path_out,file_path,file_name);
 [iyear]=load_and_grid_matlab_season_test2_bin_height(file_path_out,file_path,file_name);
% % 
% % 
% % 
% % 
% % %% compute OA bin seasion
% % 
%% UNCOMMENT TO RERUN!!!

[iyear]=load_and_grid_matlab_season_test2_bin_oa(file_path_out,file_path,file_name);
 [iyear]=load_and_grid_matlab_season_test2_bin_oa_height(file_path_out,file_path,file_name);
% % 
% % % remove seasonal cycle
% % 
% % 
% % 'remove season'
% % 
%% UNCOMMENT TO RERUN!!!

 remove_argo_mean_oa_oco_bin_season
 clearvars -except file_path file_path_out file_name file_path_hdata max_year min_year

 remove_argo_mean_oa_oco_bin_season_height
 clearvars -except file_path file_path_out file_name file_path_hdata max_year min_year

% % 
% % %% interptpx
% % 
% % 
% % 'interptpx'
% % 
%% UNCOMMENT TO RERUN!!!
clearvars -except file_path file_path_out file_name file_path_hdata max_year min_year

 interptpx_argo_mean_oco_bin
 clearvars -except file_path file_path_out file_name file_path_hdata max_year min_year

 interptpx_argo_mean_oco_bin_height
 clearvars -except file_path file_path_out file_name file_path_hdata max_year min_year

% % 
% % 
% % %% mapdiff
% % 
%% UNCOMMENT TO RERUN!!!
clearvars -except file_path file_path_out file_name file_path_hdata max_year min_year

mapdiff_argo_mean_oco_bin
clearvars -except file_path file_path_out file_name file_path_hdata max_year min_year

mapdiff_argo_mean_oco_bin_height
clearvars -except file_path file_path_out file_name file_path_hdata max_year min_year

% % 
% % %% monthly grid


%%  Combine with WOD
% % 
%% UNCOMMENT THIS WHOLE SECTION WHEN THE WOD DATA HAS BEEN QC'D
%  'remove mean and sesonal cycle from WOD and add it to Argo and ITPs'
% 
% remove_argo_mean_oa_seasonal_cycle_WOD_bin
% remove_argo_mean_oa_seasonal_cycle_WOD_bin_height
% 
% 'interpx WOD'
% 
% interptpx_argo_mean_oco_WOD
% interptpx_argo_mean_oco_WOD_height
% 
% 'mapdiff WOD'
% 
% mapdiff_argo_mean_oco_no_season_WOD
% mapdiff_argo_mean_oco_no_season_WOD_height
% 
% %% make the mapes
% 
% 'map'
% 
% map_ht_1800_900_700_300_100