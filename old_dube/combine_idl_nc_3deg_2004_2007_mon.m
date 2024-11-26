% This code cobines the nc files into one file

% load first file
cd '/Users/johnlyman/data/Globalhc/SAL/Floats'


ncload('htanom_mon_time_3deg_2004_2007_clim_2_mon_2004_2008_from_1_12.nc','lon','lat','ht','htdiff','time','one','tpx','error')
 
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

good=find(time < 5008);
time=time(good);
error=error(:,:,good);
one=one(:,:,good);
ht=ht(:,:,good);
%tpx=tpx(:,:,good);
htdiff=htdiff(:,:,good);
%ht(isnan(ht))=0;
%one(isnan(one))=0;
%tps(isnan(tpx))=0;

save 'htanom_3deg_2004_2007' time lon lat one ht error htdiff



