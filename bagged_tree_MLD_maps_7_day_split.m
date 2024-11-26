
% % % min_layer=0;
% % % max_layer=700;
% % %  tree_model_file_name='baggedtree_sst_tpx_all2';
% % % tree_model_file_name='tree_sst_tpx_year_1993'
% % % tree_model_file_name='tree_sst_tpx_yearly';
% % % tree_model_file_name=['tree_sst_tpx_all_year_seasonal_anom'];
% % % tree_model_file_name_old='tree_sst_tpx_yearly_overlap_seasonal';
% % % tree_model_file_name=[tree_model_file_name_old,'_anom'];
% % % path_OHCA_data_out='C:\data\OHCA\'
% % % path_OHCA_data_in='C:\OHCA\'
% % % 
% % % 
% % %  layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
% % % file_name='argo_2020_10_14_QC';
% % % path_tree=[path_OHCA_data_out,'OHCA_trees\'];
% % % 
% % % file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
% % % path_ssh=[path_OHCA_data_in,'Mtpers\'];
% % % nlayers=length(layer_bounds);
% % % endlayer=find(layer_bounds==max_layer);
% % % startlayer=find(layer_bounds==min_layer)+1;



load('C:\Users\jlyma\OneDrive - University of Hawaii\data\topo_tpx_new.mat','topo_tpx_new')
 topo_tpx_new=-1.*topo_tpx_new;

ilayer=2;
layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
tree_file_name=[tree_model_file_name,'_',layer_name];
load([path_tree,tree_file_name,'_split_7day.mat'], 'ht_estimate',...
    'lon_tpx' ,'lat_tpx','time_aviso')


nlon_tpx=length(lon_tpx);
nlat_tpx=length(lat_tpx);
ntime_tpx=length(time_aviso);

tgrid=time_aviso;

file_sum_name=[path_tree,tree_model_file_name,'_',num2str(min_layer),'_',num2str(max_layer),'_split_7day.mat'];


save(file_sum_name,'ht_estimate','lon_tpx','lat_tpx','time_aviso','-v7.3')


