topo_test=topo_tpx_new;
pos_bad=find_bad_depths(LON,LAT);

figure(6)
clf
topom=topo_test;
topom(topom<-500|topom>1|pos_bad)=nan;
% topom(~global_basins(ibasin).pos)=nan;
pcolor(lon_topo,lat_topo,topom')
shading flat
plot_coasts_black
