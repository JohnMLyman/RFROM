function []=stablize_t_and_sl(TreeSetUp)

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
path_nc_erddap_sal=[path_ERDDAP_sal,'netcdf\yearly_mean_t_nossh\'];
path_nc_erddap_temp=[path_ERDDAP_temp,'netcdf\'];

path_nc_erddap_sal_stable=[path_ERDDAP_sal,'netcdf_stable\yearly_mean_t_nossh\'];
% path_nc_erddap_temp_stable=[path_ERDDAP_temp,'netcdf_stable\'];


if ~exist(path_nc_erddap_sal_stable,'dir')
    mkdir(path_nc_erddap_sal_stable)
end
% if ~exist(path_nc_erddap_temp_stable,'dir')
%     mkdir(path_nc_erddap_temp_stable)
% end

year_start_nc=2010;
year_end_nc=2010;
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


   
   for iyear=year_start_nc:year_end_nc
%        for imonth=1:12
      for imonth=5

           iyear,imonth

%            silayer=2;
%            layer_name=[num2str(layer_bounds(silayer-1)),'_',num2str(layer_bounds(silayer))];
%            tree_file_name=[tree_model_file_name,'_',layer_name];
%            file_name_mat_nc=[path_mat_erddap,tree_file_name,'_',num2str(iyear),'_',num2str(imonth),'.mat'];
%            file_name_nc= [path_nc_erddap,'RFROM_OHCA_',num2str(iyear),'_',num2str(imonth),'.nc'];

          

    
    
              

               if imonth>=10
                      file_name_nc_sal= [path_nc_erddap_sal,'RFROM_SAL_',num2str(iyear),'_',num2str(imonth),'.nc'];
                      file_name_nc_temp= [path_nc_erddap_temp,'RFROM_TEMP_',num2str(iyear),'_',num2str(imonth),'.nc'];
                      file_name_nc_sal_stable= [path_nc_erddap_sal_stable,'RFROM_SAL_STABLE_',num2str(iyear),'_',num2str(imonth),'.nc'];
                      file_name_nc_temp_stable= [path_nc_erddap_sal_stable,'RFROM_TEMP_STABLE',num2str(iyear),'_',num2str(imonth),'.nc'];


                   else
                      file_name_nc_sal= [path_nc_erddap_sal,'RFROM_SAL_',num2str(iyear),'_0',num2str(imonth),'.nc'];
                      file_name_nc_temp= [path_nc_erddap_temp,'RFROM_TEMP_',num2str(iyear),'_0',num2str(imonth),'.nc'];
                      file_name_nc_sal_stable= [path_nc_erddap_sal_stable,'RFROM_SAL_',num2str(iyear),'_0',num2str(imonth),'.nc'];
                      file_name_nc_temp_stable= [path_nc_erddap_sal_stable,'RFROM_TEMP_',num2str(iyear),'_0',num2str(imonth),'.nc'];


               end
                if exist(file_name_nc_sal,'file') && exist(file_name_nc_temp,'file')
               [sal,lon,lat,pres,time_1950,mean_pressure_bnds]=load_sal_estimate_nc(file_name_nc_sal);
               [temp]=load_temp_estimate_nc(file_name_nc_temp);
               nlon=length(lon);
               nlat=length(lat);
               size_sal=size(sal);
               sal_out=nan(size_sal);
               temp_out=nans(size_sal);
               pres=double(pres);
%                for itime=1:1
              parfor itime=1:size_sal(4)

               for ilon=1:nlon
                   for ilat=1:nlat
                       SA_in=squeeze(double(sal(ilon,ilat,:,itime)));

                       CT_in=squeeze(double(temp(ilon,ilat,:,itime)));
                        [SA_out, CT_out] = gsw_stabilise_SA_CT(SA_in,CT_in,pres');
                        sal_out(ilon,ilat,:,itime)=SA_out;
                        temp_out(ilon,ilat,:,itime)=CT_out;
                   end

               end


                end

                end

                
               write_netcfd_cf_sal_pressure_mon_single(sal_out,time_1950,lon,...
                   lat,pres,mean_pressure_bnds,file_name_nc_sal_stable)
                write_netcfd_cf_temp_pressure_mon_single(temp_out,time_1950,lon,...
                   lat,pres,mean_pressure_bnds,file_name_nc_temp_stable)
%                 file_name_junk_stable_mat= [path_nc_erddap_sal_stable,'RFROM_JUNK_',num2str(iyear),'_0',num2str(imonth),'.mat'];
% 
%            save(file_name_junk_stable_mat,'time_1950','lon','lat','pres','sal_out','temp_out','-v7.3')
       end
  
   end
   toc./60./60
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
