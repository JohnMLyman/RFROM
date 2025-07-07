function [ct_RFROM,sa_RFROM,yr_RFROM,lon_RFROM,lat_RFROM,pres_RFROM]=find_profiles_t_and_s_v22(TreeSetUp,lon_profiles,lat_profiles,yr_profiles)



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
path_nc_erddap_sal=[path_ERDDAP_sal,'netcdf_loess\',tree_prefix,'\',subdir,'\'];
path_nc_erddap_temp=[path_ERDDAP_temp,'netcdf\',tree_prefix_temp,'\',subdir,'\'];

path_nc_erddap_sal_stable=[path_ERDDAP_sal,'netcdf_loess_stable\',tree_prefix,'\',subdir,'\'];
path_nc_erddap_sal_stable_mask=[path_ERDDAP_sal,'netcdf_loess_stable\',tree_prefix,'\',subdir,'\'];
% path_nc_erddap_temp_stable=[path_ERDDAP_temp,'netcdf_stable\'];

path_nc_erddap_sal_stable_mask='H:\erddap_filt_anomt\sal_vert_deepnetcdf_loess_stable\tree_sal_deep\yearly_withcycle\';
if ~exist(path_nc_erddap_sal_stable_mask,'dir')
    mkdir(path_nc_erddap_sal_stable_mask)
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
nprof=length(lon_profiles);
Re=6371.;
lat2km=Re.*pi/180.;

% get rid of strange GREG 30 to 390 and -180 to 180 longitudes
lon_profiles(lon_profiles>=360)=lon_profiles(lon_profiles>=360)-360;
lon_profiles(lon_profiles<0)=lon_profiles(lon_profiles<0)+360;

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
% Load in the information about the files
load('D:\data\topo_tpx_new.mat','lat_topo','lon_topo')

[LAT,LON]=meshgrid(lat_topo,lon_topo);


RFROM_file=struct();
sfile=0;% a counter of the total number of weeks
  for imod=1:nmod
 
            imonth=months(imod);
            iyear=years(imod);
           display(iyear)
           display(imonth)

               if imonth>=10
                                            
                     
                      file_name_nc_sal_stable_mask= [path_nc_erddap_sal_stable_mask,'RFROM_SAL_STABLE_',num2str(iyear),'_',num2str(imonth),'.nc'];
                      file_name_nc_temp_stable_mask= [path_nc_erddap_sal_stable_mask,'RFROM_TEMP_STABLE_',num2str(iyear),'_',num2str(imonth),'.nc'];


                   else
                      
                      
                      file_name_nc_sal_stable_mask= [path_nc_erddap_sal_stable_mask,'RFROM_SAL_STABLE_',num2str(iyear),'_0',num2str(imonth),'.nc'];
                      file_name_nc_temp_stable_mask= [path_nc_erddap_sal_stable_mask,'RFROM_TEMP_STABLE_',num2str(iyear),'_0',num2str(imonth),'.nc'];


               end


                  if exist(file_name_nc_sal_stable_mask,'file') && exist(file_name_nc_temp_stable_mask,'file')
                       
                      
                       
        
                     [yr_junk_file]=load_temp_estimate_nc_time(file_name_nc_temp_stable_mask);
                   
                 n_yr=length(yr_junk_file);

                 for iyr=1:n_yr
                   ifile=sfile+iyr;
                   RFROM_file(ifile).file_temp=file_name_nc_temp_stable_mask;
                   RFROM_file(ifile).file_sal=file_name_nc_sal_stable_mask;
                   yr_file(ifile)=yr_junk_file(iyr);
                   RFROM_file(ifile).time_pos=iyr;
                 end
                 sfile=ifile;
                    
                  
                  end
  end

lon_RFROM=nan(1,nprof);
lat_RFROM=lon_RFROM;
yr_RFROM=lon_RFROM;

sa_RFROM=nan(nprof,nlayers-1);
ct_RFROM=sa_RFROM;
  % now find the closet point to the 
          
   s_lon_lat=size(LON);

for iprof=1:nprof
  iprof
  nprof
       lon_junk=lon_profiles(iprof);
       lat_junk=lat_profiles(iprof);
       yr_junk=yr_profiles(iprof);
      

       if lon_junk>340 ||lon_junk<10
           LON(LON>340)=LON(LON>340)-360;
           if lon_junk>340
               lon_junk=lon_junk-360;
           end
       end
 % min       
       lon2km=lat2km.*cos(lat_junk.*pi/180.);
       dist=sqrt((lon2km.*(LON-lon_junk)).^2+(lat2km.*(LAT-lat_junk)).^2);

       del_time=abs(yr_file-yr_junk);

       [~,pos_min]=min(dist,[],'all');

       [pos_lon_min,pos_lat_min]=ind2sub(s_lon_lat,pos_min);
       [~,pos_time_min]=min(del_time);

       file_name_nc_temp_stable_mask=RFROM_file(pos_time_min).file_temp;
       file_name_nc_sal_stable_mask=RFROM_file(pos_time_min).file_sal;
       yr_RFROM(iprof)=yr_file(pos_time_min);
       lon_RFROM(iprof)=lon_topo(pos_lon_min);
       lat_RFROM(iprof)=lat_topo(pos_lat_min);
       pos_time_file=RFROM_file(pos_time_min).time_pos;



                  if exist(file_name_nc_sal_stable_mask,'file') && exist(file_name_nc_temp_stable_mask,'file')
                       
                       [sal_junk,~,~,pres_RFROM,~,~]=load_sal_estimate_nc(file_name_nc_sal_stable_mask);
                       [temp_junk]=load_temp_estimate_nc(file_name_nc_temp_stable_mask);


                       sa_RFROM(iprof,:)=double(sal_junk(pos_lon_min,pos_lat_min,:,pos_time_file));
                       ct_RFROM(iprof,:)=double(temp_junk(pos_lon_min,pos_lat_min,:,pos_time_file));
                       pres_RFROM=double(pres_RFROM);
        
                    
                  
                  end
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
function [yr_RFROM]=load_temp_estimate_nc_time(filename)
 
%     lat=ncread(filename,'latitude');
%     lon=ncread(filename,'longitude');
%     pres=ncread(filename,'mean_pressure');
      time_1950=ncread(filename,'time');
      
            time_matlab=double(time_1950)+datenum(1950,1,1);
            [time_year,~]=datevec(time_matlab);
            yr_RFROM=time_year+(time_matlab-datenum(time_year,1,1))./yeardays(time_year);

    
end
