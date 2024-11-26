% This code cobines the nc files into one file

% load first file



ncload('htanom_3_error_1955_1990.nc','lat','lon','ht','time','one','tpx','error')
 
ht_t=ht;
time_t=time';
one_t=one;
tpx_t=tpx;
error_t=error;

ncload('htanom_3_error_1990_2006.nc','lon','ht','time','one','tpx','error')
ht_t=[ht_t;ht];
one_t=[one_t;one];
tpx_t=[tpx_t;tpx];
error_t=[error_t;error];

time_t=[time_t ,time'];

  

error=error_t;
time=time_t;
ht=ht_t;
one=one_t;
tpx=tpx_t;

ht=permute(ht,[3 2 1]);

one=permute(one,[3 2 1]);

tpx=permute(tpx,[3 2 1]);
error=permute(error,[3 2 1]);


ht(isnan(ht))=0;
one(isnan(one))=0;
tps(isnan(tpx))=0;

save 'htanom_1955_2006_3_error_jan_2007' time lon lat one ht tpx error



