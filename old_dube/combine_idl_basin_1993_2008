% This code cobines the nc files into one file

% load first file
cd '/Users/johnlyman/data/Globalhc/SAL/Floats'

file_name='htanom_mon_time_3deg_new_clim_2005_2008_mon2';


[ht,htdiff,time,one,error,lon,lat]=load_basin(file_name,'2005_2006');
 
ht_t=ht;
htdiff_t=htdiff;
time_t=time';
one_t=one;

error_t=error;

[ht,htdiff,time,one,error,lon,lat]=load_basin(file_name,'2007_2008');

ht_t=[ht_t;ht];
htdiff_t=[htdiff_t;htdiff];
one_t=[one_t;one];

error_t=[error_t;error];

time_t=[time_t ,time'];

error=error_t;
time=time_t;
ht=ht_t;
one=one_t;

htdiff=htdiff_t;

ht=permute(ht,[3 2 1]);
htdiff=permute(htdiff,[3 2 1]);

one=permute(one,[3 2 1]);


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

save 'htanom_basin_mon2_2005_2008' time lon lat one ht error htdiff



