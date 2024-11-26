% ht_diff_1993_2004_xbt_no_te comes from code ../SAL/Floats/make_heat_diff_array_oco_2007
%load ../SAL/Floats/data/ht_diff_1993_2004_xbt_no_te lat lon tgrid hc_diff
%load ../SAL/Floats/data/ht_diff_1993_2004_no_te_delayed lat lon tgrid hc_diff
load ../SAL/Floats/data/ht_diff_1993_2006_xbt_delayed lat lon tgrid hc_diff
time=tgrid;
map_hc=hc_diff;

% this part of the code fits a line to each point in space
nlon=length(lon);
nlat=length(lat);
ntime=length(time);
slope=nans(nlon,nlat);
error=slope;
for ilon=1:nlon
    for ilat=1:nlat
        
        hc=reshape(map_hc(ilon,ilat,:),1,ntime);
        [jy_model,jy_model_err_95,jslope_error,jslope]=j_fit(time,hc);
        slope(ilon,ilat)=jslope;
        error(ilon,ilat)=jslope_error;
        
    end
end


save slope_heat_2007_delayed slope error time lat lon




