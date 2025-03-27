  %  This code computes all the componetes of the bagged tree and assembles
%  it.  Howerver it assumes that the data files have been made:
%  that is done in oco_maps_2021_tuna_seasonal.m : and oco_maps_2021_tuna2

 %% REWRITE COMBINE CODES!! TO TAKE INTO ACCOUNT MISSING VALUES AND 
 %% THAT ALL_YEARS AND YEARLY MAPS ARE ONLY NOW MADE FOR PART OF THE RECORD
 %% PROBABLY NEED TO RE WORK ALL OF MAKE_ALL_THE BAGGED_TREES

% % % oco_maps_2023_orca_seasonal_temp_press
% % % oco_maps_2023_orca_seasonal and
% oco_maps_2023_orca_seasonal_temp_press are the same
% % % clearvars


% if you comment out nbsins_use it will use all the baisins howver you need
% to update load_TreeSetUp.m and also comment out
% nbasins_use=TreeSetUp.nbasins_use
% 
% [TreeSetUp]=TreeSetUp_2024_orca_temp_press_novert_paige_sulu;

% [TreeSetUp]=TreeSetUp_2025_orca_temp_press_novert_paige_sulu_eqbox;
[TreeSetUp]=TreeSetUp_2025_orca_temp_press_novert_paige_sulu_eqbox_vert;
tic


%% compute the seasonal cycle 

'Delete Junk directory'
delete([TreeSetUp.path_tree_junk,'*.mat']);
toc./60/60


'baggedtree_hold_out_all_years_seasonal_orca_vert'
% baggedtree_hold_out_all_years_seasonal_orca_novert_paige_eqbox(TreeSetUp)
baggedtree_hold_out_all_years_seasonal_orca_vert(TreeSetUp)


toc./60/60

'read_ssh_matfiles_all_years_season_orca_vert_eqbox'
% read_ssh_matfiles_all_years_season_orca_novert_paige_eqbox(TreeSetUp)
read_ssh_matfiles_all_years_season_orca_vert_eqbox(TreeSetUp)

% 

'compute_basin_coverage'
compute_basin_coverage(TreeSetUp)
toc./60./60

'make_seasonal_cycle_tree_split_orca_vert'
make_seasonal_cycle_tree_split_orca_vert_paige(TreeSetUp)
toc./60./60
% % % 
% % % 'make_model_stats_yearly_seasonal_orca_vert_nosshsst_newcycle'
% % % make_model_stats_yearly_seasonal_orca_vert_nosshsst_newcycle(TreeSetUp)
% % % toc./60./60
% % % 
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
% % % baggedtree_hold_out_all_years_orca_novert_paige(TreeSetUp)
% % % toc./60./60
% % % 
% % % 'read_ssh_matfiles_all_years_orca_novert'
% % % read_ssh_matfiles_all_years_orca_novert_paige(TreeSetUp)
% % % toc./60./60
% % % 
% % % 'read_ssh_matfiles_all_years_orca_novert_extra'
% % % read_ssh_matfiles_all_years_orca_novert_extra_paige(TreeSetUp)
% % % toc./60./60
% % % 
% % % 'make_model_stats_all_years_orca_vert_nosshsst'
% % % make_model_stats_all_years_orca_vert_nosshsst_fast(TreeSetUp)
% % % toc./60./60
% % % % % 
% % % % Make the yearlly anomally tree
% % % 
% % % 
% % % % Clear out the junkdir
% % % 'Delete Junk directory'
% % % delete([TreeSetUp.path_tree_junk,'*.mat']);
% % % toc./60/60
% % % 
% % % 
% % % 'baggedtree_hold_out_yearlyseasonal_anom_orca_novert'
% % % baggedtree_hold_out_yearlyseasonal_anom_orca_eqbox(TreeSetUp)
% % % toc./60./60
% % % 
% % % 'read_ssh_matfiles_yearly_seasonal_anom_orca_novert_fast_eqbox'
% % % read_ssh_matfiles_yearly_seasonal_anom_orca_novert_fast_eqbox(TreeSetUp)
% % % % 
% % % % 'read_ssh_matfiles_yearly_seasonal_anom_orca_novert_eqbox_skip'
% % % % read_ssh_matfiles_yearly_seasonal_anom_orca_novert_eqbox_skip(TreeSetUp)
% % % 
% % % toc./60./60
% % % 
% % % % 'make_model_stats_yearly_seasonal_anom_orca_vert_nosshsst'
% % % % make_model_stats_yearly_seasonal_anom_orca_vert_nosshsst(TreeSetUp)
% % % 
% % % toc./60./60
% % % 
% % % 'make_combined_files'
% % % make_combined_files(TreeSetUp)
% % % toc./60./60
% % % 
% % % 'multi_add_seasonal_cycle'
% % % 
% % % 
% % % multi_add_seasonal_cycle_combined_filt(TreeSetUp)
% % % toc./60./60
% % % 
% % % 'multi_write_erddap_file_withcycle'
% % % 
% % % multi_write_erddap_file_withcycle_v22(TreeSetUp)
% % % toc./60./60
% % % 
% % % 'make_1x1xmonth_files_v2'
% % % make_1x1xmonth_files_v22_paige(TreeSetUp)
% % % toc./60./60


% multi_write_erddap_file(TreeSetUp,[TreeSetUp.path_new_tree_yearly,'withcycle/'],...
%     [TreeSetUp.tree_model_file_name_yearly,'_withcycle']...
%     ,'yearly_withcycle',TreeSetUp.start_yearly_maps,TreeSetUp.end_yearly_maps)






%% Make combines ohca maps for all_years and yearly
% 
% 'bagged_tree_ohca_combine_split_orca'
% bagged_tree_ohca_combine_split_orca(TreeSetUp)
% 


