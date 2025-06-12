function [lon,lat,mean_depth,mean_depth_bnds,yr_out,ohca_out]=load_heat_netcdf_all_yea_v2(years_load,TreeSetUp)

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
subdir='yearly_withcycle_season_all_year';
subdir='yearly_withcycle_no_mean';
subdir='yearly_withcycle';
start_year_file=start_year_mean;
end_year_file=end_year_mean;
path_new_tree=path_new_tree_season;
tree_model=tree_model_file_name_season;
% tree_file_name=tree_file_name_in;
%%

path_nc_erddap=[path_ERDDAP,'netcdf\',tree_prefix,'\',subdir,'\'];
file_prefix='RFROMV2_OHC_';

nlayers=length(layer_bounds)-1;
ntime=(max(years_load)-min(years_load)+1).*365./5;

ohca_out=nan(1440,720,nlayers,ntime);
time_out=nan(1,ntime);

start_ind=1;

for year_load=years_load

    
   
   
    for imonth=1:12
        

     

            if imonth>=10
                  file_name_nc= [path_nc_erddap,file_prefix,num2str(year_load),'_',num2str(imonth),'.nc'];
               else
                  file_name_nc= [path_nc_erddap,file_prefix,num2str(year_load),'_0',num2str(imonth),'.nc'];
            end

            time=ncread(file_name_nc,'time')+datenum(1950,1,1);
            ntime_junk=length(time);
            end_ind=start_ind+ntime_junk-1;
            ohca=ncread(file_name_nc,'ocean_heat_content_anomaly');
            time_out(start_ind:end_ind)=time;
            ohca_out(:,:,:,start_ind:end_ind)=ohca;
            start_ind=end_ind+1;

           
    end
 
end

time_out=time_out(1:end_ind);
ohca_out=ohca_out(:,:,:,1:end_ind);
lon=ncread(file_name_nc,'longitude');
lat=ncread(file_name_nc,'latitude');


mean_depth=ncread(file_name_nc,'mean_depth');
mean_depth_bnds=ncread(file_name_nc,'mean_depth_bnds');

if isfield(TreeSetUp,'data_type')
    switch TreeSetUp.data_type
        case ('NCAR') %no leapyear
             yr_out=(time_out-1)./365;
        otherwise
          [time_year,~]=datevec(time_out);
          time_year=int64(time_year);
           yr_out=double(time_year)+(time_out-datenum(double(time_year),1,1))./yeardays(time_year);

            
    end
else

[time_year,~]=datevec(time_out);
time_year=int64(time_year);
            yr_out=double(time_year)+(time_out-datenum(double(time_year),1,1))./yeardays(time_year);


end

end
