function topo=interp_topo_insitu(coords,topo_new)


%%

load('D:\data\topo_tpx_new.mat','topo_tpx_new','lat_topo','lon_topo')
if exist('topo_new','var')
    topo_tpx_new=topo_new;
end
lon=lon_topo';
lat=lat_topo;


% need to fix any coordinates that stray outside the range -180:180
ii=find(coords(:,1)>180);coords(ii,1)=coords(ii,1)-360;
ii=find(coords(:,1)<-180);coords(ii,1)=coords(ii,1)+360;


lon_argo=coords(:,1);
lat_argo=coords(:,2);
lon_180_argo=lon_argo;
lon_argo(lon_argo<0)=lon_argo(lon_argo<0)+360;
nprof=length(lon_argo);

good_180=lon_180_argo>-90 & lon_180_argo<90;


% compute,save and remove the mean (same as Argo)

pos_aviso_180=lon>180;
lon_180=[lon(pos_aviso_180)-360 ; lon(~pos_aviso_180)];

[LON,LAT]=ndgrid(lon,lat);
[LON_180,~]=ndgrid(lon_180,lat);

topo=nans(nprof,1);


good_all=~good_180;
good_all_180=good_180;


topo_tpx_new_180=[topo_tpx_new(pos_aviso_180,:);topo_tpx_new(~pos_aviso_180,:)];
F=griddedInterpolant(LON,LAT,topo_tpx_new);
F_180=griddedInterpolant(LON_180,LAT,topo_tpx_new_180);
jlon=lon_argo(good_all);
jlat=lat_argo(good_all);
jlon_180=lon_180_argo(good_all_180);
jlat_180=lat_argo(good_all_180);

topo(good_all,1)=F(jlon,jlat);
topo(good_all_180,1)=F_180(jlon_180,jlat_180);



  

  
  
end


