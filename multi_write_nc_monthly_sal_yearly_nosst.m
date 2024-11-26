function []=multi_write_nc_monthly_sal_yearly_nosst(TreeSetUp)


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
path_mat_erddap=[path_ERDDAP,'matlab\yearly_nosst\'];
path_nc_erddap=[path_ERDDAP,'netcdf\yearly_nosst\'];
                                    
if ~exist(path_nc_erddap,'dir')
    mkdir(path_nc_erddap)
end

year_start_nc=1993;
year_end_nc=2022;
%% test info
% 
% year_start_nc=2021;
% year_end_nc=2022;
% nlayers=2;



tree_model_file_name=tree_model_file_name_yearly;

nlayers=length(layer_bounds);



%%



mean_pressure=(layer_bounds(1:end-1)+layer_bounds(2:end))./2;
mean_pressure=mean_pressure';
mean_pressure_bnds=[layer_bounds(1:end-1); layer_bounds(2:end)];


   
   for iyear=year_start_nc:year_end_nc
       parfor imonth=1:12
           iyear,imonth

           silayer=2;
           layer_name=[num2str(layer_bounds(silayer-1)),'_',num2str(layer_bounds(silayer))];
           tree_file_name=[tree_model_file_name,'_',layer_name];
           file_name_mat_nc=[path_mat_erddap,tree_file_name,'_',num2str(iyear),'_',num2str(imonth),'.mat'];
%            file_name_nc= [path_nc_erddap,'RFROM_OHCA_',num2str(iyear),'_',num2str(imonth),'.nc'];

           if exist(file_name_mat_nc,'file')
%                load(file_name_mat_nc,'ht_estimate_mon','time_1950','lon_tpx','lat_tpx')
               [sal_estimate_mon,time_1950,lon_tpx,lat_tpx]=load_sal_estimate_mon(file_name_mat_nc);
               ntime=length(time_1950);
               nlon=length(lon_tpx);
               nlat=length(lat_tpx);
               npressure=length(mean_pressure);
               sal_estimate=nan(nlon,nlat,npressure,ntime);
               sal_estimate(:,:,1,:)=sal_estimate_mon;

    
    
               for ilayer=3:nlayers
    
                   layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
                   tree_file_name=[tree_model_file_name,'_',layer_name];
                   file_name_mat_nc=[path_mat_erddap,tree_file_name,'_',num2str(iyear),'_',num2str(imonth),'.mat'];
                   

        
            
                   if exist(file_name_mat_nc,'file')
                       
                    
%                        load(file_name_mat_nc,'ht_estimate_mon')
                       [sal_estimate_mon,~,~,~]=load_sal_estimate_mon(file_name_mat_nc);
                        sal_estimate(:,:,ilayer-1,:)=sal_estimate_mon;
                       
        
                   end
                  
               end

               if imonth>=10
                      file_name_nc= [path_nc_erddap,'RFROM_SAL_',num2str(iyear),'_',num2str(imonth),'.nc'];
                   else
                      file_name_nc= [path_nc_erddap,'RFROM_SAL_',num2str(iyear),'_0',num2str(imonth),'.nc'];
               end
    
               write_netcfd_cf_sal_pressure_mon_single(sal_estimate,time_1950,lon_tpx,...
                   lat_tpx,mean_pressure,mean_pressure_bnds,file_name_nc)


           end

       end
   end
end

function [sal_estimate_mon,time_1950,lon_tpx,lat_tpx]=load_sal_estimate_mon(filename)


    load(filename, 'sal_estimate_mon','time_1950','lon_tpx','lat_tpx')

end


