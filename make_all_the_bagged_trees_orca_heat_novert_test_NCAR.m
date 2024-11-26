  %  This code computes all the componetes of the bagged tree and assembles
%  it.  Howerver it assumes that the data files have been made:
%  that is done in oco_maps_2021_tuna_seasonal.m : and oco_maps_2021_tuna2

 %% REWRITE COMBINE CODES!! TO TAKE INTO ACCOUNT MISSING VALUES AND 
 %% THAT ALL_YEARS AND YEARLY MAPS ARE ONLY NOW MADE FOR PART OF THE RECORD
 %% PROBABLY NEED TO RE WORK ALL OF MAKE_ALL_THE BAGGED_TREES

% % % NCAR_oco_maps_2022_orca_seasonal_heat
% % % 
% % % clearvars


% if you comment out nbsins_use it will use all the baisins howver you need
% to update load_TreeSetUp.m and also comment out
% nbasins_use=TreeSetUp.nbasins_use

%change the save -v7 warning to an error so it can be trapped and chnaged
%to -v7.3 which is larger and slower

OriginalWarning=warning('error','MATLAB:save:sizeTooBigForMATFile');
TreeSetUp=TreeSetUp_2023_orca_heat_novert_test_NCAR_old_test;
% 
tic
%% ONLY UNCOMMENT IF YOU ARE USSING DATA FILES IN THE OLD FORMAT!!
% you must uncomment fname_nc_season_old and it must be different from 
% fname_nc_season.  PROBABLY WILL NEVER USE.
% 'convert_tuna_orca_hdata'  
% convert_tuna_orca_hdata(TreeSetUp)
% toc./60/60
%%
% 
%compute the seasonal cycle 
% % % 
% % % 'make_seasonal_cycle_tree_split_orca_vert_SST_NCAR'
% % % make_seasonal_cycle_tree_split_orca_vert_SST_NCAR(TreeSetUp)
% % % 
% % % toc./60./60
% % % 
% % % % 'Delete Junk directory'
% % % delete([TreeSetUp.path_tree_junk,'*.mat']);
% % % toc./60/60
% % % 
% % % 'baggedtree_yearly_overlap_seasonal_orca_novert'
% % % baggedtree_yearly_overlap_seasonal_orca_novert(TreeSetUp)
% % % toc./60./60
% % % 
% % % 'read_ssh_matfiles_yearly_seasonal_orca_novert'
% % % read_ssh_matfiles_yearly_seasonal_orca_novert(TreeSetUp)
% % % toc./60./60
% % % 
% % % 'compute_basin_coverage'
% % % compute_basin_coverage(TreeSetUp)
% % % toc./60./60
% % % 
% % % 'make_seasonal_cycle_tree_split_orca_vert'
% % % make_seasonal_cycle_tree_split_orca_vert(TreeSetUp)
% % % toc./60./60
% % % 
% % % 'make_model_stats_yearly_seasonal_orca_vert_nosshsst_newcycle'
% % % make_model_stats_yearly_seasonal_orca_vert_nosshsst_newcycle(TreeSetUp)
% % % toc./60./60
% % % 
% % % %% Make the anomaly tree for all years
% % % 
% % % % Clear out the junkdir
% % % 'Delete Junk directory'
% % % delete([TreeSetUp.path_tree_junk,'*.mat']);
% % % toc./60/60
% % % 
% % % 
% % % 'baggedtree_hold_out_all_years_orca_novert'
% % % baggedtree_hold_out_all_years_orca_novert_fast(TreeSetUp)
% % % toc./60./60
% % % 
% % % 'read_ssh_matfiles_all_years_orca_novert'
% % % read_ssh_matfiles_all_years_orca_novert_fast(TreeSetUp)
% % % toc./60./60
% % % 
% % % 'read_ssh_matfiles_all_years_orca_novert_extra'
% % % read_ssh_matfiles_all_years_orca_novert_extra_fast(TreeSetUp)
% % % toc./60./60
% % % 
% % % 'make_model_stats_all_years_orca_vert_nosshsst'
% % % make_model_stats_all_years_orca_novert_fast(TreeSetUp)
% % % toc./60./60

%% Make the yearlly anomally tree
% 

% Clear out the junkdir
'Delete Junk directory'
delete([TreeSetUp.path_tree_junk,'*.mat']);
toc./60/60


'baggedtree_hold_out_yearlyseasonal_anom_orca_novert'
baggedtree_hold_out_yearlyseasonal_anom_orca_novert_fast(TreeSetUp)
toc./60./60

'read_ssh_matfiles_yearly_seasonal_anom_orca_novert'
read_ssh_matfiles_yearly_seasonal_anom_orca_novert_fast(TreeSetUp)
toc./60./60

'make_model_stats_yearly_seasonal_anom_orca_vert_nosshsst'
make_model_stats_yearly_seasonal_anom_orca_novert_fast(TreeSetUp)

toc./60./60

'make_combined_files'
make_combined_files(TreeSetUp)
toc./60./60

'multi_add_seasonal_cycle'

multi_add_seasonal_cycle_combined(TreeSetUp)

toc./60./60

multi_write_erddap_file_withoutcycle_NCAR(TreeSetUp)
toc./60./60


'multi_write_erddap_file_withcycle'

multi_write_erddap_file_withcycle_NCAR(TreeSetUp)
toc./60./60

'multi_write_erddap_file_withcycle_nomean_v21'
% must run multi_write_erddap_file_withcycle(TreeSetUp) first.  It makes
% the netcdffiles that mean is comuted from.
multi_write_erddap_file_withcycle_nomean_v21_NCAR(TreeSetUp) 
toc./60./60

% 'multi_write_erddap_file_withcycle_nomean_v21_reatime'
% % % must run multi_write_erddap_file_withcycle(TreeSetUp) first.  It makes
% % % the netcdffiles that mean is comuted from.
% multi_write_erddap_file_withcycle_nomean_v21_NCAR(TreeSetUp) 
% toc./60./60

tic
'make_1x1xmonth_files_v2'
make_1x1xmonth_files_v21(TreeSetUp)
toc./60./60

% % % %% make the vertical intral curves and maps from no mean netcdf files.
% % % 'bagged_tree_ohca_curve_7_day_errdp_ohca'
% % % bagged_tree_ohca_curve_7_day_errdp_ohca(TreeSetUp,0,700)
% % % bagged_tree_ohca_curve_7_day_errdp_ohca_writenc(TreeSetUp,0,2000)
% % % bagged_tree_ohca_curve_7_day_errdp_ohca(TreeSetUp,700,2000)
% % % 
% % % 
% % % toc./60./60
% % % % plot the curves
% % % 'plot_oco_curves'
% % % plot_oco_curves(TreeSetUp)
% % % 
% % % toc./60./60.
% % % 
% % % % make the heatcontent maps
% % % 'heat_plots_2023_orca'
% % % heat_plots_2023_orca(TreeSetUp)
% % % toc./60./60.
% % % 
% % % %make_movie
% % % 'tree_movie_0_2000'
% % % tree_movie_0_2000(TreeSetUp)
% % % toc./60./60.
% % % 
% % % %% test_ceres_curve_new_2.m on tuna makes ceres curve!! need to move it to ORCA