clearvars


% if you comment out nbsins_use it will use all the baisins howver you need
% to update load_TreeSetUp.m and also comment out
% nbasins_use=TreeSetUp.nbasins_use

nbasins_use=[1:9];
nbasins_use=[5];
file_name='argo_2021_02_02_QC';

path_oisst='C:\data\oisst\';
path_OHCA_data_out='C:\data\OHCA\'
path_OHCA_data_in='C:\OHCA\'
file_WOD_suf='_cheng_EN4_2014';
var_type='s';
tree_prefix='tree_sal_atlatic_1temp';
tree_prefix_temp='tree_temp_atlatic';
path_mat_nc='C:\JUNK\netcdf\';

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

fname_nc_season=[file_path_hdata,'sdata_new_layers_',file_WOD_suf,'_',file_name_season];
fname_nc=[file_path_hdata,'sdata_new_layers_',file_WOD_suf,'_',file_name_season_anom];



path_tree_junk='C:\JUNK\';
path_curve=[path_OHCA_data_out,'OHCA_curves\'];

layer_bounds=[0, 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125,...
    135, 145, 155, 165, 175, 190, 210, 230, 250, 270, 290, 310, 330 , ...
    350, 370 , 390, 410,  430, 450, 475, 525, 575, 625, 675, 725, 775,...
    825, 875, 925, 975, 1025, 1075, 1125, 1175, 1225, 1275, 1325, 1375,...
    1450, 1550, 1650, 1750, 1850, 1950, 2000]% layer_bounds must be in assending order

start_year=1993.5;
end_year=2021.5;

start_year_mean=2007.5;
end_year_mean=2021.5;% THIS SHOULD BE ONLY AS LONG AS THE DELAYED MODE SSH DATA WHERE THE MEAN HAS BEEN DEFINED.
max_year_fit=2020;% it doesn't go to 2021 because of there is not enough delayed mode data.
min_year_fit=2008;
center_year=(max_year_fit+min_year_fit)./2;

start_yearly_maps=2005.5;
end_yearly_maps=2021.5;

start_all_year=1993.5;
end_all_year=2021.5;

start_year_trans=2006;
end_year_trans=2007;

nlayer_use=0;