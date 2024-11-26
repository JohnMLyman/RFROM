% This code cobines the nc files into one file

% load first file



ncload('htanom_xbt_test_greg_no_te_1993_1997.nc','lon','lat','ht','htdiff','time','one','tpx','error')
 
ht_t=ht;
htdiff_t=htdiff;
time_t=time';
one_t=one;
tpx_t=tpx;
error_t=error;

ncload('htanom_xbt_test_greg_no_te_1998_2002.nc','lon','ht','time','htdiff','one','tpx','error')
ht_t=[ht_t;ht];
htdiff_t=[htdiff_t;htdiff];
one_t=[one_t;one];
tpx_t=[tpx_t;tpx];
error_t=[error_t;error];

time_t=[time_t ,time'];

  

ncload('htanom_xbt_test_greg_no_te_2003_2006.nc','lon','ht','time','htdiff','one','tpx','error')
ht_t=[ht_t;ht];
htdiff_t=[htdiff_t;htdiff];
one_t=[one_t;one];
tpx_t=[tpx_t;tpx];
error_t=[error_t;error];

time_t=[time_t ,time'];

error=error_t;
time=time_t;
ht=ht_t;
one=one_t;
tpx=tpx_t;
htdiff=htdiff_t;

ht=permute(ht,[3 2 1]);
htdiff=permute(htdiff,[3 2 1]);

one=permute(one,[3 2 1]);

tpx=permute(tpx,[3 2 1]);
error=permute(error,[3 2 1]);


%ht(isnan(ht))=0;
%one(isnan(one))=0;
%tps(isnan(tpx))=0;

save 'htanom_1993_2006_greg_xbt_no_te' time lon lat one ht tpx error htdiff



