function bagged_tree_ohca_curve_7_day_with_cycle_combined_split(TreeSetUp)
min_layer=0;
max_layer=2000;


load_TreeSetUp

tree_model_file_name_old=tree_model_file_name_season;

tree_model_file_name=tree_model_file_name_combined;


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

ht_out_total=nans(nlon_tpx,nlat_tpx,ntime_tpx);
arw=areavec(lon_tpx,lat_tpx);
layer_curve=nans(endlayer-startlayer+1,ntime_tpx);
%compute basin curves
[LON,LAT]=ndgrid(lon_tpx,lat_tpx);
[global_basins_aviso]=find_basin_paige(LON,LAT);
nbasin=length(global_basins_aviso);

basin_layer_curve=nans(nbasin,endlayer-startlayer+1,ntime_tpx);

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

    arwj=repmat(arwj,1,1,ntime_tpx);
    arwj=double(arwj);


    tree_file_name=[tree_model_file_name,'_',layer_name];
    tree_file_name_old=[tree_model_file_name_old,'_',layer_name];
    load([path_tree,tree_file_name,'_split_7day.mat'], 'ht_estimate','time_aviso')
    load([path_tree,tree_file_name_old,'_seasonal_cycle_expand_split.mat'],'ht_cycle','ht_mean')
    ht_estimate=ht_estimate+ht_cycle;
    clear ht_cycle ht_mean
    
%     for itime=1:nyears
%         jyear=tgrid(itime);
%         ht_out(:,:,itime)=mean(ht_estimate(:,:,time_aviso<jyear+.5&time_aviso>=jyear-.5),3,'omitnan').*arwj;
%     end
    
   ht_out=ht_estimate.*arwj;
   test_curve=jnansum(ht_out,1);
   test_curve=squeeze(jnansum(test_curve,2));
   ht_out_total=jnansum(cat(4,ht_out_total,ht_out),4);
   layer_curve(ilayer-startlayer+1,:)=test_curve;

  

    for ibasin=1:nbasin
    
        pos_basin=global_basins_aviso(ibasin).pos;
        pos_basin=repmat(pos_basin,1,1,ntime_tpx);
        jcurve=ht_out;
        jcurve(~pos_basin)=0;
        jcurve=jnansum(jcurve,1);
        jcurve=squeeze(jnansum(jcurve,2));
        basin_layer_curve(ibasin,ilayer-startlayer+1,:)=jcurve;
    
    
    end

   toc./60

end






basin_curve=nans(nbasin,ntime_tpx);

for ibasin=1:nbasin

    pos_basin=global_basins_aviso(ibasin).pos;
    pos_basin=repmat(pos_basin,1,1,ntime_tpx);
    jcurve=ht_out_total;
    jcurve(~pos_basin)=0;
    jcurve=jnansum(jcurve,1);
    jcurve=squeeze(jnansum(jcurve,2));
    basin_curve(ibasin,:)=jcurve;


end






ht_curve=jnansum(ht_out_total,1);
ht_curve=squeeze(jnansum(ht_curve,2));

figure(4)
plot(tgrid,ht_curve./1e21)

curve_name=['curve_',tree_prefix,'_0_2000_split2.mat'];

save ([path_tree,curve_name], 'tgrid', 'ht_curve', 'basin_curve', 'layer_curve');
