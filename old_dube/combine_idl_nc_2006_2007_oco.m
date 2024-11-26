% This code cobines the nc files into one file

% load first file



ncload('htanom_greg_josh_test_2_2006_2007.nc','lon','lat','ht','htdiff','time','one','tpx','error')
 
ht=permute(ht,[3 2 1]);
htdiff=permute(htdiff,[3 2 1]);

one=permute(one,[3 2 1]);

tpx=permute(tpx,[3 2 1]);
error=permute(error,[3 2 1]);


%ht(isnan(ht))=0;
%one(isnan(one))=0;
%tps(isnan(tpx))=0;

save 'htanom_2006_2007_oco_greg_josh' time lon lat one ht tpx error htdiff



