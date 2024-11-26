cd /Volumes/Data/Globalhc/HC
min_year=1993;
max_year=2013;
%load in error bars

load '/Volumes/Data/Globalhc/SAL/Floats/nature_2010_ohca_curve'

hc_se=[ohca_se ohca_se(end) ohca_se(end) ohca_se(end) ohca_se(end) ohca_se(end)]*10;

%area of the earth used to compute w/m^2

area_of_earth=5.1e14;
sec_in_year=(60.*60*24*365.25);
fac=1./(sec_in_year.*area_of_earth);


time_error=[time, time(end)+1,time(end)+2,time(end)+3,time(end)+4,time(end)+5];


cd ../HC/

%[hc,time,hc_one]=heat_curv_gen_mat('htanom_oco_realtime_1993_2010.mat');
%[hc,time,hc_one]=heat_curv_gen_mat('hdata_oco_realtime_jan_2012_700_real2.mat');
% [hc,time,hc_one_100]=heat_curv_gen_mat_2012_new_un('hdata_new__ishii_EN3_2013_pfloat_sal_greg_jan_20131950_2012_100_real');
% [hc,time,hc_one_100_300]=heat_curv_gen_mat_2012_new_un('hdata_new__ishii_EN3_2013_pfloat_sal_greg_jan_20131950_2012_100_300_real');
%  [hc,time,hc_one_300_700]=heat_curv_gen_mat_2012_new_un('hdata_new__ishii_EN3_2013_pfloat_sal_greg_jan_20131950_2012_300_700_real');
%  [hc,time,hc_one_700_900]=heat_curv_gen_mat_2012_new_un('hdata_new__ishii_EN3_2013_pfloat_sal_greg_jan_20131950_2012_900_real');
%  [hc,time,hc_one_900_1800]=heat_curv_gen_mat_2012_new_un('hdata_new__ishii_EN3_2013_pfloat_sal_greg_jan_20131950_2012_1800_real');
 
% [hc,time,hc_one_100]=heat_curv_gen_mat_2012_new_un('hdata_new__ishii_EN3_2013_pfloat_sal_greg_jan_20131992_2012_100_real');
% [hc,time,hc_one_100_300]=heat_curv_gen_mat_2012_new_un('hdata_new__ishii_EN3_2013_pfloat_sal_greg_jan_20131992_2012_100_300_real');
%  [hc,time,hc_one_300_700]=heat_curv_gen_mat_2012_new_un('hdata_new__ishii_EN3_2013_pfloat_sal_greg_jan_20131992_2012_300_700_real');



 [hc,time,hc_one_100]=heat_curv_gen_mat_2012_new_un_topo('hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_20141991_2013_100_real',0,100);
[hc,time,hc_one_100_300]=heat_curv_gen_mat_2012_new_un_topo('hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_20141991_2013_100_300_real',100,300);
 [hc,time,hc_one_300_700]=heat_curv_gen_mat_2012_new_un_topo('hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_20141991_2013_300_700_real',300,700);
  [hc,time,hc_one_700_900]=heat_curv_gen_mat_2012_new_un_topo('hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_20141991_2013_900_real',700,900);
   [hc,time,hc_one_900_1800]=heat_curv_gen_mat_2012_new_un_topo('hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_20141991_2013_1800_real',900,1800);
   
 
 hc_one_700=hc_one_100+hc_one_100_300+hc_one_300_700;
 hc_one_1800=hc_one_700+hc_one_700_900+hc_one_900_1800;
 
 
 
rate_700_oco=diff(hc_one_700).*fac;


good_error=find(time_error > 1999);
hc_se=hc_se(good_error);
se_rate_700_oco=sqrt(hc_se(1:end-1).^2+hc_se(2:end).^2).*1e21*fac;

time_700_oco=.5.*(time(1:end-1)+time(2:end));
good_700=find(time_700_oco>=2000)

time_700_oco=time_700_oco(good_700);
rate_700_oco=rate_700_oco(good_700);

rate_1800_oco=diff(hc_one_1800).*fac;
time_1800_oco=.5.*(time(1:end-1)+time(2:end));
good_1800=find(time_1800_oco >=2005);
rate_1800_oco=rate_1800_oco(good_1800);
time_1800_oco=time_1800_oco(good_1800);
%% write the ascii files

d=[time_1800_oco';rate_1800_oco]';
fid = fopen('rate_1800_oco_2013.txt', 'w');
fprintf(fid, 'Time(Years) Rate(Wm^-2) \n\n');
fprintf(fid, '%10.0f  %8.3f \n', d');
fclose(fid);
%%
d=[time_700_oco';rate_700_oco;se_rate_700_oco]';
fid = fopen('rate_700_oco_2013.txt', 'w');
fprintf(fid, 'Time(Years) Rate(Wm^-2) SE(Wm^-2)\n\n');
fprintf(fid, '%10.0f  %8.3f %8.3f \n', d');
fclose(fid);


save 'rate_norm_2014_oco' rate_1800_oco time_1800_oco time_700_oco se_rate_700_oco rate_700_oco
