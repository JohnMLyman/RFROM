% This code cobines the nc files into one file

% load first file
cd '/Users/johnlyman/data/Globalhc/SAL/Floats'


ncload('htanom_900_pfloat_sal_greg_march_2010_2004_2009.nc','lon','lat','ht','htdiff','time','one','tpx','error')
 
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

save 'htanom_2004_2007_year_900' time lon lat one ht tpx error htdiff



