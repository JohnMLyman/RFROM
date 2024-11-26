load('E:\etopo15.mat')
load('E:\greg eof\meanssh_oco_realtime_argo_2019_4_16_QC.mat')
lon=lon';
lon_tpx=[lon(721:end)-360;lon(1:720)];
lat_tpx=lat;

pos_gt_179=find(b_lon>=179 );


 pos_lt_181=find(b_lon<=181 &b_lon>30);
 lon2=b_lon-360;
 
lon_topo=[lon2(pos_gt_179),b_lon(pos_lt_181)]';
topo=[b_dep(pos_gt_179,:);b_dep(pos_lt_181,:)];
lat_topo=b_lat;

topo_tpx=interp2(lat_topo,lon_topo,topo,lat_tpx,lon_tpx);


save('E:\topo_tpx_new.mat topo_tpx lon_tpx lat_tpx')

topo_tpx=-1.*topo_tpx;

arw=areavec(lon_tpx,lat_tpx);

layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];

n_layers=length(layer_bounds);

for i=2:n_layers
    
    depth_min=layer_bounds(i-1);
    depth_max=layer_bounds(i);
    arw_j=arw;
    shallow=find(topo_tpx < depth_min);
    mid=find(topo_tpx>=depth_min & topo_tpx<depth_max);
    arw_j(mid)=arw(mid).*(topo_tpx(mid)-depth_min)./(depth_max-depth_min);
    arw_j(shallow)=NaN;
    eval(['mask_',num2str(depth_min),'_',num2str(depth_max),'=arw_j;'])


end

lon_mask=lon_tpx;
lat_mask=lat_tpx;

save 'E:\mask_layers.mat' mask_0_40 mask_40_90 mask_90_190 mask_190_290 ...
    mask_290_450 mask_450_700 mask_700_950 mask_950_1450 mask_1450_1950 ...
     mask_1950_2000 lon_mask lat_mask
