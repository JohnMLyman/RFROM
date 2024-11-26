  %  This code computes all the componetes of the bagged tree and assembles
%  it.  Howerver it assumes that the data files have been made:
%  that is done in oco_maps_2021_tuna_seasonal.m : and oco_maps_2021_tuna2

 %% REWRITE COMBINE CODES!! TO TAKE INTO ACCOUNT MISSING VALUES AND 
 %% THAT ALL_YEARS AND YEARLY MAPS ARE ONLY NOW MADE FOR PART OF THE RECORD
 %% PROBABLY NEED TO RE WORK ALL OF MAKE_ALL_THE BAGGED_TREES

% % % oco_maps_2022_orca_seasonal_temp_press
% % % 
% % % clearvars


% if you comment out nbsins_use it will use all the baisins howver you need
% to update load_TreeSetUp.m and also comment out
% nbasins_use=TreeSetUp.nbasins_use

nbasins_use=[1:10];
nbasins_use_extra_all_years=[4,6:10];
% file_name='argo_2021_02_02_QC';
file_name='ofam3_EN4';
OUTOUT_type='\ME4OH_2023_novert';% could change to 'Karina_2023'

path_oisst='D:\ME4OH\oisst\';
path_OHCA_data_out='D:\ME4OH\';e
path_OHCA_data_in='D:\ME4OH\';
path_main_tree='D:\ME4OH\';
path_main_error='D:\ME4OH\';

file_WOD_suf=[];
var_type='h';
tree_prefix='tree_heat_novert';% change to 'tree_heat_vert_Karina' if you change the layers

% tree_prefix='tree_temp_vert_nosshsst';
path_ERDDAP='H:\ME4OH\heat_novert';
path_Figs='H:\ME4OH\Figs\OHC\';
path_Fig_data='H:\ME4OH\Figs\OHC\data\';

tree_model_file_name_season=[tree_prefix,'_yearly_overlap_seasonal'];
tree_model_file_name_yearly=[tree_model_file_name_season,'_anom'];
tree_model_file_name_all_year=[tree_prefix,'_all_year_seasonal_anom'];
tree_model_file_name_combined=[tree_prefix,'_combined_seasonal_anom'];
tree_model_file_name_combined_withcycle=[tree_prefix,'_combined_seasonal_anom_wc'];


file_name_season=[file_name,'_seasonal'];
file_name_season_anom=[file_name_season,'_anom'];
path_ssh=[path_OHCA_data_in,'Mtpers\'];
file_path_hdata=[path_OHCA_data_out,var_type,'_maps\'];

path_tree=[path_main_tree,tree_prefix,'\',var_type,'_trees\'];
path_error=[path_main_error,tree_prefix,'\',var_type,'_error\'];
% path_tree=[path_OHCA_data_out,'OHCA_trees\'];

if ~exist(path_tree,'dir')
    mkdir(path_tree)
end
if ~exist(path_error,'dir')
    mkdir(path_error)
end
if ~exist(path_Fig_data,'dir')
    mkdir(path_Fig_data)
end

if ~exist(path_Figs,'dir')
    mkdir(path_Figs)
end
path_new_tree_season=[path_tree,tree_model_file_name_season,'\'];
path_new_tree_yearly=[path_tree,tree_model_file_name_yearly,'\'];
path_new_tree_all_year=[path_tree,tree_model_file_name_all_year,'\'];
path_new_tree_combined=[path_tree,'combined\'];
path_new_tree_combined_withcycle=[path_tree,'combined_withcycle\'];

path_new_error_season=[path_error,tree_model_file_name_season,'\'];
path_new_error_yearly=[path_error,tree_model_file_name_yearly,'\'];
path_new_error_all_year=[path_error,tree_model_file_name_all_year,'\'];

fname_nc_season=[file_path_hdata,var_type,'data_new_layers_',file_WOD_suf,'_',file_name_season];
fname_nc=[file_path_hdata,var_type,'data_new_layers_',file_WOD_suf,'_',file_name_season_anom];
% fname_nc_season_old=[file_path_hdata,var_type,'data_new_layers_',file_WOD_suf,'_',file_name_season];

fname_nc_season_old=fname_nc_season;% COMMENT THIS LINE OUT IF YOU ARE RUNNIG 
% convert_tuna_orca_hdata    

fname_nc_all=fname_nc;

file_name_basin_coverage=[path_tree,var_type,'data_new_layers_',file_WOD_suf,'_',file_name_season,'_basin_coverage.mat'];



path_tree_junk='O:\JUNK\';
path_curve=[path_main_tree,tree_prefix,'\',var_type,'_curves\'];

if ~exist(path_tree_junk,'dir')
    mkdir(path_tree_junk)
end
if ~exist(path_curve,'dir')
    mkdir(path_curve)
end

% layer_bounds=[0, 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125,...
%     135, 145, 155, 165, 175, 190, 210, 230, 250, 270, 290, 310, 330 , ...
%     350, 370 , 390, 410,  430, 450, 475, 525, 575, 625, 675, 725, 775,...
%     825, 875, 925, 975, 1025, 1075, 1125, 1175, 1225, 1275, 1325, 1375,...
%     1450, 1550, 1650, 1750, 1850, 1950, 2000];% layer_bounds must be in assending order
layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];

L1_ind1=1;
L1_ind2=4;

L2_ind1=5;
L2_ind2=6;

L3_ind1=7;
L3_ind2=10;

percent_good_fit=.5;% the percent of good times you need to make fit an annual cycle

ilayer_depth_use_ssh=find(layer_bounds>10000,1,'first');
ilayer_depth_use_sst=find(layer_bounds>100,1,'first');

% these are the years of the data that are used for making the all years bagged trees
%       it is also sets the start when all_year makes maps, and the end
%       when yearly makes maps.  except for the transintion from allyears
%       to yearly and the deffinition of the fit of the cycle.  the years
%       are centerd in the middle of the year, ie 1993.5 is the whole year
%       of 1993.

% YOU ONKY NEED TO CHANGE start_year AND end_year THE REST WILL HAPEN
% AUTOMATICALLY

start_year=1993.5;%if you want the weekly maps to start in jan 2007 the start_year is 2007.5
end_year=2014.5;

start_year_mean=2006.5; %if you want the weekly maps to start in jan 2007 the start_year is 2007.5
end_year_mean=2013.5;
max_year_fit=2012;% keep these away from the ends of start_year_mean and end_year mean wo theat you have overlaping years to compute the mean from.
min_year_fit=2007;


center_year=(max_year_fit+min_year_fit)./2;

start_year_trans=2006;
end_year_trans=2007;

diff_trans=end_year_trans-start_year_trans+1;

% start_yearly_maps=2005.5;
start_yearly_maps=end_year_trans-diff_trans+.5;
% end_yearly_maps=2022.5;
end_yearly_maps=end_year;

% start_all_year=1993.5;
start_all_year=start_year;

% end_all_year=2008.5;
end_all_year=start_year_trans+diff_trans+.5;

start_year_mean_remove=1993;
end_year_mean_remove=2014;
% load vars into TreeSetUp
TreeSetUp.nbasins_use=nbasins_use;
TreeSetUp.nbasins_use_extra_all_years=nbasins_use_extra_all_years;


TreeSetUp.file_name=file_name;
TreeSetUp.OUTOUT_type=OUTOUT_type;
TreeSetUp.var_type=var_type;

TreeSetUp.file_name_season=file_name_season;
TreeSetUp.file_name_season_anom=file_name_season_anom;
TreeSetUp.file_WOD_suf=file_WOD_suf;
TreeSetUp.file_path_hdata=file_path_hdata;

TreeSetUp.fname_nc_season=fname_nc_season;
TreeSetUp.fname_nc=fname_nc;
TreeSetUp.fname_nc_season_old=fname_nc_season_old;
TreeSetUp.fname_nc_all=fname_nc_all;


TreeSetUp.file_name_basin_coverage=file_name_basin_coverage;

TreeSetUp.path_ERDDAP=path_ERDDAP;
TreeSetUp.path_Figs=path_Figs;
TreeSetUp.path_Fig_data=path_Fig_data;


TreeSetUp.tree_prefix=tree_prefix;
TreeSetUp.tree_model_file_name_season=tree_model_file_name_season;
TreeSetUp.tree_model_file_name_yearly=tree_model_file_name_yearly;
TreeSetUp.tree_model_file_name_all_year=tree_model_file_name_all_year;
TreeSetUp.tree_model_file_name_combined=tree_model_file_name_combined;
TreeSetUp.tree_model_file_name_combined_withcycle=tree_model_file_name_combined_withcycle;

TreeSetUp.path_oisst=path_oisst;
TreeSetUp.path_OHCA_data_out=path_OHCA_data_out;
TreeSetUp.path_OHCA_data_in=path_OHCA_data_in;
TreeSetUp.path_ssh=path_ssh;

TreeSetUp.path_tree=path_tree; 
TreeSetUp.path_error=path_error;



TreeSetUp.path_new_tree_season=path_new_tree_season;
TreeSetUp.path_new_tree_yearly=path_new_tree_yearly;
TreeSetUp.path_new_tree_all_year=path_new_tree_all_year;
TreeSetUp.path_new_tree_combined=path_new_tree_combined;
TreeSetUp.path_new_tree_combined_withcycle=path_new_tree_combined_withcycle;

TreeSetUp.path_new_error_season=path_new_error_season;
TreeSetUp.path_new_error_yearly=path_new_error_yearly;
TreeSetUp.path_new_error_all_year=path_new_error_all_year;

TreeSetUp.path_tree_junk=path_tree_junk;
TreeSetUp.path_curve=path_curve;

TreeSetUp.layer_bounds=layer_bounds;

TreeSetUp.L1_ind1=L1_ind1;
TreeSetUp.L1_ind2=L1_ind2;
TreeSetUp.L2_ind1=L2_ind1;
TreeSetUp.L2_ind2=L2_ind2;
TreeSetUp.L3_ind1=L3_ind1;
TreeSetUp.L3_ind2=L3_ind2;

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

TreeSetUp.start_all_year=start_all_year;
TreeSetUp.end_all_year=end_all_year;

TreeSetUp.start_year_trans=start_year_trans;
TreeSetUp.end_year_trans=end_year_trans;

TreeSetUp.start_year_mean_remove=start_year_mean_remove;
TreeSetUp.end_year_mean_remove=end_year_mean_remove;
tic

make_seasonal_cycle_tree_split_orca_vert_SST_ME4OH(TreeSetUp)

%% ONLY UNCOMMENT IF YOU ARE USSING DATA FILES IN THE OLD FORMAT!!

% compute the seasonal cycle 

'make_seasonal_cycle_tree_split_orca_vert_SST_ME4OH'
make_seasonal_cycle_tree_split_orca_vert_SST_ME4OH(TreeSetUp)

toc./60./60
'Delete Junk directory'
delete([path_tree_junk,'*.mat']);
toc./60/60

'baggedtree_yearly_overlap_seasonal_orca_novert'
baggedtree_yearly_overlap_seasonal_orca_novert(TreeSetUp)
toc./60./60

'read_ssh_matfiles_yearly_seasonal_orca_novert'
read_ssh_matfiles_yearly_seasonal_orca_novert(TreeSetUp)
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
delete([path_tree_junk,'*.mat']);
toc./60/60


'baggedtree_hold_out_all_years_orca_novert'
baggedtree_hold_out_all_years_orca_novert(TreeSetUp)
toc./60./60

'read_ssh_matfiles_all_years_orca_novert'
read_ssh_matfiles_all_years_orca_novert(TreeSetUp)
toc./60./60

'read_ssh_matfiles_all_years_orca_novert_extra'
read_ssh_matfiles_all_years_orca_novert_extra(TreeSetUp)
toc./60./60


'make_model_stats_all_years_orca_vert_nosshsst'
make_model_stats_all_years_orca_vert_nosshsst(TreeSetUp)
toc./60./60

%% Make the yearlly anomally tree
% 

% Clear out the junkdir
'Delete Junk directory'
delete([path_tree_junk,'*.mat']);
toc./60/60



'baggedtree_hold_out_yearlyseasonal_anom_orca_novert'
baggedtree_hold_out_yearlyseasonal_anom_orca_novert(TreeSetUp)
toc./60./60

'read_ssh_matfiles_yearly_seasonal_anom_orca_novert'
read_ssh_matfiles_yearly_seasonal_anom_orca_novert(TreeSetUp)
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

multi_write_erddap_file_withcycle_ME4OH(TreeSetUp)
toc./60./60

'multi_write_erddap_file_withcycle_nomean'
% must run multi_write_erddap_file_withcycle(TreeSetUp) first.  It makes
% the netcdffiles that mean is comuted from.
multi_write_erddap_file_withcycle_nomean_ME4OH(TreeSetUp) 
toc./60./60

'make_ME4OH_files'
% masked 
make_ME4OH_files(TreeSetUp)
toc./60./60
%% make the vertical intral curves and maps from no mean netcdf files.
% 'bagged_tree_ohca_curve_7_day_errdp_ohca'
% bagged_tree_ohca_curve_7_day_errdp_ohca(TreeSetUp,0,700)
% bagged_tree_ohca_curve_7_day_errdp_ohca(TreeSetUp,0,2000)
% bagged_tree_ohca_curve_7_day_errdp_ohca(TreeSetUp,700,2000)
% 
% toc./60./60
% % plot the curves
% 'plot_oco_curves'
% plot_oco_curves(TreeSetUp)
% 
% toc./60./60.
% 
% % make the heatcontent maps
% 'heat_plots_2023_orca'
% heat_plots_2023_orca(TreeSetUp)