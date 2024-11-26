file_path='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/'
file_path_out='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
file_name='pfloat_sal_greg_jan_2011_new'
file_path_hdata='/Users/johnlyman/data/Globalhc/HC/'


max_year=2011;
min_year=2004;


% % %% bin then OA
  [data_grid,lon,lat]=load_and_grid_matlab_season_test3_bin(file_path_out,file_path,file_name);
% % % 
% % % data_grid_bin=data_grid;
% % % 
 [data_grid_oa,lon,lat]=load_and_grid_matlab_season_test3_oa(file_path_out,file_path,file_name);
% % % 
% % % % %%  multi covarence function OA
% % % % 
% % % % 
% % % % %[data_grid,lon,lat]=load_and_grid_matlab_season_test3_oa_only(file_path_out,file_path,file_name);
% % % % 
% % % % 
% % % % %% remove mean
% % % % 
  remove_argo_mean_oa_oco_bin
% % 
% % 
% % %% bin data on seasonal grid
 [iyear]=load_and_grid_matlab_season_test2_bin(file_path_out,file_path,file_name);
% % 
% % 
% % 
% % 
% % %% compute OA bin seasion
% % 
 [iyear]=load_and_grid_matlab_season_test2_bin_oa(file_path_out,file_path,file_name);
% % 
% % % remove seasonal cycle
% % 
% % 
% % 'remove season'
% % 
 remove_argo_mean_oa_oco_bin_season
% % 
% % %% interptpx
% % 
% % 
% % 'interptpx'
% % 
 interptpx_argo_mean_oco_bin
% % 
% % 
% % %% mapdiff
% % 
mapdiff_argo_mean_oco_bin
% % 
% % %% monthly grid


%%  Combine with WOD

% % 'remove mean and sesonal cycle from WOD and add it to Argo and ITPs'

remove_argo_mean_oa_seasonal_cycle_WOD_bin

'interpx WOD'

interptpx_argo_mean_oco_WOD

'mapdiff WOD'

mapdiff_argo_mean_oco_no_season_WOD


%% make the mapes

'map'

map_ht_1800_900_700_300_100