path_file= 'H:\erddap\heat_novert_paige_sulunetcdf_1x1\tree_heat_novert_test\yearly_withcycle_no_mean\';
file_nc='RFROM_HEAT_1x1xmonth_v22_paige.nc';
file_prefix='RFROMV22_OHC_';
subdir='yearly_withcycle_no_mean';






path_nc_erddap_out=[path_ERDDAP,'netcdf_1x1\',tree_prefix,'\',subdir,'\'];


time=ncread([path_file,file_nc],'time');
ht=double(ncread([path_file,file_nc], 'ocean_heat_content_anomaly'))*1e9;
lat=ncread([path_file,file_nc], 'latitude');
lon=ncread([path_file,file_nc], 'longitude');
depth=ncread([path_file,file_nc], 'mean_depth');
tgrid=decyear(datevec(double(time)+datenum(1950,1,1)));

arw=areavec(lon,lat);
ht_2000=squeeze(jnansum(ht,3)).*arw;
curve_heat=jnansum(ht_2000,1);
curve_heat=squeeze(jnansum(curve_heat,2));
% arw=areavec(lon,lat);
% 
% ht_2000=ht_2000.*arw;

% monthly then smoothed
area_of_earth=5.1e14;

ndays=365.25;

sec_in_day=(60.*60*24);
fac_year=1./(sec_in_day*ndays);
fac_day=1./(sec_in_day*area_of_earth.*1);
 ht_12mon=ht_2000*nan;
 curve_ht_12mon=curve_heat*nan;


for iyear=tgrid'

    good=tgrid>=iyear-.5 & tgrid<=iyear+.5;


    ht_12mon(:,:,tgrid==iyear)=mean(ht_2000(:,:,good),3,'omitnan');
   curve_ht_12mon(tgrid==iyear)=mean(curve_heat(good),'omitnan');
end


rate_12mon=-1.*(ht_12mon(:,:,1:end-12)-ht_12mon(:,:,13:end)).*fac_year;
curve_rate_12mon=-1.*(curve_ht_12mon(1:end-12)-curve_ht_12mon(13:end)).*fac_year;


tgrid_rate_12mon=(tgrid(1:end-12)+tgrid(13:end))./2;

curve_ohu=jnansum(rate_12mon,1);
curve_ohu=squeeze(jnansum(curve_ohu,2));