

path_nc='C:\Users\jlyma\OneDrive - University of Hawaii\data\OHCA\OHCA_trees\netcdf\OHCA\';
path_nc='C:\JUNK\netcdf\OHCA\';
path_mat_nc='C:\JUNK\netcdf\OHCA\matlab\';
year_start_nc=1993;
year_end_nc=2021;
%% test info
% 
% year_start_nc=2021;
% year_end_nc=2022;
% nlayers=2;

tree_model_file_name_old='tree_sst_tpx_yearly_overlap_seasonal';

tree_model_file_name=['tree_sst_tpx_combined_seasonal_anom'];
path_OHCA_data_out='C:\data\OHCA\'
path_OHCA_data_in='C:\OHCA\'

 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
 mean_depth=(layer_bounds(1:end-1)+layer_bounds(2:end))./2;

path_tree=[path_OHCA_data_out,'OHCA_trees\'];

file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
path_ssh=[path_OHCA_data_in,'Mtpers\'];


nlayers=length(layer_bounds);



%%


load('C:\Users\jlyma\OneDrive - University of Hawaii\data\topo_tpx_new.mat','topo_tpx_new')
 topo_tpx_new=-1.*topo_tpx_new;

ilayer=2;
layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
tree_file_name=[tree_model_file_name,'_',layer_name];
load([path_tree,tree_file_name,'_7day.mat'], 'lon_tpx' ,'lat_tpx','time_aviso')
nlon_tpx=length(lon_tpx);
nlat_tpx=length(lat_tpx);
ntime_tpx=length(time_aviso);

year_aviso=floor(time_aviso);
aviso_day=1+(time_aviso-year_aviso).*yeardays(year_aviso);
sday=round(aviso_day+datenum(year_aviso,1,1)-1);

days_since_1950=sday-datenum(1950,1,1);%NEED TO CHECK THIS

%check this
[year_data,month_data]=datevec(days_since_1950+datenum(1950,1,1));

tgrid=time_aviso;

ht_out_total=nans(nlon_tpx,nlat_tpx,ntime_tpx);
% arw=areavec(lon_tpx,lat_tpx);
scale=ones(nlon_tpx,nlat_tpx);


for ilayer=2:nlayers
% for ilayers=2
    tic
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
   
    file_nc_prefix=['RFROM_OHCA_',layer_name,'_']
     scalej=scale;    
     depth_min=layer_bounds(ilayer-1);
    depth_max=layer_bounds(ilayer);
    
    shallow=topo_tpx_new < depth_min;
    mid=topo_tpx_new>=depth_min & topo_tpx_new<depth_max;
    

    
    scalej(mid)=scalej(mid).*(topo_tpx_new(mid)-depth_min)./(depth_max-depth_min);
    scalej(shallow)=NaN;

    scalej=repmat(scalej,1,1,ntime_tpx);


    tree_file_name=[tree_model_file_name,'_',layer_name];
    tree_file_name_old=[tree_model_file_name_old,'_',layer_name];
    load([path_tree,tree_file_name,'_7day.mat'], 'ht_estimate','time_aviso')
    load([path_tree,tree_file_name_old,'_seasonal_cycle_expand.mat'],'ht_cycle')
    ht_estimate=ht_estimate+ht_cycle;
    clear ht_cycle
    
%     for itime=1:nyears
%         jyear=tgrid(itime);
%         ht_out(:,:,itime)=mean(ht_estimate(:,:,time_aviso<jyear+.5&time_aviso>=jyear-.5),3,'omitnan').*arwj;
%     end
    
   ht_estimate=ht_estimate.*scalej;

   
   for iyear=year_start_nc:year_end_nc
       for imonth=1:12

           good=find(month_data==imonth & year_data==iyear);

           if ~isempty(good)
               ht_estimate_mon=ht_estimate(:,:,good);
               time_1950=days_since_1950(good);
               file_name_mat_nc=[tree_file_name,'_',num2str(iyear),'_',num2str(imonth)];

               % convert to single 

               time_1950=single(time_1950);
               ht_estimate_mon=single(ht_estimate_mon);
               lon_tpx=single(lon_tpx);
               lat_tpx=single(lat_tpx);
               save([path_mat_nc,file_name_mat_nc],'ht_estimate_mon','time_1950','lon_tpx','lat_tpx')
           end

       end
   end
    

  

end

