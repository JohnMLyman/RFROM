function [heat_curve,time]=make_gilson_heat_maps()


file='RG_ArgoClim_Temperature_2019.nc';
file_s='RG_ArgoClim_Salinity_2019.nc';
path_file= 'C:\Users\jlyma\OneDrive - University of Hawaii\data\Roemmich_Gilson_Clim\';
file_name=[path_file,file];
file_name_s=[path_file,file_s];

time=ncread(file_name,'TIME');
lat=ncread(file_name,'LATITUDE');
lon=ncread(file_name,'LONGITUDE');
pres=ncread(file_name,'PRESSURE');
mask=ncread(file_name,'MAPPING_MASK');
bmask=ncread(file_name,'BATHYMETRY_MASK');
temp=ncread(file_name,'ARGO_TEMPERATURE_ANOMALY');
mean_temp=ncread(file_name,'ARGO_TEMPERATURE_MEAN');
sal=ncread(file_name_s,'ARGO_SALINITY_ANOMALY');
mean_sal=ncread(file_name_s,'ARGO_SALINITY_MEAN');

time=2004+time./12;

s=size(temp);
lons=lon;
lons(lons>360)=lons(lons>360)-360;

lon_big=repmat(lons,1,s(2),s(3),s(4));
lat_big(1,:)=lat;
lat_big=repmat(lat_big,s(1),1,s(3),s(4));
pres_big(1,1,:)=pres;
pres_big=repmat(pres_big,s(1),s(2),1,s(4));



mean_temp=repmat(mean_temp,1,1,1,s(4));
mean_sal=repmat(mean_sal,1,1,1,s(4));

temp=temp+mean_temp;
sal=sal+mean_sal;

[SA, ~] = gsw_SA_from_SP(sal,pres_big,lon_big,lat_big);
CT = gsw_CT_from_t(SA,temp,pres_big);

save([path_file,'RG_ArgoClim_CT_SA_2019.mat'],'CT','SA','lon','lat','pres','time','-v7.3')



bmask(~isfinite(bmask))=0;
bmask=logical(bmask);
bmask=repmat(bmask,1,1,1,s(4));





arw=areavec(lon,lat);
arw_total=repmat(arw,1,1,s(3),s(4));
delta_p=[pres(1);diff(pres)];
delta_p_total(1,1,:)=delta_p;
delta_p_total=repmat(delta_p_total,s(1),s(2),1,s(4));

heat=gsw_rho(SA,CT,pres_big).*gsw_cp0.*CT.*delta_p_total;
heat(~bmask)=nan;
save([path_file,'RG_ArgoClim_heat_2019.mat'],'heat','lon','lat','pres','time','-v7.3')

heat_curve=heat.*arw_total;

heat_curve=nansum(heat_curve,3);
heat_curve=nansum(heat_curve,2);
heat_curve=squeeze(nansum(heat_curve,1));








