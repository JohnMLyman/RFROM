
min_layer=0;
max_layer=700;

load_TreeSetUp

%  tree_model_file_name='baggedtree_sst_tpx_all2';
% tree_model_file_name='tree_sst_tpx_year_1993'
% tree_model_file_name='tree_sst_tpx_yearly';
% tree_model_file_name=['tree_sst_tpx_all_year_seasonal_anom'];
%  
% 
% % tree_model_file_name_old='tree_sst_tpx_yearly_overlap_seasonal';
% tree_model_file_name=[tree_model_file_name_old,'_anom'];
tree_model_file_name=tree_model_file_name_combined;
% path_OHCA_data_out='C:\data\OHCA\'
% path_OHCA_data_in='C:\OHCA\'
% 
%  layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
% % file_name='argo_2020_10_14_QC';
% path_tree=[path_OHCA_data_out,'OHCA_trees\'];
% path_curve=[path_OHCA_data_out,'OHCA_curves\'];
% file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
% path_ssh=[path_OHCA_data_in,'Mtpers\'];




nlayers=length(layer_bounds);
endlayer=find(layer_bounds==max_layer);
startlayer=find(layer_bounds==min_layer)+1;



load('D:\data\topo_tpx_new.mat','topo_tpx_new')
 topo_tpx_new=-1.*topo_tpx_new;

ilayer=2;
layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
tree_file_name=[tree_model_file_name,'_',layer_name];
load([path_tree,tree_file_name,'_split_7day.mat'], 'lon_tpx' ,'lat_tpx','time_aviso')
nlon_tpx=length(lon_tpx);
nlat_tpx=length(lat_tpx);
ntime_tpx=length(time_aviso);

tgrid=time_aviso;

ht_error_0_700=zeros(nlon_tpx,nlat_tpx,ntime_tpx);



for ilayer=startlayer:endlayer
    tic
    


    tree_file_name=[tree_model_file_name,'_',layer_name];
    tree_file_name_yearly_error=[tree_model_file_name,'_error_',layer_name];

    load([path_tree,tree_file_name_yearly_error,'_2xweight_7day_split.mat'],...
        'scale_total_median','ht_error','time_aviso')

    ht_error_0_700=ht_error_0_700+ht_error;
  toc./60

end



clear ht_error



save([path_tree,'error_map_0_700_combined_orca.mat'], 'time_aviso', ...
    'ht_error_0_700','lon_tpx','lat_tpx','-v7.3')

var_error_ht_0_700=nanvar(ht_error_0_700,1,3);
mean_error_ht_0_700=nanmean(ht_error_0_700,3);

save([path_tree,'error_var_mean_0_700_combined_orca.mat'], 'time_aviso', ...
    'var_error_ht_0_700','mean_error_ht_0_700','lon_tpx','lat_tpx','-v7.3')

var_error_ht_0_700_2021=nanvar(ht_error_0_700(:,:,floor(time_aviso)==2021),1,3);
mean_error_ht_0_700_2021=nanmean(ht_error_0_700(:,:,floor(time_aviso)==2021),3);

save([path_tree,'error_var_mean_0_700_combined_2021_orca.mat'], 'time_aviso', ...
    'var_error_ht_0_700_2021','mean_error_ht_0_700_2021','lon_tpx','lat_tpx','-v7.3')
