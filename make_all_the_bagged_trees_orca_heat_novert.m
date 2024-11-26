  %  This code computes all the componetes of the bagged tree and assembles
%  it.  Howerver it assumes that the data files have been made:
%  that is done in oco_maps_2021_tuna_seasonal.m : and oco_maps_2021_tuna2

 %% REWRITE COMBINE CODES!! TO TAKE INTO ACCOUNT MISSING VALUES AND 
 %% THAT ALL_YEARS AND YEARLY MAPS ARE ONLY NOW MADE FOR PART OF THE RECORD
 %% PROBABLY NEED TO RE WORK ALL OF MAKE_ALL_THE BAGGED_TREES

% % % oco_maps_2023_orca_seasonal_heat
% % % 
% % % clearvars

[TreeSetUp]=TreeSetUp_2023_orca_heat_novert;


%%
% 
% compute the seasonal cycle 

'Delete Junk directory'
delete([TreeSetUp.path_tree_junk,'*.mat']);
toc./60/60

'baggedtree_yearly_overlap_seasonal_orca_vert_nosshsst_newcycle'
baggedtree_yearly_overlap_seasonal_orca_vert_nosshsst_newcycle(TreeSetUp)
toc./60./60

'read_ssh_matfiles_yearly_seasonal_orca_vert_nosshsst_newcycle'
read_ssh_matfiles_yearly_seasonal_orca_vert_nosshsst_newcycle(TreeSetUp)
toc./60./60

'compute_basin_coverage'
compute_basin_coverage(TreeSetUp)
toc./60./60

'make_seasonal_cycle_tree_split_orca_vert'
make_seasonal_cycle_tree_split_orca_vert(TreeSetUp)
toc./60./60

'make_model_stats_yearly_seasonal_orca_vert_nosshsst_newcycle'
make_model_stats_yearly_seasonal_orca_vert_nosshsst_newcycle(TreeSetUp)
toc./60./60

%% Make the anomaly tree for all years

% Clear out the junkdir
'Delete Junk directory'
delete([TreeSetUp.path_tree_junk,'*.mat']);
toc./60/60


'baggedtree_hold_out_all_years_orca_vert_nosshsst'
baggedtree_hold_out_all_years_orca_vert_nosshsst(TreeSetUp)
toc./60./60

'read_ssh_matfiles_all_years_orca_vert_nosshsst'
read_ssh_matfiles_all_years_orca_vert_nosshsst(TreeSetUp)
toc./60./60

'read_ssh_matfiles_all_years_orca_vert_nosshsst_extra'
read_ssh_matfiles_all_years_orca_vert_nosshsst_extra(TreeSetUp)
toc./60./60

'make_model_stats_all_years_orca_vert_nosshsst'
make_model_stats_all_years_orca_vert_nosshsst(TreeSetUp)
toc./60./60

%% Make the yearlly anomally tree
% 

% Clear out the junkdir
'Delete Junk directory'
delete([TreeSetUp.path_tree_junk,'*.mat']);
toc./60/60


'baggedtree_hold_out_yearlyseasonal_anom_orca_vert_nosshsst'
baggedtree_hold_out_yearlyseasonal_anom_orca_vert_nosshsst(TreeSetUp)
toc./60./60

'read_ssh_matfiles_yearly_seasonal_anom_orca_vert_nosshsst'
read_ssh_matfiles_yearly_seasonal_anom_orca_vert_nosshsst(TreeSetUp)
toc./60./60

'make_model_stats_yearly_seasonal_anom_orca_vert_nosshsst'
make_model_stats_yearly_seasonal_anom_orca_vert_nosshsst(TreeSetUp)

toc./60./60

'make_combined_files'
make_combined_files(TreeSetUp)
toc./60./60

'multi_add_seasonal_cycle'

multi_add_seasonal_cycle_combined(TreeSetUp)

toc./60./60

'multi_write_erddap_file_withcycle'

multi_write_erddap_file_withcycle(TreeSetUp)
toc./60./60

'multi_write_erddap_file_withcycle_nomean_v2'
% must run multi_write_erddap_file_withcycle(TreeSetUp) first.  It makes
% the netcdffiles that mean is comuted from.
multi_write_erddap_file_withcycle_nomean_v2(TreeSetUp) 
toc./60./60

'multi_write_erddap_file_withcycle_nomean_v2_reatime'
% must run multi_write_erddap_file_withcycle(TreeSetUp) first.  It makes
% the netcdffiles that mean is comuted from.
multi_write_erddap_file_withcycle_nomean_v21_realtime(TreeSetUp) 
toc./60./60

tic
'make_1x1xmonth_files_v2'
make_1x1xmonth_files_v21(TreeSetUp)
toc./60./60

%% make the vertical intral curves and maps from no mean netcdf files.
'bagged_tree_ohca_curve_7_day_errdp_ohca'
bagged_tree_ohca_curve_7_day_errdp_ohca(TreeSetUp,0,700)
bagged_tree_ohca_curve_7_day_errdp_ohca(TreeSetUp,0,2000)
bagged_tree_ohca_curve_7_day_errdp_ohca(TreeSetUp,700,2000)

toc./60./60
% plot the curves
'plot_oco_curves'
plot_oco_curves(TreeSetUp)

toc./60./60.

% make the heatcontent maps
'heat_plots_2023_orca'
heat_plots_2023_orca(TreeSetUp)