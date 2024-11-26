min_layer=0;
max_layer=2000;



path_figs='C:\JUNK\'
year_of_oco_pub=2022;
slope_min_year=1993;
set_up_MLD
% this is the time range of the maps that are to be saved and outputted
max_year_maps_out=2020;
min_year_maps_out=2007;
cold_to_hot_colormap=diverging_map([0:1/200:1],[20 43 140]/255,[204 0 51]/255);

 
tree_model_file_name=tree_model_file_name_yearly;



ilayer=2;
layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
tree_file_name=[tree_model_file_name,'_',layer_name];
load([path_tree,tree_file_name,'_split_7day.mat'], 'ht_estimate',...
    'lon_tpx' ,'lat_tpx','time_aviso')
nlon_tpx=length(lon_tpx);
nlat_tpx=length(lat_tpx);
ntime_tpx=length(time_aviso);

%%
period=1;
period2=1/2;
period3=1/3;

tree_file_name=[tree_model_file_name_season,'_',layer_name];
    load([path_tree,tree_file_name,'_seasonal_cycle_split.mat'],...
        'amp_annual_total','phase_annual_total','amp_semi_total','phase_semi_total',...
        'amp_third_total','phase_third_total','slope_total','mean_total');
    ht_cycle=nans(nlon_tpx,nlat_tpx,ntime_tpx);
    ht_mean=mean_total+slope_total.*center_year;
    ht_trend=ht_cycle;
    
    for itime=1:ntime_tpx


        if isfinite(time_aviso(itime))
            good_t=time_aviso(itime);
            ht_cycle(:,:,itime)=amp_annual_total.*sin((2*pi.*good_t./period)+...
                phase_annual_total)+amp_semi_total.*sin((2.*good_t*pi./period2)+phase_semi_total)+...
                amp_third_total.*sin((2*pi.*good_t./period3)+phase_third_total);
            ht_trend(:,:,itime)=slope_total.*good_t-slope_total.*center_year;
        end

    end
ht_estimate=ht_estimate+ht_cycle+ht_mean;
clearvars hc_cycle ht_trend ht_mean

MLD=ht_estimate;
clearvars ht_estimate
time=time_aviso;
lat=lat_tpx;
lon=lon_tpx;
save 'E:\data\MLD\RFROM_MLD_test.mat' MLD lat lon time -v7.3

%%





% tree_file_name=[tree_model_file_name,'_',layer_name];
% load([path_tree,tree_file_name,'_split_7day.mat'], 'ht_estimate',...
%     'lon_tpx' ,'lat_tpx','time_aviso')


% if ~exist(file_sum_name,'file')
%     bagged_tree_MLD_maps_7_day_split
% else
%     load(file_sum_name,'ht_estimate','lon_tpx','lat_tpx','time_aviso')
% end

