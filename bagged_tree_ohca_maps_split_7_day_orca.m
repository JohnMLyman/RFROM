
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

ht_out_total=nans(nlon_tpx,nlat_tpx,ntime_tpx);
% arw=areavec(lon_tpx,lat_tpx);
layer_curve=nans(endlayer-startlayer+1,ntime_tpx);
%compute basin curves
[LON,LAT]=ndgrid(lon_tpx,lat_tpx);
[global_basins_aviso]=find_basin_paige(LON,LAT);
nbasin=length(global_basins_aviso);
scale=ones(nlon_tpx,nlat_tpx);
basin_layer_curve=nans(nbasin,endlayer-startlayer+1,ntime_tpx);

for ilayer=startlayer:endlayer
    tic
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
    scalej=scale;
    depth_min=layer_bounds(ilayer-1);
    depth_max=layer_bounds(ilayer);
    
    shallow=topo_tpx_new < depth_min;
    mid=topo_tpx_new>=depth_min & topo_tpx_new<depth_max;
    

    scalej(mid)=scalej(mid).*(topo_tpx_new(mid)-depth_min)./(depth_max-depth_min);
    scalej(shallow)=NaN;

    scalej=repmat(scalej,1,1,ntime_tpx);


    tree_file_name=[tree_model_file_name,'_',layer_name];
    load([path_tree,tree_file_name,'_split_7day.mat'], 'ht_estimate','time_aviso')
  
    
%     for itime=1:nyears
%         jyear=tgrid(itime);
%         ht_out(:,:,itime)=mean(ht_estimate(:,:,time_aviso<jyear+.5&time_aviso>=jyear-.5),3,'omitnan').*arwj;
%     end
    
   ht_junk=ht_estimate.*scalej;
   ht_out_total=nansum(cat(4,ht_out_total,ht_junk),4);
  

   toc./60

end
ht_estimate=ht_out_total;
clear ht_out_total ht_junk
file_sum_name=[path_tree,tree_model_file_name,'_',num2str(min_layer),'_',num2str(max_layer),'_7day.mat'];


save(file_sum_name,'ht_estimate','lon_tpx','lat_tpx','time_aviso','-v7.3')


