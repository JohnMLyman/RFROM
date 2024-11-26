
min_layer=0;
max_layer=2000;
 tree_model_file_name='baggedtree_sst_tpx_all2';
tree_model_file_name='tree_sst_tpx_year_1993'
tree_model_file_name='tree_sst_tpx_yearly';
tree_model_file_name=['tree_sst_tpx_all_year_seasonal_anom'];
% tree_model_file_name_old='tree_sst_tpx_yearly_overlap_seasonal';
% tree_model_file_name=[tree_model_file_name_old,'_anom'];

path_OHCA_data_out='C:\data\OHCA\'
path_OHCA_data_in='C:\OHCA\'

 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
file_name='argo_2020_10_14_QC';
path_tree=[path_OHCA_data_out,'OHCA_trees\'];

file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
path_ssh=[path_OHCA_data_in,'Mtpers\'];
nlayers=length(layer_bounds);
endlayer=find(layer_bounds==max_layer);
startlayer=find(layer_bounds==min_layer)+1;

tgrid=[1993.5:.5:2021];
nyears=length(tgrid);

load('C:\Users\jlyma\OneDrive - University of Hawaii\data\topo_tpx_new.mat','topo_tpx_new')
 topo_tpx_new=-1.*topo_tpx_new;

ilayer=2;
layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
tree_file_name=[tree_model_file_name,'_',layer_name];
load([path_tree,tree_file_name,'_7day.mat'], 'lon_tpx' ,'lat_tpx')
nlon_tpx=length(lon_tpx);
nlat_tpx=length(lat_tpx);

ht_out_total=nans(nlon_tpx,nlat_tpx,nyears);
ht_out=ht_out_total;
arw=areavec(lon_tpx,lat_tpx);
layer_curve=nans(endlayer-startlayer+1,nyears);
%compute basin curves
[LON,LAT]=ndgrid(lon_tpx,lat_tpx);
[global_basins_aviso]=find_basin_paige(LON,LAT);
nbasin=length(global_basins_aviso);

basin_layer_curve=nans(nbasin,endlayer-startlayer+1,nyears);

for ilayer=startlayer:endlayer
    tic
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
    arwj=arw;
    depth_min=layer_bounds(ilayer-1);
    depth_max=layer_bounds(ilayer);
    
    shallow=topo_tpx_new < depth_min;
    mid=topo_tpx_new>=depth_min & topo_tpx_new<depth_max;
    

    arwj(mid)=arwj(mid).*(topo_tpx_new(mid)-depth_min)./(depth_max-depth_min);
    arwj(shallow)=NaN;

   

    tree_file_name=[tree_model_file_name,'_',layer_name];
    load([path_tree,tree_file_name,'_7day.mat'], 'ht_estimate','time_aviso')
  
    
    for itime=1:nyears
        jyear=tgrid(itime);
        ht_out(:,:,itime)=mean(ht_estimate(:,:,time_aviso<jyear+.5&time_aviso>=jyear-.5),3,'omitnan').*arwj;
    end
    
   
   test_curve=nansum(ht_out,1);
   test_curve=squeeze(nansum(test_curve,2));
   ht_out_total=nansum(cat(4,ht_out_total,ht_out),4);
   layer_curve(ilayer-startlayer+1,:)=test_curve;

  

    for ibasin=1:nbasin
    
        pos_basin=global_basins_aviso(ibasin).pos;
        pos_basin=repmat(pos_basin,1,1,nyears);
        jcurve=ht_out;
        jcurve(~pos_basin)=0;
        jcurve=nansum(jcurve,1);
        jcurve=squeeze(nansum(jcurve,2));
        basin_layer_curve(ibasin,ilayer-startlayer+1,:)=jcurve;
    
    
    end

   toc./60

end






basin_curve=nans(nbasin,nyears);

for ibasin=1:nbasin

    pos_basin=global_basins_aviso(ibasin).pos;
    pos_basin=repmat(pos_basin,1,1,nyears);
    jcurve=ht_out_total;
    jcurve(~pos_basin)=0;
    jcurve=nansum(jcurve,1);
    jcurve=squeeze(nansum(jcurve,2));
    basin_curve(ibasin,:)=jcurve;


end






ht_curve=nansum(ht_out_total,1);
ht_curve=squeeze(nansum(ht_curve,2));

figure(11)
plot(tgrid,ht_curve./1e21)


save test_tree_curve_year_1993_2000_mean.mat tgrid ht_curve