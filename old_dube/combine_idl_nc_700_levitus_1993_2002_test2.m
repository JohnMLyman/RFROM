% This code cobines the nc files into one file

% load first file



path='/Volumes/Data/xbt/Levitus/Globalhc/SAL/Floats/'

original=cd(path);




ncload('htanom_700_1993_2002_test2_1993_1995.nc','lon','lat','ht','htdiff','time','one','tpx','error')

 

ht_t=ht;
htdiff_t=htdiff;
time_t=time';
one_t=one;
tpx_t=tpx;
error_t=error;


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
save 'htanom_1993_2002_test2_1993_1995_700_levitus' time lon lat one ht tpx error htdiff




cd,original
