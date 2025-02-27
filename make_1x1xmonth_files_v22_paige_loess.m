function []=make_1x1xmonth_files_v22_paige_loess(TreeSetUp)

% MUST MAKE NETCDF WITH MEAN FIRST!!!!!

nbasins_use=TreeSetUp.nbasins_use;
file_name=TreeSetUp.file_name;
var_type=TreeSetUp.var_type;

file_name_season=TreeSetUp.file_name_season;
file_name_season_anom=TreeSetUp.file_name_season_anom;
file_WOD_suf=TreeSetUp.file_WOD_suf;
file_path_hdata=TreeSetUp.file_path_hdata;
fname_nc_season=TreeSetUp.fname_nc_season;
fname_nc=TreeSetUp.fname_nc;


tree_prefix=TreeSetUp.tree_prefix;

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


% tree_file_name=tree_file_name_in;
%%






nlayers=length(layer_bounds);

subdir='yearly_withcycle';


if var_type=='t'
     file_prefix='RFROMV22_TEMP_';
     path_nc_erddap=[path_ERDDAP,'netcdf\',tree_prefix,'\',subdir,'\'];
     path_nc_erddap_out=[path_ERDDAP,'netcdf_1x1\',tree_prefix,'\',subdir,'\'];
     file_name_nc_out= [path_nc_erddap_out,'RFROM_TEMP_1x1xmonth_v22_paige.nc'];
     
elseif var_type=='h'
     file_prefix='RFROMV22_OHC_';
     subdir='yearly_withcycle_no_mean';
     path_nc_erddap=[path_ERDDAP,'netcdf\',tree_prefix,'\',subdir,'\'];
     path_nc_erddap_out=[path_ERDDAP,'netcdf_1x1\',tree_prefix,'\',subdir,'\'];
     start_year_mean_remove=TreeSetUp.start_year_mean_remove;
    end_year_mean_remove=TreeSetUp.end_year_mean_remove;
    file_name_nc_out= [path_nc_erddap_out,'RFROM_HEAT_1x1xmonth_v22_paige.nc'];

elseif var_type=='s'
     file_prefix='RFROMV22_SAL_LOESS_';
     path_nc_erddap_sal_loess=[path_ERDDAP,'netcdf_loess\',tree_prefix,'\',subdir,'\'];
     path_nc_erddap=path_nc_erddap_sal_loess;
     path_nc_erddap_out=[path_ERDDAP,'netcdf_1x1\',tree_prefix,'\',subdir,'\'];
     file_name_nc_out= [path_nc_erddap_out,'RFROM_SAL_LOESS_1x1xmonth_v22_paige.nc'];
end
if ~exist(path_nc_erddap_out,'dir')
    mkdir(path_nc_erddap_out)
end

start_year_file=start_year;
end_year_file=end_year;
path_new_tree=path_new_tree_combined_withcycle;
tree_model=tree_model_file_name_combined_withcycle;
% tree_file_name=tree_file_name_in;
%%


% if ~exist(path_nc_erddap_temp_stable,'dir')
%     mkdir(path_nc_erddap_temp_stable)
% end

year_start_nc=floor(start_year);
year_end_nc=floor(end_year);

%%


nyear=(year_end_nc-year_start_nc)+1;
nmod=nyear*12;

months=repmat(1:12,1,nyear);
years=repmat(year_start_nc:year_end_nc,12,1);
years=years(:);




nt=nmod;

var_out=nan(360,180,nlayers-1,nt);



time_out=nan(1,nt);
n_Ln=ones(4,360,4,180,nlayers-1);


for imod=1:nmod

    imonth=months(imod);
    iyear=years(imod);
    display(iyear)
    display(imonth)
  
    
   
            



           if imonth>=10
                  file_name_nc= [path_nc_erddap,file_prefix,num2str(iyear),'_',num2str(imonth),'.nc'];
               else
                  file_name_nc= [path_nc_erddap,file_prefix,num2str(iyear),'_0',num2str(imonth),'.nc'];
            end
            
            if exist(file_name_nc,'file')

                if var_type =='t'
                       
                    [var,~,~,~,time_junk,~]=load_temp_estimate_nc(file_name_nc);
   
                elseif var_type=='h'
                   
                 [var,~,~,~,time_junk,~]=load_heat_estimate_nc(file_name_nc);

                elseif var_type =='s'
                    
                    [var,~,~,~,time_junk,~]=load_sal_estimate_nc(file_name_nc);
       
                end
    
                time_out(imod)=mean(time_junk);
    
    
                    var=squeeze(mean(var,4,'omitnan'));
                    var= reshape(var,4,360,4,180,nlayers-1);
                    n_var=n_Ln;
                    n_var(~isfinite(var))=0;
                    var=sum(sum(var,1,'omitnan'),3,'omitnan');
                    n_var=sum(sum(n_var,1,'omitnan'),3,'omitnan');
                    var=reshape(var./n_var,360,180,nlayers-1);
                    var_out(:,:,:,imod)=var;
                    max_mod=imod;
            end
                
end
         
                 
           
           
file_name_nc_junk= [path_nc_erddap,file_prefix,num2str(2000),'_',num2str(10),'.nc'];    



if var_type =='t'
    
      
    [~,lon,lat,pres,~,mean_pressure_bnds]=load_temp_estimate_nc(file_name_nc_junk);    
    
    lon_out=(sum(reshape(lon,4,360),1)./4)';
    lat_out=(sum(reshape(lat,4,180),1)./4)';
    
    write_netcfd_cf_temp_pressure_mon_singlev22(var_out,time_out,lon_out,...
                           lat_out,pres,mean_pressure_bnds,file_name_nc_out)
elseif var_type =='s'
    
      
    [~,lon,lat,pres,~,mean_pressure_bnds]=load_sal_estimate_nc(file_name_nc_junk);    
    
    lon_out=(sum(reshape(lon,4,360),1)./4)';
    lat_out=(sum(reshape(lat,4,180),1)./4)';
    
    write_netcfd_cf_sal_pressure_mon_singlev22(var_out,time_out,lon_out,...
                           lat_out,pres,mean_pressure_bnds,file_name_nc_out)



elseif var_type=='h'

    var_out=var_out(:,:,:,1:max_mod);
    time_out=time_out(1:max_mod);
    [~,lon,lat,mean_depth,~,mean_depth_bnds]=load_heat_estimate_nc(file_name_nc_junk);
    lon_out=(sum(reshape(lon,4,360),1)./4)';
    lat_out=(sum(reshape(lat,4,180),1)./4)';   

    
     write_netcfd_cf_heat_depth_mon_single_nomean_real_delayedv22(var_out,time_out,lon_out,...
                   lat_out,mean_depth,mean_depth_bnds,start_year_mean_remove,...
                   end_year_mean_remove,file_name_nc_out)
end
                       


end

function [temp,lon,lat,pres,time_1950,mean_pressure_bnds]=load_temp_estimate_nc(filename)
 
    lat=ncread(filename,'latitude');
    lon=ncread(filename,'longitude');
    pres=ncread(filename,'mean_pressure');
    temp=ncread(filename,'ocean_temperature');
    time_1950=ncread(filename,'time');
    mean_pressure_bnds=ncread(filename,'mean_pressure_bnds');
end

function [sal,lon,lat,pres,time_1950,mean_pressure_bnds]=load_sal_estimate_nc(filename)
 
    lat=ncread(filename,'latitude');
    lon=ncread(filename,'longitude');
    pres=ncread(filename,'mean_pressure');
    sal=ncread(filename,'ocean_salinity');
    time_1950=ncread(filename,'time');
    mean_pressure_bnds=ncread(filename,'mean_pressure_bnds');
end
function [heat,lon,lat,mean_depth,time_1950,mean_depth_bnds]=load_heat_estimate_nc(filename)
 
    lat=ncread(filename,'latitude');
    lon=ncread(filename,'longitude');
    mean_depth=ncread(filename,'mean_depth');
    heat=ncread(filename,'ocean_heat_content_anomaly');
    time_1950=ncread(filename,'time');
    mean_depth_bnds=ncread(filename,'mean_depth_bnds');
end
