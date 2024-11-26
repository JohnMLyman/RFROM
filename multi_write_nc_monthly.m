

path_nc='C:\Users\jlyma\OneDrive - University of Hawaii\data\OHCA\OHCA_trees\netcdf\OHCA\';
path_nc='E:\JUNK\netcdf\OHCA\netcdf\';
path_mat_nc='C:\JUNK\netcdf\OHCA\matlab\';
year_start_nc=1993;
% year_start_nc=2021;
year_end_nc=2021;
%% test info

% year_start_nc=2021;
% year_end_nc=2022;
% nlayers=2;

tree_model_file_name_old='tree_sst_tpx_yearly_overlap_seasonal';

tree_model_file_name=['tree_sst_tpx_combined_seasonal_anom'];
path_OHCA_data_out='C:\data\OHCA\'
path_OHCA_data_in='C:\OHCA\'

 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];


path_tree=[path_OHCA_data_out,'OHCA_trees\'];

file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
path_ssh=[path_OHCA_data_in,'Mtpers\'];


nlayers=length(layer_bounds);



%%



mean_depth=(layer_bounds(1:end-1)+layer_bounds(2:end))./2;
mean_depth=mean_depth';
mean_depth_bnds=[layer_bounds(1:end-1); layer_bounds(2:end)];


   
   for iyear=year_start_nc:year_end_nc
       for imonth=1:12
           iyear,imonth

           ilayer=2;
           layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
           tree_file_name=[tree_model_file_name,'_',layer_name];
           file_name_mat_nc=[path_mat_nc,tree_file_name,'_',num2str(iyear),'_',num2str(imonth),'.mat'];
%            file_name_nc= [path_nc,'RFROM_OHCA_',num2str(iyear),'_',num2str(imonth),'.nc'];

           if exist(file_name_mat_nc,'file')
               load(file_name_mat_nc,'ht_estimate_mon','time_1950','lon_tpx','lat_tpx')
               ntime=length(time_1950);
               nlon=length(lon_tpx);
               nlat=length(lat_tpx);
               ndepth=length(mean_depth);
               ht_estimate=nan(nlon,nlat,ndepth,ntime);
               ht_estimate(:,:,1,:)=ht_estimate_mon;

    
    
               for ilayer=3:nlayers
    
                   layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
                   tree_file_name=[tree_model_file_name,'_',layer_name];
                   file_name_mat_nc=[path_mat_nc,tree_file_name,'_',num2str(iyear),'_',num2str(imonth),'.mat'];
                   

        
            
                   if exist(file_name_mat_nc,'file')
                       
                    
                       load(file_name_mat_nc,'ht_estimate_mon')
                        ht_estimate(:,:,ilayer-1,:)=ht_estimate_mon;
                       
        
                   end
                  
               end

               if imonth>=10
                      file_name_nc= [path_nc,'RFROM_OHCA_',num2str(iyear),'_',num2str(imonth),'.nc'];
                   else
                      file_name_nc= [path_nc,'RFROM_OHCA_',num2str(iyear),'_0',num2str(imonth),'.nc'];
               end
    
               write_netcfd_cf_heat_depth_mon_single(ht_estimate,time_1950,lon_tpx,...
                   lat_tpx,mean_depth,mean_depth_bnds,file_name_nc)


           end

       end
   end
    

  


