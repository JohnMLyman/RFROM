file_path='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/'
file_path_out='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'

file_path_hdata='/Users/johnlyman/data/Globalhc/HC/'
allheat_extra='_new';

% %% bin then OA
%% UNCOMMENT TO RERUN!!!

 [data_grid,lon,lat]=load_and_grid_matlab_season_test3_bin(file_path_out,file_path,file_name_mean);
% [data_grid,lon,lat]=load_and_grid_matlab_season_test3_bin_height(file_path_out,file_path,file_name_mean);

% % % 
%% UNCOMMENT TO RERUN!!!
 
[data_grid_oa,lon,lat]=load_and_grid_matlab_season_test3_oa(file_path_out,file_path,file_name_mean);
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

remove_argo_mean_oa_oco_bin_2013
%remove_argo_mean_oa_oco_bin_height

% % 
% % 
% % %% bin data on seasonal grid
%% UNCOMMENT TO RERUN!!!

[iyear]=load_and_grid_matlab_season_test2_bin(file_path_out,file_path,file_name_mean);
%[iyear]=load_and_grid_matlab_season_test2_bin_height(file_path_out,file_path,file_name_mean);
% % 
% % 
% % 
% % 
% % %% compute OA bin seasion
% % 
%% UNCOMMENT TO RERUN!!!

[iyear]=load_and_grid_matlab_season_test2_bin_oa(file_path_out,file_path,file_name_mean);
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

remove_argo_mean_oa_oco_bin_season_2013
%remove_argo_mean_oa_oco_bin_season_height

% % 
% % %% interptpx
% % 
% % 
% % 'interptpx'
% % 
%UNCOMMENT TO RERUN!!!

interptpx_argo_mean_oco_bin_2014_junk
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
 'remove mean and sesonal cycle from WOD and add it to Argo and ITPs'

 
 
remove_argo_mean_oa_seasonal_cycle_WOD_bin_EN3_2013
%%remove_argo_mean_oa_seasonal_cycle_WOD_bin_height_EN3

'interpx WOD'
clearvars -except file_WOD_suf file_path file_path_out file_name file_name_mean file_path_hdata max_year min_year path_EN3

interptpx_argo_mean_oco_WOD_2014
clearvars -except file_WOD_suf file_path file_path_out file_name file_name_mean file_path_hdata max_year min_year path_EN3
%%interptpx_argo_mean_oco_WOD_height
clearvars -except file_WOD_suf file_path file_path_out file_name file_name_mean file_path_hdata max_year min_year path_EN3
'mapdiff WOD'

mapdiff_argo_mean_oco_no_season_WOD_EN3_2013
clearvars -except file_WOD_suf file_path file_path_out file_name file_name_mean file_path_hdata max_year min_year path_EN3
%%mapdiff_argo_mean_oco_no_season_WOD_height_EN3
clearvars -except file_WOD_suf file_path file_path_out file_name file_name_mean file_path_hdata max_year min_year path_EN3

%% make the mapes

'map'
clearvars -except file_WOD_suf file_path file_path_out file_name file_name_mean file_path_hdata max_year min_year path_EN3
%map_ht_1800_900_700_300_100_EN3
clear all 



 % 
  file_WOD_suf='_ishii_EN3_2014'
 path_EN3='/Volumes/Data/EN3/ishiiXBTMBT_2014/';
% 

 
file_path='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/'
file_path_out='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
file_name='pfloat_sal_greg_jan_2013'
file_name='pfloat_sal_greg_Dec_2014_QC'
file_name_mean='pfloat_sal_greg_Dec_2014_QC'
file_path_hdata='/Users/johnlyman/data/Globalhc/HC/'


'map'
clearvars -except file_WOD_suf file_path file_path_out file_name file_path_hdata max_year min_year path_EN3
 file_WOD_suf='_ishii_EN3_2014'
 path_EN3='/Volumes/Data/EN3/ishiiXBTMBT_2014/';

map_ht_1800_900_700_300_100_EN3_junk_2014
