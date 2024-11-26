%  This code computes all the componetes of the bagged tree and assembles
%  it.  Howerver it assumes that the data files have been made:
%  that is done in oco_maps_2021_tuna_seasonal.m : and oco_maps_2021_tuna2

 
clearvars


% if you comment out nbsins_use it will use 1:10 the baisins howver you need
% to update load_TreeSetUp.m and also comment out


nbasins_use=[1:9];
nbasins_use=[1:3,5,9,10,11]; % see find_basin_paige.m for what the basin numbers are defined as
file_name='argo_2021_02_02_QC';

path_oisst='C:\data\oisst\';
path_OHCA_data_out='C:\data\OHCA\'
path_OHCA_data_in='C:\OHCA\'
file_WOD_suf='_cheng_EN4_2014';
tree_prefix='tree_sst_gaps_2';


tree_model_file_name_season=[tree_prefix,'_all_year_overlap_seasonal'];
tree_model_file_name_yearly=[tree_prefix,'_yearly_overlap_seasonal_anom'];
tree_model_file_name_all_year=[tree_prefix,'_all_year_seasonal_anom'];
tree_model_file_name_combined=[tree_prefix,'_combined_seasonal_anom'];




file_name_season=[file_name,'_seasonal'];
file_name_season_anom=[file_name_season,'_anom'];
path_ssh=[path_OHCA_data_in,'Mtpers\'];
file_path_hdata=[path_OHCA_data_out,'OHCA_maps\'];

path_tree=[path_OHCA_data_out,'OHCA_trees\',tree_prefix,'\'];


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

%% load vars into TreeSetUp
TreeSetUp.nbasins_use=nbasins_use;
TreeSetUp.file_name=file_name;

TreeSetUp.file_name_season=file_name_season;
TreeSetUp.file_name_season_anom=file_name_season_anom;
TreeSetUp.file_WOD_suf=file_WOD_suf;
TreeSetUp.file_path_hdata=file_path_hdata;
TreeSetUp.fname_nc_season=fname_nc_season;
TreeSetUp.fname_nc=fname_nc;

TreeSetUp.tree_prefix=tree_prefix;
TreeSetUp.tree_model_file_name_season=tree_model_file_name_season;
TreeSetUp.tree_model_file_name_yearly=tree_model_file_name_yearly;
TreeSetUp.tree_model_file_name_all_year=tree_model_file_name_all_year;
TreeSetUp.tree_model_file_name_combined=tree_model_file_name_combined;

TreeSetUp.path_oisst=path_oisst;
TreeSetUp.path_OHCA_data_out=path_OHCA_data_out;
TreeSetUp.path_OHCA_data_in=path_OHCA_data_in;
TreeSetUp.path_ssh=path_ssh;

TreeSetUp.path_tree=path_tree;
TreeSetUp.path_new_tree_season=path_new_tree_season;
TreeSetUp.path_new_tree_yearly=path_new_tree_yearly;
TreeSetUp.path_new_tree_all_year=path_new_tree_all_year;

TreeSetUp.path_tree_junk=path_tree_junk;
TreeSetUp.path_curve=path_curve;

TreeSetUp.layer_bounds=layer_bounds;

TreeSetUp.start_year=start_year;
TreeSetUp.end_year=end_year;

TreeSetUp.start_year_mean=start_year_mean;
TreeSetUp.end_year_mean=end_year_mean;
TreeSetUp.max_year_fit=max_year_fit;
TreeSetUp.min_year_fit=min_year_fit;
TreeSetUp.center_year=center_year;

TreeSetUp.start_yearly_maps=start_yearly_maps;
TreeSetUp.end_yearly_maps=end_yearly_maps;

TreeSetUp.start_all_year=start_all_year;
TreeSetUp.end_all_year=end_all_year;

TreeSetUp.start_year_trans=start_year_trans;
TreeSetUp.end_year_trans=end_year_trans;

% % % % % 


bagged_tree_ohca_combine_split_sst_mask(TreeSetUp)