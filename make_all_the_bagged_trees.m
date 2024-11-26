%  This code computes all the componetes of the bagged tree and assembles
%  it.  Howerver it assumes that the data files have been made:
%  that is done in oco_maps_2021_tuna_seasonal.m : and oco_maps_2021_tuna2

 %% REWRITE COMBINE CODES!! TO TAKE INTO ACCOUNT MISSING VALUES AND 
 %% THAT ALL_YEARS AND YEARLY MAPS ARE ONLY NOW MADE FOR PART OF THE RECORD
 %% PROBABLY NEED TO RE WORK ALL OF MAKE_ALL_THE BAGGED_TREES
clearvars
file_name='argo_2021_02_02_QC'




start_year_mean=2007.5;
end_year_mean=2021.5;
max_year_fit=2020;
min_year_fit=2008;

start_year=1993.5;
end_year=2021.5;

center_year=(max_year_fit+min_year_fit)./2;

% compute the seasonal cycle 
% 
% baggedtree_hold_out_yearly_overlap_seasonal
% clearvars -except file_name max_year_fit min_year_fit center_year ...
%     start_year end_year start_year_mean end_year_mean
% 
% close all
% 
% read_ssh_matfiles_yearly_overlap_seasonal
% clearvars -except file_name max_year_fit min_year_fit center_year ...
%     start_year end_year start_year_mean end_year_mean
% close all
% 
% make_seasonal_cycle_tree
% clearvars -except file_name max_year_fit min_year_fit center_year ...
%     start_year end_year start_year_mean end_year_mean
% close all
% 
% 
% make_model_stats_yearly_overlap_seasonal
% clearvars -except file_name max_year_fit min_year_fit center_year ...
%     start_year end_year start_year_mean end_year_mean
% close all
% 
% %% Make the yearlly anomally tree
% 
% baggedtree_hold_out_yearly_overlap_seasonal_anom
% clearvars -except file_name max_year_fit min_year_fit center_year ...
%     start_year end_year
% close all
% 
% 
% read_ssh_matfiles_yearly_overlap_seasonal_anom
% 
% clearvars -except file_name max_year_fit min_year_fit center_year ...
%     start_year end_year
% close all
% 
% make_model_stats_yearly_overlap_seasonal_anom
% clearvars -except file_name max_year_fit min_year_fit center_year ...
%     start_year end_year
% close all
% % % % 
% 
% 
% 
% 
% 
% 
% %% Make the anomaly tree for all years

% baggedtree_hold_out_all_years_seasonal_anom
% clearvars -except file_name max_year_fit min_year_fit center_year ...
%     start_year end_year
% close all
% % 
% read_ssh_matfiles_all_years_seasonal_anom
% %  read_ssh_matfiles_all_years_seasonal_anom_test
% % 
% % clearvars -except file_name max_year_fit min_year_fit center_year ...
% %     start_year end_year
% % close all
% 
% make_model_stats_all_years_seasonal_anom
% clearvars -except file_name max_year_fit min_year_fit center_year ...
%     start_year end_year
% close all
% %% Make combines ohca maps for all_years and yearly
% 
 %% REWRITE COMBINE CODES!! TO TAKE INTO ACCOUNT MISSING VALUES AND 
 %% THAT ALL_YEARS AND YEARLY MAPS ARE ONLY NOW MADE FOR PART OF THE RECORD
 %% PROBABLY NEED TO RE WORK ALL OF MAKE_ALL_THE BAGGED_TREES
% % bagged_tree_ohca_combine
% % bagged_tree_ohca_combine_2

% clearvars -except file_name max_year_fit min_year_fit center_year ...
%     start_year end_year
% close all
% 
% % make asses the error
% 
% make_error_holdout_estimate_files_yearly_season_anom
% 
% close all
% clearvars -except file_name max_year_fit min_year_fit center_year ...
%     start_year end_year
% 
% make_error_holdout_estimate_files_all_years_season_anom
% close all
% clearvars -except file_name max_year_fit min_year_fit center_year ...
%     start_year end_year
% % make the varience 
% % 
% % make_bagged_tree_var
% % clearvars -except file_name max_year_fit min_year_fit center_year ...
% %     start_year end_year
% % close all
% 
% 
% error_holdout_all_years_test_weights
% clearvars -except file_name max_year_fit min_year_fit center_year ...
%     start_year end_year
% % 
% error_holdout_yearly_test_weights
% clearvars -except file_name max_year_fit min_year_fit center_year ...
%     start_year end_year
% 

 %% REWRITE COMBINE CODES!! TO TAKE INTO ACCOUNT MISSING VALUES AND 
 %% THAT ALL_YEARS AND YEARLY MAPS ARE ONLY NOW MADE FOR PART OF THE RECORD
 %% PROBABLY NEED TO RE WORK ALL OF MAKE_ALL_THE BAGGED_TREES
% bagged_tree_ohca_error_combine
% clearvars -except file_name max_year_fit min_year_fit center_year ...
%     start_year end_year

% % make the 7-day ohca curve 0-2000m error
% bagged_tree_ohca_curve_7_day_error_weight
% 
% clearvars -except file_name max_year_fit min_year_fit center_year ...
%     start_year end_year
% 
% %%%%%%%%%%%% THESE CODES NEED to BE TESTED TO MAKE SUTRE THAT THEY WORK
% %%%%%%%%%%%% WITH THIS CODE
% % % % % make the 7-day ohca curve 0-2000m 
% 
% % % % % % make a sesonal cycle to add to the heat content
% 
% make_bagged_tree_ohca_maps_7_day_seasonal
% clearvars -except file_name max_year_fit min_year_fit center_year ...
%     start_year end_year
% % % % % % make the curve
% 
% bagged_tree_ohca_curve_7_day_with_cycle_combined
'in'
bagged_tree_ohca_curve_7_day_with_cycle_combined_max
% clearvars -except file_name max_year_fit min_year_fit center_year ...
% %     start_year end_year
% % %% makes the error maps for the 0-700 m yearly-ohca map
% % bagged_tree_ohca_error_maps
% % 
% % close all
% % clear all
% 
% plot_map_bagged_tree_paper_error
% 
% close all
% clear all
% 
% plot_map_bagged_tree_paper_error_7day
% close all
% clear all
% tree_movie
% 
% close all
% clear all
% multi_write_netcdf_nc_heat

% close all
% clear all
% multi_write_netcdf_nc_heat_error
