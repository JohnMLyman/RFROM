% This code cobines the nc files into one file

% load first file

path='/Volumes/Data/xbt/CRISO/Globalhc/SAL/Floats/'

original=cd(path);

ncload( 'htanom_700_1950_1992.nc','lon','lat','ht','htdiff','time','one','tpx','error')
 
ht_t=ht;
htdiff_t=htdiff;
time_t=time';
one_t=one;
tpx_t=tpx;
error_t=error;


ncload([path, 'htanom_700_1993_2008.nc'],'lon','lat','ht','htdiff','time','one','tpx','error')
 
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

save 'htanom_1950_2008_700_CRISO' time lon lat one ht tpx error htdiff

cd,original

