function []=multi_write_erddap_file_withcycle_v21(TreeSetUp)



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



%%
% tree_model=[tree_model_file_name_yearly,'_withcycle'];
% path_new_tree=[path_new_tree_yearly,'withcycle/'];
subdir='yearly_withcycle';
start_year_file=start_year;
end_year_file=end_year;
path_new_tree=path_new_tree_combined_withcycle;
tree_model=tree_model_file_name_combined_withcycle;
% tree_file_name=tree_file_name_in;
%%

path_nc_erddap=[path_ERDDAP,'netcdf\',tree_prefix,'\',subdir,'\'];
if var_type=='s'
     file_prefix='RFROMV22_SAL_';
elseif var_type=='t'
     file_prefix='RFROMV22_TEMP_';
elseif var_type=='h'
     file_prefix='RFROMV22_OHC_';
end

if ~exist(path_nc_erddap,'dir')
    mkdir(path_nc_erddap)
end
% because the data is geroup by year if the start year is a whole number
% then the files will start in the pervious year
start_year_ssh=floor(start_year_file);
if floor(start_year_file)==start_year_file
    start_year_ssh=start_year_file-1;
end
end_year_ssh=floor(end_year_file);
time_ssh_load=start_year_ssh:end_year_ssh;




%%

if var_type=='h'
    mean_depth=(layer_bounds(1:end-1)+layer_bounds(2:end))./2;
    mean_depth=mean_depth';
    mean_depth_bnds=[layer_bounds(1:end-1); layer_bounds(2:end)];
else
    mean_pressure=(layer_bounds(1:end-1)+layer_bounds(2:end))./2;
    mean_pressure=mean_pressure';
    mean_pressure_bnds=[layer_bounds(1:end-1); layer_bounds(2:end)];
end

for year_load=time_ssh_load

    
   
    [ht_estimate,lat_tpx,lon_tpx,time_aviso]=...
        make_vertical_year(path_new_tree,tree_model,year_load,TreeSetUp);
    year_aviso=floor(time_aviso);
    aviso_day=1+(time_aviso-year_aviso).*yeardays(year_aviso);
    sday=round(aviso_day+datenum(year_aviso,1,1)-1);
    days_since_1950=sday-datenum(1950,1,1);
    [~,month_data]=datevec(days_since_1950+datenum(1950,1,1));
    
    for imonth=1:12
        good_month=month_data==imonth;
        time_1950=days_since_1950(good_month);

        if ~isempty(time_1950)
            mon_estimate=ht_estimate(:,:,:,good_month);


            if imonth>=10
                  file_name_nc= [path_nc_erddap,file_prefix,num2str(year_load),'_',num2str(imonth),'.nc'];
               else
                  file_name_nc= [path_nc_erddap,file_prefix,num2str(year_load),'_0',num2str(imonth),'.nc'];
            end
            if var_type =='t'
         
                 write_netcfd_cf_temp_pressure_mon_singlev22(mon_estimate,time_1950,lon_tpx,...
                       lat_tpx,mean_pressure,mean_pressure_bnds,file_name_nc)
            elseif var_type=='s'
                 write_netcfd_cf_sal_pressure_mon_singlev22(mon_estimate,time_1950,lon_tpx,...
                       lat_tpx,mean_pressure,mean_pressure_bnds,file_name_nc)
            elseif var_type=='h'
                write_netcfd_cf_heat_depth_mon_singlev22(mon_estimate,time_1950,lon_tpx,...
                   lat_tpx,mean_depth,mean_depth_bnds,file_name_nc)
            end
 
        end

    end
       
    
end

end
