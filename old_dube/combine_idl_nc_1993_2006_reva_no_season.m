% This code cobines the nc files into one file

% load first file



ncload('htanom_reva_no_season_1993_1996.nc','lon','lat','tpx','tpx_no','time','one','error')
 
tpx_no_t=tpx_no;
time_t=time';
one_t=one;
tpx_t=tpx;
error_t=error;

ncload('htanom_reva_no_season_1997_2000.nc','lon','lat','tpx','tpx_no','time','one','error')

tpx_no_t=[tpx_no_t;tpx_no];
one_t=[one_t;one];
tpx_t=[tpx_t;tpx];
error_t=[error_t;error];
time_t=[time_t ,time'];

ncload('htanom_reva_no_season_2001_2003.nc','lon','lat','tpx','tpx_no','time','one','error')

tpx_no_t=[tpx_no_t;tpx_no];
one_t=[one_t;one];
tpx_t=[tpx_t;tpx];
error_t=[error_t;error];
time_t=[time_t ,time'];


ncload('htanom_reva_no_season_2004_2006.nc','lon','lat','tpx','tpx_no','time','one','error')

tpx_no_t=[tpx_no_t;tpx_no];
one_t=[one_t;one];
tpx_t=[tpx_t;tpx];
error_t=[error_t;error];
time_t=[time_t ,time'];
  


error=error_t;
time=time_t;
one=one_t;
tpx=tpx_t;
tpx_no=tpx_no_t;

tpx_no=permute(tpx_no,[3 2 1]);

one=permute(one,[3 2 1]);

tpx=permute(tpx,[3 2 1]);
error=permute(error,[3 2 1]);


%ht(isnan(ht))=0;
%one(isnan(one))=0;
%tps(isnan(tpx))=0;

save 'htanom_1993_2006_reva_no_season' time lon lat one tpx error tpx_no



