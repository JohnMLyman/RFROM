function [TreeSetUp]=TreeSetUp_2025_orca_sal_paige_sulu_deep()


nbasins_use=[1:10,12:13];
nbasins_use_extra_all_years=[4,6:10,12:13];

% nbasins_use=[5];
% file_name='argo_2021_02_02_QC';
file_name='argo_2023_03_23_QC_press';
file_name='argo_2024_9_9_QC_deep_topo';
file_name='argo_2025_1_3_QC_deep_topo'

path_oisst='D:\oisst\';
path_OHCA_data_out='D:\';
path_OHCA_data_in='D:\';
path_main_tree='M:\';
path_main_tree_temp='J:\';
path_main_error='H:\';

file_WOD_suf='_cheng_EN4_2014';
var_type='s';
tree_prefix='tree_sal_novert';
tree_prefix_temp='tree_temp_novert';
path_mat_nc='D:\monthly_temp\';
path_ERDDAP='N:\erddap_filt_anomt\sal_novert_sulu_2025';
path_ERDDAP_sal=path_ERDDAP;
path_ERDDAP_temp='N:\erddap_filt\temp_novert_sulu_2025';

% tree_model_file_name_season=[tree_prefix,'_yearly_overlap_seasonal'];
% tree_model_file_name_yearly=[tree_model_file_name_season,'_anom'];
tree_model_file_name_season=[tree_prefix,'_all_year_seasonal'];
tree_model_file_name_yearly=[tree_model_file_name_season,'_anom_junk'];
tree_model_file_name_all_year=[tree_prefix,'_all_year_seasonal_anom'];
tree_model_file_name_combined=[tree_prefix,'_combined_seasonal_anom'];
tree_model_file_name_combined_withcycle=[tree_prefix,'_combined_seasonal_anom_wc'];

% Because only the all year model is made set it to the combined name
tree_model_file_name_combined=tree_model_file_name_all_year;

tree_model_file_name_season_temp=[tree_prefix_temp,'_yearly_overlap_seasonal'];
tree_model_file_name_all_year_season_temp=[tree_prefix_temp,'_all_year_seasonal'];

tree_model_file_name_combined_temp=[tree_prefix_temp,'_combined_seasonal_anom'];
tree_model_file_name_combined_withcycle_temp=[tree_prefix_temp,'_combined_seasonal_anom_wc'];
tree_model_file_name_combined_withoutcycle_temp=[tree_prefix_temp,'_combined_seasonal_anom_woc'];

tree_model_file_name_season_temp=tree_model_file_name_all_year_season_temp;
% tree_model_file_name_combined_temp=tree_model_file_name_all_year_temp;
% tree_model_file_name_combined_withcycle_temp=[tree_prefix_temp,'_all_year_seasonal_anom_wc'];
% tree_model_file_name_combined_withoutcycle_temp=[tree_prefix_temp,'_all_year_seasonal_anom_woc'];


file_name_season=[file_name,'_seasonal'];
file_name_season_anom=[file_name_season,'_anom_anomt_all'];
path_ssh=[path_OHCA_data_in,'Mtpers\'];
file_path_hdata=[path_OHCA_data_out,var_type,'_maps\'];

path_tree=[path_main_tree,tree_prefix,'\',var_type,'_trees\'];
path_tree_temp=[path_main_tree_temp,tree_prefix_temp,'\','t','_trees\'];
path_error=[path_main_error,tree_prefix,'\',var_type,'_error\'];
% path_tree=[path_OHCA_data_out,'OHCA_trees\'];

if ~exist(path_tree,'dir')
    mkdir(path_tree)
end
% if ~exist(path_error,'dir')
%     mkdir(path_error)
% end
path_new_tree_season=[path_tree,tree_model_file_name_season,'\'];
path_new_tree_yearly=[path_tree,tree_model_file_name_yearly,'\'];
path_new_tree_all_year=[path_tree,tree_model_file_name_all_year,'\'];
path_new_tree_combined=[path_tree,'combined\'];
path_new_tree_combined_withcycle=[path_tree,'combined_withcycle_filt\'];
path_new_tree_combined_temp=[path_tree_temp,'combined\'];
path_new_tree_combined_withcycle_temp=[path_tree_temp,'combined_withcycle_filt\'];
path_new_tree_combined_withoutcycle_temp=[path_tree_temp,'combined_withoutcycle_filt\'];

path_new_error_season=[path_error,tree_model_file_name_season,'\'];
path_new_error_yearly=[path_error,tree_model_file_name_yearly,'\'];
path_new_error_all_year=[path_error,tree_model_file_name_all_year,'\'];

fname_nc_season=[file_path_hdata,var_type,'data_new_layers_',file_WOD_suf,'_',file_name_season];
fname_nc=[file_path_hdata,var_type,'data_new_layers_',file_WOD_suf,'_',file_name_season_anom];

fname_nc_all=[file_path_hdata,var_type,'data_new_layers_',file_WOD_suf,'_',file_name_season_anom];
fname_nc_all_season=[file_path_hdata,var_type,'data_new_layers_',file_WOD_suf,'_',file_name_season];
file_name_basin_coverage=[path_tree,var_type,'data_new_layers_',file_WOD_suf,'_',file_name_season,'_basin_coverage.mat'];


path_tree_junk='O:\JUNK\';
path_tree_junk2='K:\JUNK\';

path_curve=[path_main_tree,tree_prefix,'\',var_type,'_curves\'];

if ~exist(path_tree_junk,'dir')
    mkdir(path_tree_junk)
end

if ~exist(path_tree_junk2,'dir')
    mkdir(path_tree_junk2)
end

if ~exist(path_curve,'dir')
    mkdir(path_curve)
end

layer_bounds=[0, 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125,...
    135, 145, 155, 165, 175, 190, 210, 230, 250, 270, 290, 310, 330 , ...
    350, 370 , 390, 410,  430, 450, 475, 525, 575, 625, 675, 725, 775,...
    825, 875, 925, 975, 1025, 1075, 1125, 1175, 1225, 1275, 1325, 1375,...
    1450, 1550, 1650, 1750, 1850, 1950, 2000]% layer_bounds must be in assending order

percent_good_fit=.5;% the percent of good times you need to make fit an annual cycle


ilayer_depth_use_ssh=find(layer_bounds>1000,1,'first');
ilayer_depth_use_sst=find(layer_bounds>100,1,'first');

start_year=1993.5;
end_year=2024;

start_year_mean=2009.5; %if you want the weekly maps to start in jan 2007 the start_year is 2007.5
end_year_mean=2020.5;
max_year_fit=2019;
min_year_fit=2010;
center_year=(max_year_fit+min_year_fit)./2;

start_year_trans=2006;
end_year_trans=2007;

%  Because there is no yearly model and only a all year model in this run I set the year of
%  transition into the distant future

start_year_trans=4000;
end_year_trans=4001;


diff_trans=end_year_trans-start_year_trans+1;

%% NEED TO COMMENT UNCOMMENTED PARTS OF THIS SECTION 

% start_yearly_maps=2010.5;
start_yearly_maps=end_year_trans-diff_trans+.5;
% end_yearly_maps=2015.5;
end_yearly_maps=end_year;
% start_year=start_yearly_maps;
% end_year=end_yearly_maps;
%%

% this is the year that the yearly maps start to save to a different drive
% because of space!!  if Junk dir is repaced with a larger drive then junk2
% can be removed

sal_yearly_year_junk2=start_yearly_maps+14;
% start_all_year=1993.5;
start_all_year=start_year;

% end_all_year=2008.5;
end_all_year=start_year_trans+diff_trans+.5;
end_all_year=end_year;

nlayer_use=3;

%% load vars into TreeSetUp
TreeSetUp.nbasins_use=nbasins_use;
TreeSetUp.nbasins_use_extra_all_years=nbasins_use_extra_all_years;

TreeSetUp.file_name=file_name;
TreeSetUp.var_type=var_type;

TreeSetUp.file_name_season=file_name_season;
TreeSetUp.file_name_season_anom=file_name_season_anom;
TreeSetUp.file_WOD_suf=file_WOD_suf;
TreeSetUp.file_path_hdata=file_path_hdata;

TreeSetUp.fname_nc_season=fname_nc_season;
TreeSetUp.fname_nc=fname_nc;
TreeSetUp.fname_nc_all=fname_nc_all;
TreeSetUp.fname_nc_all_season=fname_nc_all_season;
TreeSetUp.file_name_basin_coverage=file_name_basin_coverage;

TreeSetUp.tree_prefix_temp=tree_prefix_temp;
TreeSetUp.path_mat_nc=path_mat_nc;
TreeSetUp.path_ERDDAP=path_ERDDAP;
TreeSetUp.path_ERDDAP_sal=path_ERDDAP_sal;
TreeSetUp.path_ERDDAP_temp=path_ERDDAP_temp;


TreeSetUp.tree_prefix=tree_prefix;
TreeSetUp.tree_model_file_name_season=tree_model_file_name_season;
TreeSetUp.tree_model_file_name_yearly=tree_model_file_name_yearly;
TreeSetUp.tree_model_file_name_all_year=tree_model_file_name_all_year;
TreeSetUp.tree_model_file_name_combined=tree_model_file_name_combined;
TreeSetUp.tree_model_file_name_combined=tree_model_file_name_combined;
TreeSetUp.tree_model_file_name_combined_withcycle=tree_model_file_name_combined_withcycle;


TreeSetUp.tree_model_file_name_season_temp=tree_model_file_name_season_temp;
TreeSetUp.tree_model_file_name_combined_temp=tree_model_file_name_combined_temp;
TreeSetUp.tree_model_file_name_combined_withcycle_temp=tree_model_file_name_combined_withcycle_temp;
TreeSetUp.tree_model_file_name_combined_withoutcycle_temp=tree_model_file_name_combined_withoutcycle_temp;




TreeSetUp.path_oisst=path_oisst;
TreeSetUp.path_OHCA_data_out=path_OHCA_data_out;
TreeSetUp.path_OHCA_data_in=path_OHCA_data_in;
TreeSetUp.path_ssh=path_ssh;

TreeSetUp.path_tree=path_tree;
TreeSetUp.path_tree_temp=path_tree_temp;

TreeSetUp.path_error=path_error;

TreeSetUp.path_new_tree_season=path_new_tree_season;
TreeSetUp.path_new_tree_yearly=path_new_tree_yearly;
TreeSetUp.path_new_tree_all_year=path_new_tree_all_year;
TreeSetUp.path_new_tree_combined=path_new_tree_combined;
TreeSetUp.path_new_tree_combined_withcycle=path_new_tree_combined_withcycle;
TreeSetUp.path_new_tree_combined_temp=path_new_tree_combined_temp;
TreeSetUp.path_new_tree_combined_withcycle_temp=path_new_tree_combined_withcycle_temp;
TreeSetUp.path_new_tree_combined_withoutcycle_temp=path_new_tree_combined_withoutcycle_temp;

TreeSetUp.path_new_error_season=path_new_error_season;
TreeSetUp.path_new_error_yearly=path_new_error_yearly;
TreeSetUp.path_new_error_all_year=path_new_error_all_year;

TreeSetUp.path_tree_junk=path_tree_junk;
TreeSetUp.path_tree_junk2=path_tree_junk2;
TreeSetUp.path_curve=path_curve;

TreeSetUp.layer_bounds=layer_bounds;
TreeSetUp.percent_good_fit=percent_good_fit;
TreeSetUp.ilayer_depth_use_sst=ilayer_depth_use_sst;
TreeSetUp.ilayer_depth_use_ssh=ilayer_depth_use_ssh;

TreeSetUp.start_year=start_year;
TreeSetUp.end_year=end_year;

TreeSetUp.start_year_mean=start_year_mean;
TreeSetUp.end_year_mean=end_year_mean;
TreeSetUp.max_year_fit=max_year_fit;
TreeSetUp.min_year_fit=min_year_fit;
TreeSetUp.center_year=center_year;

TreeSetUp.start_yearly_maps=start_yearly_maps;
TreeSetUp.end_yearly_maps=end_yearly_maps;
TreeSetUp.sal_yearly_year_junk2=sal_yearly_year_junk2;

TreeSetUp.start_all_year=start_all_year;
TreeSetUp.end_all_year=end_all_year;

TreeSetUp.start_year_trans=start_year_trans;
TreeSetUp.end_year_trans=end_year_trans;
 
TreeSetUp.nlayer_use=nlayer_use;
