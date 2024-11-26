% this code loads all the heat content into one file

%You to update this file so that it only 

path='/Volumes/Data/Globalhc/SAL/Floats/'

original=cd(path);

ncload('surface_sal_anom_3_error_6_deg_jan_2004_2009.nc','lat','lon','time','one','sal','error');

surface_sal=permute(sal,[3 2 1]);
time=time';

nlon=length(lon);
nlat=length(lat);
ntime=length(time);

% this part of the code fits a line to each point in space

slope=nans(nlon,nlat);
error=slope;
for ilon=1:nlon
    for ilat=1:nlat
        
        hc=reshape(surface_sal(ilon,ilat,:),1,ntime);
        if length(find(isfinite(hc) ==0))<1
            
           
        [jy_model,jy_model_err_95,jslope_error,jslope]=j_fit(time,hc);
        slope(ilon,ilat)=jslope;
        error(ilon,ilat)=jslope_error;
        end
        
    end
end


save slope_salt_2009_early slope error time lat lon


cd,original

