function multi_make_heat_netcdf_NCAR_SMALL(years_load,TreeSetUp)
tic

path_NCAR_SMALL='L:\data\NCAR\small_grid\';
path_NCAR_SMALL_heat_out='L:\data\NCAR\small_grid\heat\';

layer_bounds=TreeSetUp.layer_bounds;

sdir=dir([path_NCAR_SMALL,'NCAR_POP_small_*.nc']);

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
ndepth=46;
nlon=length(lon);
nlat=length(lat);

depth_file=depth;
depth=depth+.5*dz;
depth=depth(1:ndepth);
dz=dz(1:ndepth);
depth_file=depth_file(1:ndepth);

depth_wide=reshape(depth,[1 1 ndepth]);
dz_wide=reshape(dz,[1 1 ndepth]);

LON=repmat(lon,[1 nlat ndepth]);
LAT=repmat(lat',[nlon 1 ndepth]);
DEPTH=repmat(depth_wide,[nlon nlat 1]);
DZ=repmat(dz_wide,[nlon nlat 1]);
PRES= gsw_p_from_z(-1.*DEPTH,LAT);




%% this is so that it matches what is done in make_vertical_year.m
N=10
N=24;
myCluster=parcluster('local'); myCluster.NumWorkers=N; parpool(myCluster,N);
parfor ipos=1:ngood
      
     ifile=good_files(ipos);

     time_yrfrac=ncread([sdir(ifile).folder,'\',sdir(ifile).name],'time_yrfrac');
     time=ncread([sdir(ifile).folder,'\',sdir(ifile).name],'time');
     sal=ncread([sdir(ifile).folder,'\',sdir(ifile).name],'sal');
     sal=sal(:,:,1:ndepth);

     ptemp=ncread([sdir(ifile).folder,'\',sdir(ifile).name],'ptemp');
     ptemp=ptemp(:,:,1:ndepth);


    [SA, ~] = gsw_SA_from_SP(sal,PRES,LON,LAT);
    CT=gsw_CT_from_pt(SA,ptemp);    
     HEAT=gsw_rho(SA,CT,PRES).*gsw_cp0.*CT.*DZ;

    
    file_name_nc=[path_NCAR_SMALL_heat_out,'heat_',sdir(ifile).name]

    write_netcfd_cf_heat_NCAR_rect(HEAT,time,time_yrfrac,lon,...
    lat,depth_file,dz,file_name_nc);
    
    


end






