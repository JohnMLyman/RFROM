

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

file_name='argo_2021_02_02_QC';

path_oisst='C:\data\oisst\';
path_OHCA_data_out='C:\data\OHCA\'
path_OHCA_data_in='C:\OHCA\'
file_WOD_suf='_cheng_EN4_2014';
var_type='s';
tree_prefix='tree_sal_atlatic';


tree_model_file_name_season=[tree_prefix,'_yearly_overlap_seasonal'];
tree_model_file_name_yearly=[tree_model_file_name_season,'_anom'];
tree_model_file_name_all_year=[tree_prefix,'_all_year_seasonal_anom'];
tree_model_file_name_combined=[tree_prefix,'_combined_seasonal_anom'];

file_name_season=[file_name,'_seasonal'];
file_name_season_anom=[file_name_season,'_anom'];
path_ssh=[path_OHCA_data_in,'Mtpers\'];
file_path_hdata=[path_OHCA_data_out,'OHCA_maps\'];

path_tree=[path_OHCA_data_out,'OHCA_trees\',tree_prefix,'\']

layer_bounds=[0, 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125,...
    135, 145, 155, 165, 175, 190, 210, 230, 250, 270, 290, 310, 330 , ...
    350, 370 , 390, 410,  430, 450, 475, 525, 575, 625, 675, 725, 775,...
    825, 875, 925, 975, 1025, 1075, 1125, 1175, 1225, 1275, 1325, 1375,...
    1450, 1550, 1650, 1750, 1850, 1950, 2000]% layer_bounds must be in assending order
 mean_depth=(layer_bounds(1:end-1)+layer_bounds(2:end))./2;



file_path_out=[path_OHCA_data_out,'OHCA_grided\'];



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
    load([path_new_tree_season,tree_file_name,'_split_7day.mat'], 'ht_estimate','lon_tpx','lat_tpx', 'time_aviso')
%     load([path_tree,tree_file_name_old,'_seasonal_cycle_expand.mat'],'ht_cycle')
%     ht_estimate=ht_estimate+ht_cycle;
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
               save([path_mat_nc,file_name_mat_nc],'ht_estimate_mon','time_1950','time_aviso','lon_tpx','lat_tpx')
           end

       end
   end
    

  

end

