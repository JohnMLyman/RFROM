load('C:\Users\jlyma\OneDrive - University of Hawaii\data\topo.mat')

lat_topo=lat;
lon_topo=lon;
pos_end=lon_topo<=0 & lon_topo>=-180;
pos_start=lon_topo>0 & lon_topo<180;
lon_topo_360=[lon_topo(pos_start) lon_topo(pos_end)+360] ;
plot(lon_topo_360)

topo_360=[topo(pos_start,:);topo(pos_end,:)];
lat_topo=lat_topo(end:-1:1);
topo_360=topo_360(:,end:-1:1);
clear lon lat
load( 'C:\OHCA\Mtpers\matlab_files\ssh15706.mat')
lon_tpx=lon;
lat_tpx=lat;
clear lon lat sshanom

 [LON,LAT]=ndgrid(lon_topo_360,lat_topo);
  
 % put time into scalled time

  F=griddedInterpolant(LON,LAT,topo_360);

 [LONt,LATt]=ndgrid(lon_tpx,lat_tpx);

  
  
  topo_tpx_new=F(LONt,LATt);



lat_topo=lat_tpx;
lon_topo=lon_tpx;

figure
 pcolor(lon_topo,lat_topo,topo_tpx_new')
 shading flat
hold on
plot_coasts_black
save 'C:\Users\jlyma\OneDrive_UH\data\topo_tpx_new.mat' lon_topo lat_topo topo_tpx_new
