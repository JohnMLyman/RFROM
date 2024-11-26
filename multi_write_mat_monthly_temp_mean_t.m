
function multi_write_mat_monthly_temp_mean_t(TreeSetUp)

load_TreeSetUp_new_sal

path_mat_nc_temp=[path_mat_nc,'temp/matlab/'];
year_start_nc=floor(start_year);
year_end_nc=floor(end_year);

%% test info
% 
% year_start_nc=2021;
% year_end_nc=2022;
% nlayers=2;


path_tree_temp=[path_OHCA_data_out,'OHCA_trees\',tree_prefix_temp,'\'];
tree_model_file_name_season_temp=[tree_prefix_temp,'_yearly_overlap_seasonal'];

path_new_tree_season_temp=[path_tree_temp,tree_model_file_name_season_temp,'\'];



nlayers=length(layer_bounds);



%%


% load('C:\Users\jlyma\OneDrive - University of Hawaii\data\topo_tpx_new.mat','topo_tpx_new')
%  topo_tpx_new=-1.*topo_tpx_new;

ilayer=2;
layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];

tree_file_name_temp=[tree_model_file_name_season_temp,'_',layer_name];
load([path_new_tree_season_temp,tree_file_name_temp,'_split_7day.mat'], 'lon_tpx' ,'lat_tpx','time_aviso')
% nlon_tpx=length(lon_tpx);
% nlat_tpx=length(lat_tpx);
% ntime_tpx=length(time_aviso);

year_aviso=floor(time_aviso);
aviso_day=1+(time_aviso-year_aviso).*yeardays(year_aviso);
sday=round(aviso_day+datenum(year_aviso,1,1)-1);

days_since_1950=sday-datenum(1950,1,1);%NEED TO CHECK THIS

%check this
[year_data,month_data]=datevec(days_since_1950+datenum(1950,1,1));

tgrid=time_aviso;


% arw=areavec(lon_tpx,lat_tpx);
% scale=ones(nlon_tpx,nlat_tpx);


for ilayer=2:nlayers
% for ilayers=2
    tic
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
   
%     file_nc_prefix=['RFROM_Tmean_',layer_name,'_']
%      scalej=scale;    
%      depth_min=layer_bounds(ilayer-1);
%     depth_max=layer_bounds(ilayer);
%     
%     shallow=topo_tpx_new < depth_min;
%     mid=topo_tpx_new>=depth_min & topo_tpx_new<depth_max;
%     
% 
%     
%     scalej(mid)=scalej(mid).*(topo_tpx_new(mid)-depth_min)./(depth_max-depth_min);
%     scalej(shallow)=NaN;
% 
%     scalej=repmat(scalej,1,1,ntime_tpx);


    
    tree_file_name_temp=[tree_model_file_name_season_temp,'_',layer_name];
%     load([path_tree,tree_file_name,'_7day.mat'], 'ht_estimate','time_aviso')
    load([path_new_tree_season_temp,tree_file_name_temp,'_split_7day.mat'], 'ht_estimate','lon_tpx','lat_tpx', 'time_aviso')
%     load([path_tree,tree_file_name_old,'_seasonal_cycle_expand.mat'],'ht_cycle')
%     ht_estimate=ht_estimate+ht_cycle;
   
    
%     for itime=1:nyears
%         jyear=tgrid(itime);
%         ht_out(:,:,itime)=mean(ht_estimate(:,:,time_aviso<jyear+.5&time_aviso>=jyear-.5),3,'omitnan').*arwj;
%     end
    
%    ht_estimate=ht_estimate.*scalej;
time_aviso_total=time_aviso;
   
   for iyear=year_start_nc:year_end_nc
       for imonth=1:12

           good=find(month_data==imonth & year_data==iyear);

           if ~isempty(good)
               temp_estimate_mon=ht_estimate(:,:,good);
               time_1950=days_since_1950(good);
               time_aviso=time_aviso_total(good);
               file_name_mat_nc_temp=[tree_file_name_temp,'_',num2str(iyear),'_',num2str(imonth)];

               % convert to single 

               time_1950=single(time_1950);
               time_aviso=single(time_aviso);
               temp_estimate_mon=single(temp_estimate_mon);
               lon_tpx=single(lon_tpx);
               lat_tpx=single(lat_tpx);
               save([path_mat_nc_temp,file_name_mat_nc_temp],'temp_estimate_mon','time_1950','time_aviso','lon_tpx','lat_tpx')
           end

       end
   end
    

  

end

