% this code loads all the heat content into one file

%You to update this file so that it only 


% this part of the code fits a line to each point in space

time=time_aviso;
lat=lat_tpx';
lon=lon_tpx';
nlon_tpx=length(lon_tpx);
nlat_tpx=length(lat_tpx);
slope=nans(nlon_tpx,nlat_tpx);
error=slope;





% this might need to changed if j_fit doesn't work.

good=find(time>=slope_min_year);
ntime=length(good);
time=time(good);
for ilon=1:nlon_tpx
    for ilat=1:nlat_tpx
        
        hc=reshape(ht_estimate(ilon,ilat,good),1,ntime);
        use_for_slope=isfinite(hc);
        nuse=length(find(use_for_slope));
        
        if nuse >.7*ntime & length(find(hc == 0))<.7* nuse
            
           
        [jy_model,jy_model_err_95,jslope_error,jslope]=j_fit(time(use_for_slope),hc(use_for_slope));
        slope(ilon,ilat)=jslope;
        error(ilon,ilat)=jslope_error;
        end
        
    end
end


save(heat_slope_file,'slope','error', 'time', 'lat', 'lon')




