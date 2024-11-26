function [junk]=tim_files(file_name)
load /Volumes/Data/Globalhc/Mtpers/meanssh lat lon sshmean
% to get rid of ice
sshmean=[sshmean(542:end,:);sshmean(1:541,:)];

lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;
arw=areavec(lon_tpx,lat_tpx);
clear lon lat
junk=1;


load /Volumes/Data/Globalhc/HC/landmask msk2

load /Users/johnlyman/data/Globalhc/SAL/Floats/htanom_1993_2002_realtime_oco_jan27_1993_2009

 
 
ind_2008=find(time == 2008.5);
ind_2009=find(time == 2009.5);
 


corrhc=interp2(lat,lon,ht(:,:,ind_2008),lat_tpx,lon_tpx');
corrhc(isnan(msk2(2:end-1,:)))=NaN;
corrhc(isnan(sshmean))=NaN;


ht_2008= corrhc;


corrhc=interp2(lat,lon,ht(:,:,ind_2009),lat_tpx,lon_tpx');
corrhc(isnan(msk2(2:end-1,:)))=NaN;
corrhc(isnan(sshmean))=NaN;

ht_2009=corrhc;


% output to an ascii file!!!!!

nlon=length(lon_tpx)
nlat=length(lat_tpx)

fid=fopen('hc_PMEL_2008_2.ascii','w');

fprintf(fid,'Nlon= %6.2f  Nlat= %6.2f \n',nlon,nlat);
fprintf(fid,'     Lat          Lon            OHCA \n');
for ilat=1:nlat
    for ilon=1:nlon
        
      fprintf(fid,'%e  %e %e \n',lat_tpx(ilat),lon_tpx(ilon),ht_2008(ilon,ilat));
      
     
    end
end

fclose(fid);


fid=fopen('hc_PMEL_2009_2.ascii','w');

fprintf(fid,'Nlon= %6.2f  Nlat= %6.2f \n',nlon,nlat);
fprintf(fid,'     Lat          Lon            OHCA \n');
for ilat=1:nlat
    for ilon=1:nlon
        
      fprintf(fid,'%e  %e %e \n',lat_tpx(ilat),lon_tpx(ilon),ht_2009(ilon,ilat));
      
     
    end
end

fclose(fid);








