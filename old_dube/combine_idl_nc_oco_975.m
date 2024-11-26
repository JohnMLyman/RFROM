% This code cobines the nc files into one file

% load first file
cd '/Users/johnlyman/data/Globalhc/SAL/Floats'


ncload('htanom_mon_pfloat_sal_greg_june_2008_2004_2004_from_1_12_975.nc','lon','lat','ht','htdiff','time','one','tpx','error')
 
ht_t=ht;
htdiff_t=htdiff;
time_t=time';
one_t=one;
tpx_t=tpx;
error_t=error;

ncload('htanom_mon_pfloat_sal_greg_june_2008_2005_2005_from_1_12_975.nc','lon','ht','time','htdiff','one','tpx','error')
ht_t=[ht_t;ht];
htdiff_t=[htdiff_t;htdiff];
one_t=[one_t;one];
tpx_t=[tpx_t;tpx];
error_t=[error_t;error];

time_t=[time_t ,time'];

ncload('htanom_mon_pfloat_sal_greg_june_2008_2006_2006_from_1_12_975.nc','lon','ht','time','htdiff','one','tpx','error')
ht_t=[ht_t;ht];
htdiff_t=[htdiff_t;htdiff];
one_t=[one_t;one];
tpx_t=[tpx_t;tpx];
error_t=[error_t;error];

time_t=[time_t ,time'];

ncload('htanom_mon_pfloat_sal_greg_june_2008_2007_2007_from_1_12_975.nc','lon','ht','time','htdiff','one','tpx','error')
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

save 'htanom_2004_2007_mon_975' time lon lat one ht tpx error htdiff



