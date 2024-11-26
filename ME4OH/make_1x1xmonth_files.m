function []=make_1x1xmonth_files(TreeSetUp)

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
path_ERDDAP_sal=TreeSetUp.path_ERDDAP_sal;
path_ERDDAP_temp=TreeSetUp.path_ERDDAP_temp;

tree_prefix=TreeSetUp.tree_prefix;
tree_prefix_temp=TreeSetUp.tree_prefix_temp;

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
path_nc_erddap_sal=[path_ERDDAP_sal,'netcdf_loess\',tree_prefix,'\',subdir,'\'];
path_nc_erddap_temp=[path_ERDDAP_temp,'netcdf\',tree_prefix_temp,'\',subdir,'\'];

path_nc_erddap_sal_stable=[path_ERDDAP_sal,'netcdf_loess_stable\',tree_prefix,'\',subdir,'\'];

path_nc_erddap_sal_stable_out=[path_ERDDAP_sal,'netcdf_loess_stable_1x1\',tree_prefix,'\',subdir,'\'];
% path_nc_erddap_temp_stable=[path_ERDDAP_temp,'netcdf_stable\'];


if ~exist(path_nc_erddap_sal_stable_out,'dir')
    mkdir(path_nc_erddap_sal_stable_out)
end
% if ~exist(path_nc_erddap_temp_stable,'dir')
%     mkdir(path_nc_erddap_temp_stable)
% end

year_start_nc=floor(start_year);
year_end_nc=floor(end_year);

%%
nt=(year_start_nc-year_end_nc+1).*12;
sal_out=nan(360,180,nlayers-1,nt);

file_name_nc_sal_stable_out= [path_nc_erddap_sal_stable_out,'RFROM_SAL_STABLE_1x1xmonth.nc'];
time_out=nan(1,nt);
n_Ln=ones(4,360,4,180,nlayers-1);
itime=0;
for iyear=year_start_nc:year_end_nc

    imonth=months(imod);
    iyear=years(imod);
    display(iyear)
    display(imonth)
  
    
    for imonth=1:12
        

        itime=itime+1

            



           if imonth>=10
                      file_name_nc_sal= [path_nc_erddap_sal,'RFROM_SAL_LOESS_',num2str(iyear),'_',num2str(imonth),'.nc'];
                      file_name_nc_temp= [path_nc_erddap_temp,'RFROM_TEMP_',num2str(iyear),'_',num2str(imonth),'.nc'];
                      file_name_nc_sal_stable= [path_nc_erddap_sal_stable,'RFROM_SAL_STABLE_',num2str(iyear),'_',num2str(imonth),'.nc'];
                      file_name_nc_temp_stable= [path_nc_erddap_sal_stable,'RFROM_TEMP_STABLE_',num2str(iyear),'_',num2str(imonth),'.nc'];


                   else
                      file_name_nc_sal= [path_nc_erddap_sal,'RFROM_SAL_LOESS_',num2str(iyear),'_0',num2str(imonth),'.nc'];
                      file_name_nc_temp= [path_nc_erddap_temp,'RFROM_TEMP_',num2str(iyear),'_0',num2str(imonth),'.nc'];
                      file_name_nc_sal_stable= [path_nc_erddap_sal_stable,'RFROM_SAL_STABLE_',num2str(iyear),'_0',num2str(imonth),'.nc'];
                      file_name_nc_temp_stable= [path_nc_erddap_sal_stable,'RFROM_TEMP_STABLE_',num2str(iyear),'_0',num2str(imonth),'.nc'];


               end
            if var_type =='s'
                [sal,lon,lat,pres,time_junk,mean_pressure_bnds]=load_sal_estimate_nc(file_name_nc_sal_stable);
%                        [temp]=load_temp_estimate_nc(file_name_nc_temp_stable);
                

                %take the monthly mean

                sal=squeeze(mean(sal,4,'omitnan'));

                lon_out=(sum(reshape(lon,4,360),1)./4)';
                lat_out=(sum(reshape(lat,4,180),1)./4)';
                time_out(itime)=mean(time_junk);

                sal= reshape(sal,4,360,4,180,nlayers-1);
                n_sal=n_Ln;
                n_sal(~isfinite(sal))=0;
                sal=sum(sum(sal,1,'omitnan'),3,'omitnan');
                n_sal=sum(sum(n_sal,1,'omitnan'),3,'omitnan');
                sal=reshape(sal./n_sal,360,180,nlayers-1);
                
                sal_out(:,:,:,itime)=sal;


         
                 
            elseif var_type=='t'
                break ;'NOT WRITTEN FOR SALINITY'

            elseif var_type=='h'
               
            end
    end
end
       
    

write_netcfd_cf_sal_pressure_mon_single(sal_out,time_out,lon_out,...
                       lat_out,pres,mean_pressure_bnds,file_name_nc_sal_stable_out)
                    
% write_netcfd_cf_temp_pressure_mon_single(temp_out,time_1950,lon_out,...
%                        lat_out,pres,mean_pressure_bnds,file_name_nc_temp_stable_out)


end

function [sal,lon,lat,pres,time_1950,mean_pressure_bnds]=load_sal_estimate_nc(filename)
 
    lat=ncread(filename,'latitude');
    lon=ncread(filename,'longitude');
    pres=ncread(filename,'mean_pressure');
    sal=ncread(filename,'ocean_salinity');
    time_1950=ncread(filename,'time');
    mean_pressure_bnds=ncread(filename,'mean_pressure_bnds');
end

function [temp]=load_temp_estimate_nc(filename)
 
%     lat=ncread(filename,'latitude');
%     lon=ncread(filename,'longitude');
%     pres=ncread(filename,'mean_pressure');
    temp=ncread(filename,'ocean_temperature');
    
end