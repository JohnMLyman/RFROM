% this code loads all the heat content into one file

%You to update this file so that it only 

path='/Volumes/Data/Globalhc/SAL/Floats/'

original=cd(path);


 load 'htanom_2005_2008_not_1993_2008_700_lyman.mat'
 
hc_700=ht;


nlon=length(lon);
nlat=length(lat);
ntime=length(time);

% this part of the code fits a line to each point in space

slope=nans(nlon,nlat);
trend=nans(nlon,nlat,ntime);
error=slope;
for ilon=1:nlon
    for ilat=1:nlat
        
        hc=reshape(hc_700(ilon,ilat,:),1,ntime);
        good=find(isfinite(hc));
        if length(good)>2
            
          
        [jy_model,jy_model_err_95,jslope_error,jslope]=j_fit(time(good),hc(good));
        trend(ilon,ilat,good)=jy_model;
        slope(ilon,ilat)=jslope;
        error(ilon,ilat)=jslope_error;
        end
        
    end
end


save slope_hc_700_2008 slope error trend time lat lon


cd,original

