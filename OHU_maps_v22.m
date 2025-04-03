
% function OHU_maps_v22(TreeSetUp)

TreeSetUp=TreeSetUp_2025_orca_heat_novert_test_paige_sulu;
tree_prefix=TreeSetUp.tree_prefix;
end_year=TreeSetUp.end_year;
path_file= 'H:\erddap\heat_novert_paige_sulunetcdf_1x1\tree_heat_novert_test\yearly_withcycle_no_mean\';
path_ERDDAP=TreeSetUp.path_ERDDAP;
path_Fig_data=TreeSetUp.path_Fig_data;

file_nc='RFROM_HEAT_1x1xmonth_v22_paige.nc';

subdir='yearly_withcycle_no_mean';



file_txt=[path_Fig_data,'RFROMv22_OHU_',num2str(end_year.*10),'.txt'];

% read in the OHU txt file

C=fileread(file_txt);
%get rid of the header
C=str2num(C(30:end));

ohu_time_full=C(:,1);
ohu_full=C(:,2);

path_file=[path_ERDDAP,'netcdf_1x1\',tree_prefix,'\',subdir,'\'];


time=ncread([path_file,file_nc],'time');
ht=double(ncread([path_file,file_nc], 'ocean_heat_content_anomaly'))*1e9;
lat=ncread([path_file,file_nc], 'latitude');
lon=ncread([path_file,file_nc], 'longitude');
depth=ncread([path_file,file_nc], 'mean_depth');
tgrid=decyear(datevec(double(time)+datenum(1950,1,1)));
nlon=length(lon);
nlat=length(lat);

arw=areavec(lon,lat);
% ht_2000=squeeze(jnansum(ht(:,:,1:2,:),3));
ht_2000=squeeze(jnansum(ht,3));

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

[~,pos_start]=min(abs(tgrid_rate_12mon-ohu_time_full(1)));
[~,pos_end]=min(abs(tgrid_rate_12mon-ohu_time_full(end)));

rate_12mon=rate_12mon(:,:,pos_start:pos_end);
curve_rate_12mon=curve_rate_12mon(pos_start:pos_end);
curve_ohu=curve_ohu(pos_start:pos_end);

tgrid_rate_12mon=tgrid_rate_12mon(pos_start:pos_end);

coeff_annual_annual=nan(nlon,nlat);
coeff_annual_annual1=nan(nlon,nlat);
 junk2=squeeze(ohu_full);

for ilat=1:nlat
    for ilon=1:nlon
        junk1=squeeze(rate_12mon(ilon,ilat,:));
        
        if sum(isfinite(junk1))>=10
            coeff_annual_annual(ilon,ilat)=regress(junk2,junk1);
            coeff_annual_annual1(ilon,ilat)=regress(junk1,junk2);
        end

    end
end




% end