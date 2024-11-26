for ipos=1:length(time_use)
    good_day=floor(timep)==time_use(ipos);
    good_year=floor(yr)==yr_value;
    good_time=good_year & good_day;
    sst_plot=sst_anom_year_use(:,:,ipos);
    figure
    pcolor(lon_sst,lat_sst,sst_plot')
    hold on
    shading flat
    scatter(lonp_360(good_time),latp(good_time),[],(sst(good_time)),'filled')
    scatter(lonp_360(good_time),latp(good_time),[],(sst(good_time)),'k')
end
