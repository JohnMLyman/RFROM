
function []=make_bagged_tree_ohca_maps_7_day_seasonal_orca(TreeSetUp)
nbasins_use=TreeSetUp.nbasins_use;
file_name=TreeSetUp.file_name;

file_name_season=TreeSetUp.file_name_season;
file_name_season_anom=TreeSetUp.file_name_season_anom;
file_WOD_suf=TreeSetUp.file_WOD_suf;
file_path_hdata=TreeSetUp.file_path_hdata;
fname_nc_season=TreeSetUp.fname_nc_season;
fname_nc=TreeSetUp.fname_nc;

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
% % % center_year=(max_year_fit+min_year_fit)./2;

tree_model_file_name_old=tree_model_file_name_season;
tree_model_file_name=tree_model_file_name_combined;
% path_OHCA_data_in='C:\OHCA\';
% file_path_in=path_OHCA_data_in;
% path_OHCA_data_out='C:\data\OHCA\'
% file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
% path_tree=[path_OHCA_data_out,'OHCA_trees\'];
% path_new_tree=[path_tree,tree_model_file_name,'\'];
% % % file_name='argo_2020_10_14_QC';
% % % file_name_season=[file_name,'_seasonal'];
% % % file_name_season_anom=[file_name_season,'_anom'];
% file_WOD_suf='_cheng_EN4_2014';
% file_path_hdata=[path_OHCA_data_out,'OHCA_maps\'];

nlayer=length(layer_bounds);

ilayer=2;
layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
% tree_file_name=[tree_model_file_name_old,'_',layer_name];
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
parfor ilayer=2:nlayer
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
    tree_file_name=[tree_model_file_name_old,'_',layer_name];
%     load([path_tree,tree_file_name,'_seasonal_cycle.mat'],...
%         'amp_annual_total','phase_annual_total','amp_semi_total','phase_semi_total',...
%         'amp_third_total','phase_third_total','slope_total','mean_total');

    [amp_annual_total,phase_annual_total,amp_semi_total,phase_semi_total,...
        amp_third_total,phase_third_total,slope_total,mean_total]=...
        parload_cycle([path_tree,tree_file_name,'_seasonal_cycle_split.mat']);
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
  

   parsave_expand_cycle([path_tree,tree_file_name,'_seasonal_cycle_expand_split.mat'],ht_cycle,...
       ht_mean,time_aviso,ht_trend,lon_tpx,lat_tpx)





  

end
  toc./60
end


function parsave_expand_cycle(filename,ht_cycle,...
       ht_mean,time_aviso,ht_trend,lon_tpx,lat_tpx)
         
           ht_trend=single(ht_trend);
           ht_cycle=single(ht_cycle);
           ht_mean=single(ht_mean);
         save (filename,'ht_cycle',...
       'ht_mean','time_aviso','ht_trend','lon_tpx','lat_tpx','time_aviso','-v7.3')

end
function [amp_annual_total,phase_annual_total,amp_semi_total,phase_semi_total,...
        amp_third_total,phase_third_total,slope_total,mean_total]=...
        parload_cycle(filename)
         

         load(filename,'amp_annual_total','phase_annual_total',...
             'amp_semi_total','phase_semi_total',...
        'amp_third_total','phase_third_total','slope_total','mean_total')

end

