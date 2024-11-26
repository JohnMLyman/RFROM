function make_bagged_tree_ohca_maps_7_day_seasonal_split(TreeSetUp)
load_TreeSetUp
% % % file_name='argo_2021_02_02_QC'
% % % max_year_fit=2021;
% % % min_year_fit=2008;
% % % start_year=1993;
% % % end_year=2021.5;
% % % center_year=(max_year_fit+min_year_fit)./2;

tree_model_file_name_old=tree_model_file_name_season;
tree_model_file_name=tree_model_file_name_combined;

nlayer=length(layer_bounds);

ilayer=2;
layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]

tree_file_name_anom=[tree_model_file_name,'_',layer_name];
% % load([path_tree,tree_file_name,'_seasonal_cycle.mat'],...
% %         'time_aviso','lon_tpx','lat_tpx');

load([path_tree,tree_file_name_anom,'_split_7day.mat'], 'lon_tpx' ,'lat_tpx','time_aviso')
ntime=length(time_aviso);
nlon_tpx=length(lon_tpx);
nlat_tpx=length(lat_tpx);
period=1;
period2=1/2;
period3=1/3;

    
tic
for ilayer=2:nlayer
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
    tree_file_name=[tree_model_file_name_old,'_',layer_name];
    load([path_tree,tree_file_name,'_seasonal_cycle_split.mat'],...
        'amp_annual_total','phase_annual_total','amp_semi_total','phase_semi_total',...
        'amp_third_total','phase_third_total','slope_total','mean_total');
    ht_cycle=nans(nlon_tpx,nlat_tpx,ntime);
    ht_mean=mean_total+slope_total.*center_year;
    ht_trend=ht_cycle;
    for itime=1:ntime


        if isfinite(time_aviso(itime))
            good_t=time_aviso(itime);
            ht_cycle(:,:,itime)=amp_annual_total.*sin((2*pi.*good_t./period)+...
                phase_annual_total)+amp_semi_total.*sin((2.*good_t*pi./period2)+phase_semi_total)+...
                amp_third_total.*sin((2*pi.*good_t./period3)+phase_third_total);
            ht_trend(:,:,itime)=slope_total.*good_t-slope_total.*center_year;
        end

    end
  

   save([path_tree,tree_file_name,'_seasonal_cycle_expand_split.mat'],'ht_cycle',...
       'ht_mean','time_aviso','ht_trend','lon_tpx','lat_tpx','time_aviso','-v7.3')





    toc./60

end




