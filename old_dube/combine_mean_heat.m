 
file_path='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/'
file_path_out='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
file_name='pfloat_sal_greg_jan_2011'
file_path_hdata='/Users/johnlyman/data/Globalhc/HC/'


eval(['load ',file_path_out,file_name,'_mean_heat_oco_100 mean_heat_1800 mean_heat_900 mean_heat_700 mean_heat_300 mean_heat_100 lon_grid lat_grid'])

lon_grid_g=lon_grid;

lat_grid_g=lat_grid;

eval(['load ',file_path_out,file_name,'_mean_heat_oa_oco_100 mean_heat_oa_1800 mean_heat_oa_900 mean_heat_oa_700 mean_heat_oa_300 mean_heat_oa_100 lon_grid lat_grid'])

%%

ht_700g=interp2(lat_grid_g,lon_grid_g,mean_heat_700,lat_grid,lon_grid');

ht_mean=ht_700g+mean_heat_oa_700;

%%
file_path_out='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
file_name=['hdata_100_','pfloat_sal_greg_jan_2011'];
file_path='/Users/johnlyman/data/Globalhc/HC/'
signal_to_noise=4;
idepth=700;

eval(['load ',file_path,file_name,'_',num2str(idepth),'_',num2str(signal_to_noise),'_season_gausian_mean2.mat ht htdiff tpx one lon lat time small_scale large_scale signal_to_noise time_scale'])

nlon=length(lon_grid);
nlat=length(lat_grid);
ntime=length(time);


ht_total=nans(nlon,nlat,ntime);

for itime=1:length(time)
    
    junkht=squeeze(ht(:,:,itime));
    ht_junk=interp2(lat,lon,junkht,lat_grid,lon_grid');
    ht_total(:,:,itime)=ht_junk+ht_mean;

end

%%
lat=lat_grid;

ht=ht_total;
lon=lon_grid;

eval(['save ',file_path,file_name,'_',num2str(idepth),'_',num2str(signal_to_noise),'_season_gausian_mean2_total.mat ht lon lat time'])
