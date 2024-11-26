path_file= 'C:\Users\jlyma\OneDrive - University of Hawaii\data\Roemmich_Gilson_Clim\';

load([path_file,'RG_ArgoClim_heat_all2.mat'],'heat','time','lon','lat')
heat=double(heat);
time_gilson=double(time);
nt_gilson=length(time);
arw=areavec(lon,lat);
 arw_gilson=repmat(arw,1,1,nt_gilson);
  ht_curve_gilson=squeeze(nansum(heat,3));
  clear heat

  ht_curve_gilson=squeeze(nansum(ht_curve_gilson.*arw_gilson,1));
  ht_curve_gilson=double(squeeze(nansum(ht_curve_gilson,1)));

  save([path_file,'RG_ArgoClim_heatcurve_all2.mat'],'ht_curve_gilson','time_gilson')