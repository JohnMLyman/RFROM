% This code cobines the nc files into one file

% load first file






  
ncload('htanom_diff_test_realtime_jan_2007_3_error_2003_2003.nc','lat','lon','ht','time','one','htdiff','error')

ht_t=ht;
one_t=one;
htdiff_t=htdiff;
error_t=error;

time_t=time';
ncload('htanom_diff_test_realtime_jan_2007_3_error_2004_2004.nc','lon','ht','time','one','htdiff','error')

ht_t=[ht_t;ht];
one_t=[one_t;one];
htdiff_t=[htdiff_t;htdiff];
error_t=[error_t;error];

time_t=[time_t ,time'];

ncload('htanom_diff_test_realtime_jan_2007_3_error_2005_2005.nc','lon','ht','time','one','htdiff','error')
   ht_t=[ht_t;ht];
one_t=[one_t;one];
htdiff_t=[htdiff_t;htdiff];
error_t=[error_t;error];

time_t=[time_t ,time'];


ncload('htanom_diff_test_realtime_jan_2007_3_error_2006_2006.nc','lon','ht','time','one','htdiff','error')
   ht_t=[ht_t;ht];
one_t=[one_t;one];
htdiff_t=[htdiff_t;htdiff];
error_t=[error_t;error];

time_t=[time_t ,time'];


error=error_t;
time=time_t;
ht=ht_t;
one=one_t;
htdiff=htdiff_t;

ht=permute(ht,[3 2 1]);

one=permute(one,[3 2 1]);

htdiff=permute(htdiff,[3 2 1]);
error=permute(error,[3 2 1]);


ht(isnan(ht))=0;
one(isnan(one))=0;
htdiff(isnan(htdiff))=0;

save 'htanom_2003_2006_3_error_jan_2007' time lon lat one ht htdiff error 



