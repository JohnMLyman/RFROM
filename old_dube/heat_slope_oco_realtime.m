% this code loads all the heat content into one file

%You to update this file so that it only 

path='/Volumes/Data/Globalhc/SAL/Floats/'

original=cd(path);


load htanom_oco_realtime_1993_2009

ind_2008=find(time == 2009.5);

ht_2008=htdiff(:,:,ind_2008)./1e9;
one_2008=one(:,:,ind_2008);

nlon=length(lon);
nlat=length(lat);
ntime=length(time);

% this part of the code fits a line to each point in space

slope=nans(nlon,nlat);
error=slope;
for ilon=1:nlon
    for ilat=1:nlat
        
        hc=reshape(ht(ilon,ilat,:),1,ntime);
        if length(find(isfinite(hc) ==0))<1
            
           
        [jy_model,jy_model_err_95,jslope_error,jslope]=j_fit(time,hc);
        slope(ilon,ilat)=jslope;
        error(ilon,ilat)=jslope_error;
        end
        
    end
end


save slope_heat_2009 slope error time lat lon


cd,original

