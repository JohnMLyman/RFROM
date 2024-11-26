function [temp_ave,ht_curve,time,model,y_model]=gilson_ave_temp()


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
CT = gsw_CT_from_pt(SA,temp);

save([path_file,'RG_ArgoClim_CT_SA_2019.mat'],'CT','SA','lon','lat','pres','time','-v7.3')



bmask(~isfinite(bmask))=0;
bmask=logical(bmask);
bmask=repmat(bmask,1,1,1,s(4));

time=2004+time./12;



arw=areavec(lon,lat);
arw_total=repmat(arw,1,1,s(3),s(4));
delta_p=[pres(1);diff(pres)];
delta_p_total(1,1,:)=delta_p;
delta_p_total=repmat(delta_p_total,s(1),s(2),1,s(4));

heat=gsw_rho(SA,CT,pres_big).*gsw_cp0.*CT.*delta_p_total;
heat(~bmask)=nan;
save([path_file,'RG_ArgoClim_heat_2019.mat'],'heat','lon','lat','pres','time','-v7.3')
volume=arw_total.*delta_p_total;
volume(~bmask)=nan;

temp=temp.*volume;

temp=nansum(temp,1);
temp=nansum(temp,2);
temp=squeeze(nansum(temp,3));

volume=nansum(volume,1);
volume=nansum(volume,2);
volume=squeeze(nansum(volume,3));



temp_ave=temp./volume;

ht_curve=temp*sw_dens(34.7,6,0)*sw_cp(34.7,6,0);





[model,amp_annual,phase_annual,amp_semi,phase_semi,amp_third,phase_third,slope,mean,model_err]=...
                     j_fit_annual_tree(time',ht_curve');


period=1;
period2=1/2;
period3=1/3;

% make grided INTERPOLANTS FOR BOTH 
t=time;
center_year=nanmean(t);
y_model=amp_annual*sin((2*pi*t./period)+phase_annual)+amp_semi*sin((2*t*pi./period2)+phase_semi)+...
  amp_third*sin((2*pi*t./period3)+phase_third)+slope*center_year+mean;







