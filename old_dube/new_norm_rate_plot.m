% %compute the slope of the line
area_of_earth=5.1e14;
sec_in_halfyear=(60.*60*24*365.25)./2.;
fac=1./(sec_in_halfyear.*area_of_earth);
se_rate_2000_oco=sqrt(hc_se_total(1:end-1).^2+hc_se_total(2:end).^2).*1e21*fac;

rate_2000_oco=diff(hc_one_total).*fac .*1e21;
time_2000_oco=.5.*(time_deep(1:end-1)+time_deep(2:end));
rate_2000=rate_2000_oco;
se_rate_2000=se_rate_2000_oco;
time_rate_2000=time_2000_oco;
OHCA_2000=hc_se_total;
se_OHCA_2000=hc_se_total;
OHCA_2000=hc_one_total;
time_OHCA=time_deep;


% % % per_100=100*hc_100./hc_one_100;
% % per_100_300=100*hc_100_300./hc_one_100_300;
% % per_300_700=100*hc_300_700./hc_one_300_700;
% % per_700_900=100*hc_700_900./hc_one_700_900;
% % per_900_1800=100*hc_900_1800./hc_one_900_1800;
% % 
% % good_per=find(time_one>min_year_deep & time_one < max_year_deep);
% % 
% % per_100=per_100(good_per);
% % per_100_300=per_100_300(good_per);
% % per_300_700=per_300_700(good_per);
% % per_700_900=per_700_900(good_per);
% % per_900_1800=per_900_1800(good_per);
% % 
% % % note that mid depths (where topogarphy is between depth layers has been
% % % taken car of in the definition of Area.
% % 
% % vol_100=Area_100(good_per)*100;
% % vol_100_300=Area_100_300(good_per)*(300-100);
% % vol_300_700=Area_300_700(good_per)*(700-300);
% % vol_700_900=Area_700_900(good_per)*(900-700);
% % vol_900_1800=Area_900_1800(good_per)*(1800-900);
% % 
% % time_per=time_one(good_per);
% % 
% % per_0_1800=(per_100.*vol_100+per_100_300.*vol_100_300+per_300_700.*vol_300_700+...
% %     per_700_900.*vol_700_900+per_900_1800.*vol_900_1800)./ ...
% %     (vol_100+vol_100_300+vol_300_700+vol_700_900+vol_900_1800);
% % 
load greg_rate_OHCA_2000 rate_2000 se_rate_2000 time_rate_2000 OHCA_2000 ...
    time_OHCA
% % figure(100)
% % plot(time_per,per_100)
% % hold on
% % plot(time_per,per_100_300)
% % plot(time_per,per_300_700)
% % plot(time_per,per_700_900)
% % plot(time_per,per_900_1800)
% % 
% % axis([2000 2016 0 100])
% % 
figure
errorbar(time_rate_2000,rate_2000,se_rate_2000,'k')


load greg_rate_OHCA_1800_new rate_1800 se_rate_1800 time_rate OHCA_1800 ...
    se_OHCA_1800 time_OHCA per_100 per_100_300 per_300_700 per_700_900 ...
    per_900_1800 time_per

hold on 
errorbar(time_rate,rate_1800,se_rate_1800)



