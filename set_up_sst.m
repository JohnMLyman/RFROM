nbasins_use=[1:3,5,9,10]; % see find_basin_paige.m for what the basin numbers are defined as
file_name='argo_2021_02_02_QC';

path_oisst='C:\data\oisst\';
path_OHCA_data_out='C:\data\OHCA\'
path_OHCA_data_in='C:\OHCA\'
file_WOD_suf='_cheng_EN4_2014';
tree_prefix='tree_sst_gaps';


tree_model_file_name_season=[tree_prefix,'_yearly_overlap_seasonal'];
tree_model_file_name_yearly=[tree_model_file_name_season,'_anom'];
tree_model_file_name_all_year=[tree_prefix,'_all_year_seasonal_anom'];
tree_model_file_name_combined=[tree_prefix,'_combined_seasonal_anom'];

file_name_season=[file_name,'_seasonal'];
file_name_season_anom=[file_name_season,'_anom'];
path_ssh=[path_OHCA_data_in,'Mtpers\'];
file_path_hdata=[path_OHCA_data_out,'OHCA_maps\'];

path_tree=[path_OHCA_data_out,'OHCA_trees\',tree_prefix,'\'];
% path_tree=[path_OHCA_data_out,'OHCA_trees\'];

if ~exist(path_tree,'dir')
    mkdir(path_tree)
end

path_new_tree_season=[path_tree,tree_model_file_name_season,'\'];
path_new_tree_yearly=[path_tree,tree_model_file_name_yearly,'\'];
path_new_tree_all_year=[path_tree,tree_model_file_name_all_year,'\'];


fname_nc_season=[file_path_hdata,'hdata_new_layers_',file_WOD_suf,'_',file_name_season];
fname_nc=[file_path_hdata,'hdata_new_layers_',file_WOD_suf,'_',file_name_season_anom];



path_tree_junk='C:\JUNK\';
path_curve=[path_OHCA_data_out,'OHCA_curves\'];

layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];

start_year=1993.5;
end_year=2021.5;

start_year_mean=2007.5;
end_year_mean=2021.5;
max_year_fit=2020;
min_year_fit=2008;
center_year=(max_year_fit+min_year_fit)./2;

start_yearly_maps=2005.5;
end_yearly_maps=2021.5;

start_all_year=1993.5;
end_all_year=2021.5;

start_year_trans=2006;
end_year_trans=2007;
