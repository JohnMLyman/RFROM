% This code cobines the nc files into one file

% load first file






  
ncload('htanom_filter_2003_2004.nc','lat','lon','ht','time','one','htdiff','error')

ht_t=ht;
one_t=one;
htdiff_t=htdiff;
error_t=error;

time_t=time';
%ncload('htanom_q1_1950_2006_take2_2005_2005.nc','lat','lon','ht','time','one','htdiff','error')

%ht_t=[ht_t;ht];
%one_t=[one_t;one];
%htdiff_t=[htdiff_t;htdiff];
%error_t=[error_t;error];

%time_t=[time_t ,time'];

ncload('htanom_filter_2006_2006.nc','lat','lon','ht','time','one','htdiff','error')
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

good_time=find(time < 30000);

htdiff=htdiff(:,:,good_time);
one=one(:,:,good_time);
ht=ht(:,:,good_time);
time=time(good_time);
error=error(:,:,good_time);
save 'htanom_fliter_2002_2006' time lon lat one ht htdiff error 



