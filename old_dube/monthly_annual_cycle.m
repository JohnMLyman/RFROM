cd '/Users/johnlyman/data/Globalhc/SAL/Floats'

load htanom_1993_2007_mon_all_2004_2007_clim_2_11_4_2008

month=round(12.*(time-floor(time)))+1;
year=floor(time);

nlon=length(lon);
nlat=length(lat);

annual_cycle=ones(nlon,nlat,12)*NaN;


for imonth=1:12
    
    good=find(month == imonth & year>= 2004);
    
    junk=nanmean(ht(:,:,good),3);
    annual_cycle(:,:,imonth)=junk;

end

[max_cycle,month_max]=(max(permute(annual_cycle,[3 1 2])));

max_cycle=squeeze(max_cycle);
month_max=squeeze(month_max);

[min_cycle,month_min]=(min(permute(annual_cycle,[3 1 2])));

min_cycle=squeeze(min_cycle);
month_min=squeeze(month_min);

arw=areavec(lon,lat);
arw2=repmat(arw,[1,1,12]);
global_curve=nansum(annual_cycle.*arw2,1);
global_curve=nansum(global_curve,2);

area=arw(isnan(squeeze(nanmean(annual_cycle,3)))==0);

area_global=nansum(area);


global_curve=squeeze(global_curve);

