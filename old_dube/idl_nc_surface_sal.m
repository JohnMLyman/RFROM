% This code cobines the nc files into one file

% load first file



ncload('surface_sal_anom_3_error_2004_2005.nc','lon','lat','sal','time','one','tpx','error')
 

time=time';



sal=permute(sal,[3 2 1]);

one=permute(one,[3 2 1]);

tpx=permute(tpx,[3 2 1]);
error=permute(error,[3 2 1]);


sal(isnan(sal))=0;
one(isnan(one))=0;
tps(isnan(tpx))=0;

save 'surface_sal_anom_3_error_2004_2005' time lon lat one sal tpx error



