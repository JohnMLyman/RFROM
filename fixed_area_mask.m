function [good_total]=fixed_area_mask(TreeSetUp,min_depth,max_depth)


% min_depth and max_depth must be a layer bounds
tic
nbasins_use=TreeSetUp.nbasins_use;
file_name=TreeSetUp.file_name;
var_type=TreeSetUp.var_type;

file_name_season=TreeSetUp.file_name_season;
file_name_season_anom=TreeSetUp.file_name_season_anom;
file_WOD_suf=TreeSetUp.file_WOD_suf;
file_path_hdata=TreeSetUp.file_path_hdata;
fname_nc_season=TreeSetUp.fname_nc_season;
fname_nc=TreeSetUp.fname_nc;

path_ERDDAP=TreeSetUp.path_ERDDAP;

path_Fig_data=TreeSetUp.path_Fig_data;

tree_prefix=TreeSetUp.tree_prefix;
tree_model_file_name_season=TreeSetUp.tree_model_file_name_season;
tree_model_file_name_yearly=TreeSetUp.tree_model_file_name_yearly;
tree_model_file_name_all_year=TreeSetUp.tree_model_file_name_all_year;
tree_model_file_name_combined=TreeSetUp.tree_model_file_name_combined;
tree_model_file_name_combined_withcycle=TreeSetUp.tree_model_file_name_combined_withcycle;

% 
% file_name_season=[file_name,'_seasonal'];
% file_name_season_anom=[file_name_season,'_anom'];

path_oisst=TreeSetUp.path_oisst;
path_OHCA_data_out=TreeSetUp.path_OHCA_data_out;
path_OHCA_data_in=TreeSetUp.path_OHCA_data_in;
path_ssh=TreeSetUp.path_ssh;

path_tree=TreeSetUp.path_tree;
path_new_tree_season=TreeSetUp.path_new_tree_season;
path_new_tree_yearly=TreeSetUp.path_new_tree_yearly;
path_new_tree_all_year=TreeSetUp.path_new_tree_all_year;
path_new_tree_combined=TreeSetUp.path_new_tree_combined;
path_new_tree_combined_withcycle=TreeSetUp.path_new_tree_combined_withcycle;


path_tree_junk=TreeSetUp.path_tree_junk;
path_curve=TreeSetUp.path_curve;

layer_bounds=TreeSetUp.layer_bounds;

start_year=TreeSetUp.start_year;
end_year=TreeSetUp.end_year;

start_year_mean=TreeSetUp.start_year_mean;
end_year_mean=TreeSetUp.end_year_mean;
max_year_fit=TreeSetUp.max_year_fit;
min_year_fit=TreeSetUp.min_year_fit;
center_year=TreeSetUp.center_year;

start_yearly_maps=TreeSetUp.start_yearly_maps;
end_yearly_maps=TreeSetUp.end_yearly_maps;

start_all_year=TreeSetUp.start_all_year;
end_all_year=TreeSetUp.end_all_year;

start_year_trans=TreeSetUp.start_year_trans;
end_year_trans=TreeSetUp.end_year_trans;

OUTOUT_type=TreeSetUp.OUTOUT_type;

%%

%%
subdir='yearly_withcycle_no_mean';
start_year_file=start_year;
end_year_file=end_year;
path_new_tree=path_new_tree_combined_withcycle;
tree_model=tree_model_file_name_combined_withcycle;
% tree_file_name=tree_file_name_in;
%%

path_nc_erddap=[path_ERDDAP,'netcdf\',tree_prefix,'\',subdir,'\'];
if var_type=='s'
     file_prefix='RFROMV21_SAL_';
elseif var_type=='t'
     file_prefix='RFROMV21_TEMP_';
else
    file_prefix='RFROMV21_OHC_';
end
%%

% endlayer=length(layer_bounds)-1;
% startlayer=1;

time_load=floor(start_year):floor(end_year);
% load('D:\data\old_mask_tree.mat','nan_mask')
% load('D:\data\topo_tpx_new.mat','topo_tpx_new')
%  topo_tpx_new=-1.*topo_tpx_new;

file_name_nc= [path_nc_erddap,file_prefix,num2str(2010),'_',num2str(10),'.nc'];

ht_estimate=ncread(file_name_nc,'ocean_heat_content_anomaly');
depth_bounds=double(ncread(file_name_nc,'mean_depth_bnds'));
pos_min=find(depth_bounds(1,:)==min_depth);
pos_max=find(depth_bounds(2,:)==max_depth);

ht_estimate=ht_estimate(:,:,pos_min:pos_max,:);
good_total=~any(~isfinite(ht_estimate),4);

for year_load=time_load
     display(year_load)
     for imonth=1:12
        
        
        if imonth>=10
              file_name_nc= [path_nc_erddap,file_prefix,num2str(year_load),'_',num2str(imonth),'.nc'];
           else
              file_name_nc= [path_nc_erddap,file_prefix,num2str(year_load),'_0',num2str(imonth),'.nc'];
        end
        
        if exist(file_name_nc,'file')
            ht_estimate=(ncread(file_name_nc,'ocean_heat_content_anomaly'));
            ht_estimate=ht_estimate(:,:,pos_min:pos_max,:);
            good=~any(~isfinite(ht_estimate),4);
            good_total=good&good_total;
           
        end
     end
end
toc