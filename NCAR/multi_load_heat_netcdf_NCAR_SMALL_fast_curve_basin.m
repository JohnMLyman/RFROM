function [yr,ohca_curve_total,layer_bounds_NCAR_out]=multi_load_heat_netcdf_NCAR_SMALL_fast_curve_basin(years_load,TreeSetUp,latmin,latmax,basin_number)
tic

path_NCAR_SMALL='L:\data\NCAR\small_grid\heat\';

layer_bounds=TreeSetUp.layer_bounds;

sdir=dir([path_NCAR_SMALL,'heat_NCAR_POP_small_*.nc']);

nlayers=length(layer_bounds);
nfiles=length(sdir);
yr_tot=nan(1,nfiles);
for ifile=1:nfiles

    yr_tot(ifile)=ncread([sdir(ifile).folder,'\',sdir(ifile).name],'time_yrfrac');

end

good_files=find(floor(yr_tot)>=min(years_load) & floor(yr_tot)<=max(years_load));

ngood=length(good_files);
dz=ncread([sdir(1).folder,'\',sdir(1).name],'dz');
depth=ncread([sdir(1).folder,'\',sdir(1).name],'depth');
lon=ncread([sdir(1).folder,'\',sdir(1).name],'longitude');
lat=ncread([sdir(1).folder,'\',sdir(1).name],'latitude');
ndepth=length(dz);
nlon=length(lon);
nlat=length(lat);



[LAT,LON]=meshgrid(lat,lon);
[global_basins]=find_basin_paige(LON,LAT);
ohca_curve_total=nan(nlayers-1,ngood,12);
arw_total=ones(length(lon),length(lat),12);

for basin_number=1:12
    arw=areavec(lon,lat);
    if basin_number~=12
        
        basin_mask=double((global_basins(basin_number).pos));
        basin_mask(~basin_mask)=NaN;
    else
        basin_mask=ones(length(lon),length(lat));
    end
    
    
    
    if exist('latmax','var')
          bad=lat>latmax|lat<latmin;
           arw(:,bad)=nan;
    
    end
    arw_total(:,:,basin_number)=arw.*basin_mask;
end
depth=depth+.5*dz;
depth=depth(1:ndepth);

layer_bounds_NCAR=round([0,depth']);


yr=nan(1,ngood);



%% this is so that it matches what is done in make_vertical_year.m

load('D:\data\topo_tpx_new.mat','topo_tpx_new','lat_topo','lon_topo')
nlon_tpx=length(lon_topo);
nlat_tpx=length(lat_topo);
topo_tpx_new=-1.*topo_tpx_new;
%%
ohca_curve_out=nan(nlayers-1,ngood);

time_total_toc_old=0;
% N=2;
% myCluster=parcluster('local'); myCluster.NumWorkers=N; parpool(myCluster,N);
for ipos=1:ngood
      ipos
      ngood
     ifile=good_files(ipos);

     yr(ipos)=ncread([sdir(ifile).folder,'\',sdir(ifile).name],'time_yrfrac');
     HEAT=ncread([sdir(ifile).folder,'\',sdir(ifile).name],'heat');
     
    





    start_ind=1;
    layer_bounds_NCAR_out=layer_bounds;

    for ilayer=2:nlayers
        
        %% this is so that it matches what is done in make_vertical_year.m
        
        scale=ones(nlon_tpx,nlat_tpx);
        depth_min=layer_bounds(ilayer-1);
        depth_max=layer_bounds(ilayer);
        mid=topo_tpx_new>=depth_min & topo_tpx_new<depth_max;
        shallow=topo_tpx_new < depth_min;

        scale(mid)=scale(mid).*(topo_tpx_new(mid)-depth_min)./(depth_max-depth_min);
        scale(shallow)=NaN;
%%

        diff_bounds=abs(layer_bounds_NCAR-layer_bounds(ilayer));
        [~,end_ind]=min(diff_bounds);
        end_ind=end_ind-1;
        good_depth=start_ind:end_ind;
    
        heat_junk=sum((HEAT(:,:,good_depth)),3);
        layer_bounds_NCAR_out(ilayer)=layer_bounds_NCAR(end_ind+1);
        for basin_number=1:12
            arw=squeeze(arw_total(:,:,basin_number));
            ohca_curve=heat_junk.*scale.*arw;
            ohca_curve=jnansum(ohca_curve,1);
            ohca_curve=squeeze(jnansum(ohca_curve,2));
    %         ohca_curve_out(ilayer-1,ipos)=ohca_curve;
            ohca_curve_total(ilayer-1,ipos,basin_number)=ohca_curve;
        end
 
     
        start_ind=end_ind+1;
    end
    
end










