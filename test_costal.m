% load('D:\data\topo_tpx_new.mat','topo_tpx_new','lat_topo','lon_topo')
% load('D:\s_maps\sdata_new_layers__cheng_EN4_2014_argo_2023_03_23_QC_press_seasonal.mat')




[LON,LAT]=meshgrid(lon_topo,lat_topo);
LON=LON';
LAT=LAT';
 
[global_basins]=find_basin_paige(LON,LAT);
coords_tpx=coords;
coords_tpx(coords_tpx(:,1)<0,1)=coords_tpx(coords_tpx(:,1)<0,1)+360;
topo=interp_topo_insitu(coords_tpx);
[global_basins_cds]=find_basin_paige(coords(:,1),coords(:,2));
topo_test=topo_tpx_new;
pos_bad=find_bad_depths(LON,LAT);
pos_bad_cds=find_bad_depths(coords_tpx(:,1),coords_tpx(:,2));


ibasin=1;
% bad_cds=(topo<-500&topo<0 &yr>1993&global_basins_cds(ibasin).pos)|(pos_bad_cds&global_basins_cds(ibasin).pos);
% good_cds=topo>-500&topo<0 &yr>1993&global_basins_cds(ibasin).pos&~pos_bad_cds;

bad_cds=((topo<=-500 )|(pos_bad_cds))&yr>=1993&global_basins_cds(ibasin).pos;
good_cds=((topo>=-500)&~pos_bad_cds)&yr>=1993&global_basins_cds(ibasin).pos;

%%
figure(10)
clf
plot(coords_tpx(bad_cds,1),coords_tpx(bad_cds,2),'b.')
hold on
plot(coords_tpx(good_cds,1),coords_tpx(good_cds,2),'r.')

basin_regions=map_costal_region(coords_tpx(:,1),coords_tpx(:,2),ibasin);
pos_regions_cds=basin_regions(9).pos&good_cds;
plot(coords_tpx(pos_regions_cds,1),coords_tpx(pos_regions_cds,2),'ko')

plot_coasts_black

figure(11)
histogram(yr(pos_regions_cds))
figure(12)
histogram(yr(pos_regions_cds)-floor(yr(pos_regions_cds)))

%%
figure(2)
clf
topom=topo_test;
topom(topom>-500)=nan;
topom(~global_basins(ibasin).pos)=nan;
pcolor(lon_topo,lat_topo,topom')
shading flat
plot_coasts_black
%%
figure(3)
clf
% pos_bad=find_bad_depths(LON,LAT);
topom=topo_test;
topom(topom<-500|topom>10|pos_bad)=nan;
topom(~global_basins(ibasin).pos)=nan;
pcolor(lon_topo,lat_topo,topom')
shading flat
plot_coasts_black
%%
pos_off_coast=find_off_coast(LON,LAT,topom);


figure(4)
clf
topom=topo_test;
% topom(topom<-500|topom>0|pos_bad)=nan;
% topom((~pos_off_coast|topom>0)|~global_basins(ibasin).pos)=nan;
topom((~pos_off_coast|topom>10))=nan;

pcolor(lon_topo,lat_topo,topom')
shading flat
plot_coasts_black

topo_new=interp_topo_insitu(coords_tpx,topom);
off_cds=isfinite(topo_new);


% figure(10)
% hold on
% pos_off_cds_good=off_cds&yr>=1993&global_basins_cds(ibasin).pos;
% 
% plot(coords_tpx(pos_off_cds_good,1),coords_tpx(pos_off_cds_good,2),'g.')
% 
% plot(coords_tpx(good_cds,1),coords_tpx(good_cds,2),'r.')
% plot_coasts_black
