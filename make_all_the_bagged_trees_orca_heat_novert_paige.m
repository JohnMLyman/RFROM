  %  This code computes all the componetes of the bagged tree and assembles
%  it.  Howerver it assumes that the data files have been made:
%  that is done in oco_maps_2021_tuna_seasonal.m : and oco_maps_2021_tuna2

 %% REWRITE COMBINE CODES!! TO TAKE INTO ACCOUNT MISSING VALUES AND 
 %% THAT ALL_YEARS AND YEARLY MAPS ARE ONLY NOW MADE FOR PART OF THE RECORD
 %% PROBABLY NEED TO RE WORK ALL OF MAKE_ALL_THE BAGGED_TREES

% % % NCAR_maps_2022_orca_seasonal_heat
% % % 
% % % clearvars

tic
%change the save -v7 warning to an error so it can be trapped and chnaged
%to -v7.3 which is larger and slower however if the save is called in a
%parfor loop then warning in the loop must be set to the 

OriginalWarning=warning('error','MATLAB:save:sizeTooBigForMATFile');

TreeSetUp=TreeSetUp_2023_orca_heat_novert_test_paige;
'Delete Junk directory'
delete([TreeSetUp.path_tree_junk,'*.mat']);
toc./60/60

baggedtree_hold_out_all_years_seasonal_orca_novert_paige(TreeSetUp)
'baggedtree_hold_out_all_years_seasonal_orca_novert_paige'
toc./60/60

'read_ssh_matfiles_all_years_season_orca_novert_paige'
read_ssh_matfiles_all_years_season_orca_novert_paige(TreeSetUp)

toc./60/60
% % % multi_write_erddap_file_withcycle_NCAR_all_years_season(TreeSetUp)
% % % 'multi_write_erddap_file_withcycle_NCAR_all_years_season'
% % % toc./60/60
'compute_basin_coverage'
compute_basin_coverage(TreeSetUp)
toc./60./60

'make_seasonal_cycle_tree_split_orca_vert'
make_seasonal_cycle_tree_split_orca_vert(TreeSetUp)
toc./60./60

'make_model_stats_all_years_season_orca_vert_nosshsst_paige'
make_model_stats_all_years_season_orca_novert_nosshsst_paige(TreeSetUp)
% % % toc./60./60

%% Make the anomaly tree for all years

% Clear out the junkdir
'Delete Junk directory'
delete([TreeSetUp.path_tree_junk,'*.mat']);
toc./60/60


'baggedtree_hold_out_all_years_orca_novert'
baggedtree_hold_out_all_years_orca_novert_paige(TreeSetUp)
toc./60./60

'read_ssh_matfiles_all_years_orca_novert'
read_ssh_matfiles_all_years_orca_novert_paige(TreeSetUp)
toc./60./60


'make_model_stats_all_years_orca_vert_nosshsst'
make_model_stats_all_years_orca_novert_nosshsst_paige(TreeSetUp)
toc./60./60



'multi_add_seasonal_cycle'

multi_add_seasonal_cycle_combined(TreeSetUp)

toc./60./60

'multi_write_erddap_file_withcycle'

multi_write_erddap_file_withcycle(TreeSetUp)
toc./60./60

'multi_write_erddap_file_withcycle_nomean_v21'
% must run multi_write_erddap_file_withcycle(TreeSetUp) first.  It makes
% the netcdffiles that mean is comuted from.
multi_write_erddap_file_withcycle_nomean_v21(TreeSetUp) 
toc./60./60

% % % 'multi_write_erddap_file_withcycle_nomean_v21_reatime'
% % % % % must run multi_write_erddap_file_withcycle(TreeSetUp) first.  It makes
% % % % % the netcdffiles that mean is comuted from.
% % % multi_write_erddap_file_withcycle_nomean_v21_realtime(TreeSetUp) 
toc./60./60

tic
'make_1x1xmonth_files_v2'
make_1x1xmonth_files_v21(TreeSetUp)
toc./60./60

% set warnings back to orignal sate
warning(OriginalWarning)
% % % %% make the vertical intral curves and maps from no mean netcdf files.
% 'bagged_tree_ohca_curve_7_day_errdp_ohca'
% bagged_tree_ohca_curve_7_day_errdp_ohca(TreeSetUp,0,700)
% bagged_tree_ohca_curve_7_day_errdp_ohca_writenc(TreeSetUp,0,2000)
% bagged_tree_ohca_curve_7_day_errdp_ohca(TreeSetUp,700,2000)


toc./60./60
% plot the curves
% % % 'plot_oco_curves'
% % % plot_oco_curves(TreeSetUp)
% % % 
% % % toc./60./60.
% % % % % % 
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