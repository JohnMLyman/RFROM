% This code cobines the nc files into one file

% load first file

cd /Users/johnlyman/data/Globalhc/SAL/Floats


ncload('htanom_2004_2007_clim_2_year_2006_2008.nc','lon','lat','ht','htdiff','time','one','tpx','error')
 
ht=permute(ht,[3 2 1]);
htdiff=permute(htdiff,[3 2 1]);

one=permute(one,[3 2 1]);

tpx=permute(tpx,[3 2 1]);
error=permute(error,[3 2 1]);


%ht(isnan(ht))=0;
%one(isnan(one))=0;
%tps(isnan(tpx))=0;

save 'htanom_2006_2008_oco' time lon lat one ht tpx error htdiff



