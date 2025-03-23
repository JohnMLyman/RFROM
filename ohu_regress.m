path_file= 'H:\erddap\heat_novert_paige_sulunetcdf_1x1\tree_heat_novert_test\yearly_withcycle_no_mean\';

file_nc='RFROM_HEAT_1x1xmonth_v22_paige.nc';


heat=ncread([path_file,file_nc],'ocean_heat_content_anomaly');
time=ncread([path_file,file_nc],'time');
[y,m,d]=datevec(double(time)+datenum(1950,1,1));
tgrid=decyear(y,m,d);
s=size(heat)

% monthly then smoothed
area_of_earth=5.1e14;

ndays=365.25;

sec_in_day=(60.*60*24);
fac_year=1./(sec_in_day*area_of_earth.*ndays);

tgrid_12mon=[(1993.5-1/24):1./12.:end_year-1/24];
ht_12mon=nans(1,length(tgrid_12mon));
% ht_12mon_nofilt=nans(1,length(tgrid_12mon));

for iyear=tgrid_12mon

    good=tgrid>=iyear-.5 & tgrid<=iyear+.5;
  
    

    ht_12mon(tgrid_12mon==iyear)=mean(ht_all_no_cycle(good),'omitnan');
%     ht_12mon_nofilt(tgrid_12mon==iyear)=mean(ht_tree_all(good),'omitnan');
end


rate_12mon=-1.*(ht_12mon(1:end-12)-ht_12mon(13:end)).*fac_year;