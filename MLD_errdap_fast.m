function []=MLD_errdap_fast(TreeSetUp)

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
path_ERDDAP_sal=TreeSetUp.path_ERDDAP_sal;
path_ERDDAP_temp=TreeSetUp.path_ERDDAP_temp;

tree_prefix=TreeSetUp.tree_prefix;
tree_prefix_temp=TreeSetUp.tree_prefix_temp;
tree_model_file_name_season=TreeSetUp.tree_model_file_name_season;
tree_model_file_name_yearly=TreeSetUp.tree_model_file_name_yearly;
tree_model_file_name_all_year=TreeSetUp.tree_model_file_name_all_year;
tree_model_file_name_combined=TreeSetUp.tree_model_file_name_combined;
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

% path_nc='C:\Users\jlyma\OneDrive - University of Hawaii\data\OHCA\OHCA_trees\netcdf\OHCA\';
% path_nc='H:\erddap\temp\netcdf\';
% path_mat_nc='H:\erddap\temp\matlab\';
% path_mat_erddap_=[path_ERDDAP,'matlab\'];
% path_nc_erddap_sal=[path_ERDDAP_sal,'netcdf\yearly_mean_t_nossh\'];
% path_nc_erddap_temp=[path_ERDDAP_temp,'netcdf\'];

subdir='yearly_withcycle';
subdir_mld='yearly_withcycle_mld';
path_nc_erddap_sal=[path_ERDDAP_sal,'netcdf_loess\',tree_prefix,'\',subdir,'\'];
path_nc_erddap_temp=[path_ERDDAP_temp,'netcdf\',tree_prefix_temp,'\',subdir,'\'];
path_nc_erddap_mld=[path_ERDDAP_sal,'netcdf_loess_stable\',tree_prefix,'\',subdir_mld,'\'];
path_nc_erddap_sal_stable=[path_ERDDAP_sal,'netcdf_loess_stable\',tree_prefix,'\',subdir,'\'];
% path_nc_erddap_temp_stable=[path_ERDDAP_temp,'netcdf_stable\'];


if ~exist(path_nc_erddap_mld,'dir')
    mkdir(path_nc_erddap_mld)
end
% if ~exist(path_nc_erddap_temp_stable,'dir')
%     mkdir(path_nc_erddap_temp_stable)
% end

year_start_nc=floor(start_year);
year_end_nc=floor(end_year);
%% test info
% 
% year_start_nc=2021;
% year_end_nc=2022;
% nlayers=2;

% 

tree_model_file_name=tree_model_file_name_combined;

nlayers=length(layer_bounds);



%%
% % 
% % 
% % 
% % mean_pressure=(layer_bounds(1:end-1)+layer_bounds(2:end))./2;
% % mean_pressure=mean_pressure';
% % mean_pressure_bnds=[layer_bounds(1:end-1); layer_bounds(2:end)];
%       year_test=[1999 2012]
%     parfor iiyear=1:length(year_test)
%         iyear=year_test(iiyear);
%         for imonth=9


nyear=(year_end_nc-year_start_nc)+1;
nmod=nyear*12;

months=repmat(1:12,1,nyear);
years=repmat(year_start_nc:year_end_nc,12,1);
years=years(:);

   parfor imod=1:nmod
%       for imod=1:1
      
            imonth=months(imod);
            iyear=years(imod);
           display(iyear)
           display(imonth)


          

    
    
              

               if imonth>=10
                      file_name_nc_sal= [path_nc_erddap_sal,'RFROM_SAL_LOESS_',num2str(iyear),'_',num2str(imonth),'.nc'];
                      file_name_nc_temp= [path_nc_erddap_temp,'RFROM_TEMP_',num2str(iyear),'_',num2str(imonth),'.nc'];
                      file_name_nc_sal_stable= [path_nc_erddap_sal_stable,'RFROM_SAL_STABLE_',num2str(iyear),'_',num2str(imonth),'.nc'];
                      file_name_nc_temp_stable= [path_nc_erddap_sal_stable,'RFROM_TEMP_STABLE_',num2str(iyear),'_',num2str(imonth),'.nc'];
                      file_name_nc_mld= [path_nc_erddap_mld,'RFROM_MLD_',num2str(iyear),'_',num2str(imonth),'.nc'];


                   else
                      file_name_nc_sal= [path_nc_erddap_sal,'RFROM_SAL_LOESS_',num2str(iyear),'_0',num2str(imonth),'.nc'];
                      file_name_nc_temp= [path_nc_erddap_temp,'RFROM_TEMP_',num2str(iyear),'_0',num2str(imonth),'.nc'];
                      file_name_nc_sal_stable= [path_nc_erddap_sal_stable,'RFROM_SAL_STABLE_',num2str(iyear),'_0',num2str(imonth),'.nc'];
                      file_name_nc_temp_stable= [path_nc_erddap_sal_stable,'RFROM_TEMP_STABLE_',num2str(iyear),'_0',num2str(imonth),'.nc'];
                      file_name_nc_mld= [path_nc_erddap_mld,'RFROM_MLD_',num2str(iyear),'_0',num2str(imonth),'.nc'];

               end


                  if exist(file_name_nc_sal,'file') && exist(file_name_nc_temp,'file')
                       [sal,lon,lat,pres,time_1950,~]=load_sal_estimate_nc(file_name_nc_sal_stable);
                       [temp]=load_temp_estimate_nc(file_name_nc_temp_stable);
                       nlon=length(lon);
                       nlat=length(lat);
                       ntime=length(time_1950);
                       mld_out=nan(nlon,nlat,ntime);
                       mld_temp_out=nan(nlon,nlat,ntime);
                       mld_sal_out=nan(nlon,nlat,ntime);
                       mld_den_out=nan(nlon,nlat,ntime);
                       pres=double(pres);

       
                      for itime=1:ntime
        
                           for ilon=1:nlon
                               for ilat= 1:nlat
                                   SA_in=squeeze(double(sal(ilon,ilat,:,itime)));
            
                                   CT_in=squeeze(double(temp(ilon,ilat,:,itime)));

                                   good=isfinite(CT_in);
                                   CT_in=CT_in(good);
                                   SA_in=SA_in(good);
                                   pres_in=pres(good);

                                   if length(pres_in)>=5
                                        
                                        [mld,mld_temp,mld_sal,mld_den] = findmld_RFROM(SA_in',CT_in',pres_in');
                                        mld_out(ilon,ilat,itime)=mld;
                                        mld_temp_out(ilon,ilat,itime)=mld_temp;
                                        mld_sal_out(ilon,ilat,itime)=mld_sal;
                                        mld_den_out(ilon,ilat,itime)=mld_den;
                                   end
                               end
            
                           end
        
        
                      end
    
                   end
    
                 
                   write_netcfd_cf_mld_pressure_mon_single(mld_out,...
                       mld_temp_out,mld_sal_out,mld_den_out,time_1950,lon,...
                       lat,file_name_nc_mld)

    
  
   end
  
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
