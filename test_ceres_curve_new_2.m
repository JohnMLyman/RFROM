
ohca=ncread('OHCA_0_2000 (4).nc','ocean_heat_content_anomaly');
time=ncread('OHCA_0_2000 (4).nc','time');
dt=datevec(datenum(1950,1,1)+double(time));
tgrid_old=decyear(dt(:,1),dt(:,2),dt(:,3))';
ht_curve_old=double(ohca).*1e21;
[rate_old,tgrid_rate_old]=find_rate_tree(ht_curve_old,tgrid_old);
% 
% tgrid=decyear(dt(:,1),dt(:,2),dt(:,3))';
% ht_curve=double(ohca).*1e21;
% trgid=tgrid(isfinite(ht_curve));
% ht_curve=ht_curve(isfinite(ht_curve));
load('curve_tree_heat_vert_test_0_2000_ohca_nomean_OCO_2023_new.mat')
[rate_vert,tgrid_rate_vert]=find_rate_tree(ht_curve,tgrid);


load('curve_tree_heat_novert_test_0_2000_ohca_nomean_OCO_2023_novert.mat')

% load('curve_tree_heat_vert_0_2000_ohca_mask2.mat')
% load('C:\Users\jlyma\OneDrive\data\OHCA\OHCA_curves\test_tree_curve_yearly_7day_2000_yearly_combined.mat')
% ht_curve=ht_curve(2:end);
% tgrid=tgrid(2:end);
load('ceres_monthly.mat','c_year','c_m','c1','c2')
load('nino34.mat','year_nino34','month_nino34','nino34')
tgrid_all=double(tgrid);
ht_curve_all=double(ht_curve);

 ht_tree_all=double(ht_curve_all);
 time_tree_all=double(tgrid_all);
good_fit=time_tree_all>=2010 & time_tree_all<=2022;

 center_year_all=mean(time_tree_all(good_fit));

 [model_tree_all,amp_annual,phase_annual,amp_semi,phase_semi,amp_third,phase_third,slope_tree_all,mean_tree_all,model_err]=...
    j_fit_annual_tree(time_tree_all(good_fit),ht_tree_all(good_fit)',time_tree_all);

ht_tree_all_res=ht_tree_all-model_tree_all';
ht_tree_all_res_mon=smooth(ht_tree_all_res,8,'loess');
ht_tree_all_res_qu=smooth(ht_tree_all_res,26,'loess');
ht_tree_all_res_semi=smooth(ht_tree_all_res,52,'loess');
ht_tree_all_res_year=smooth(ht_tree_all_res,104,'loess');

ht_all_no_cycle=ht_tree_all_res'+(time_tree_all-center_year_all).*slope_tree_all';

ht_year_all_no_cycle=ht_tree_all_res_year'+(time_tree_all-center_year_all).*slope_tree_all';


% monthly then smoothed
area_of_earth=5.1e14;

ndays=365.25;

sec_in_day=(60.*60*24);
fac_year=1./(sec_in_day*area_of_earth.*ndays);
fac_day=1./(sec_in_day*area_of_earth.*1);
yr=floor(tgrid);
time=datenum(yr,1,1)+daysinyear(yr).*(tgrid-yr);
dt=datevec(time);

nmon=length(unique(dt(:,1)*100+dt(:,2)));
ht_mon=nan(1,nmon);
time_mon=nan(1,nmon);
tgrid_mon=time_mon;
itime=0;
for iyear=1993:2023
       for imonth=1:12
           good=dt(:,1)==iyear &dt(:,2)==imonth;
           if any(good)
               itime=itime+1;

                ht_mon(itime)=mean(ht_all_no_cycle(good),'omitmissing');
                time_mon(itime)=mean(time(good));
                tgrid_mon(itime)=mean(tgrid(good));
  

           end
       end
end

difftime=-1.*(time_mon(1:end-2)-time_mon(3:end));
fac_mon=1./(sec_in_day*area_of_earth.*difftime);
rate_mon=-1.*(ht_mon(1:end-2)-ht_mon(3:end)).*(fac_mon);
time_rate_mon=(tgrid_mon(1:end-2)+tgrid_mon(3:end))./2;

% yearly


tgrid_12mon=[1993.5:.5:2023.5];
tgrid_12mon=[(1993.5-1/24):1./12.:2023.5-1/24];
ht_12mon=nans(1,length(tgrid_12mon));
ceres_est=nans(1,length(tgrid_12mon));
tgrid_ceres_all=c_year+(c_m-.5)./12;
for iyear=tgrid_12mon

    good=tgrid>=iyear-.5 & tgrid<=iyear+.5;
    good_ceres=tgrid_ceres_all>=(iyear-.5) & tgrid_ceres_all<(iyear+.5);
    
    

    ht_12mon(tgrid_12mon==iyear)=mean(ht_all_no_cycle(good),'omitmissing');
     ceres_est(tgrid_12mon==iyear)=mean(c1(good_ceres),'omitmissing')./mean(c2(good_ceres),'omitmissing');
end


rate_12mon=-1.*(ht_12mon(1:end-12)-ht_12mon(13:end)).*fac_year;

tgrid_rate_12mon=(tgrid_12mon(1:end-12)+tgrid_12mon(13:end))./2;

decyear_nino34=year_nino34+(month_nino34-.5)./12;

good_nino=decyear_nino34>=2005.5&decyear_nino34<=max(tgrid_rate_12mon);
good_ceres=tgrid_12mon>=2005.5&tgrid_12mon<=max(tgrid_rate_12mon);

tgrid_ceres=tgrid_12mon(good_ceres);
ceres_mon=ceres_est(good_ceres);


tgrid_nino=decyear_nino34(good_nino);
nino=nino34(good_nino);

good_tree=tgrid_rate_12mon>=2005.5;
tgrid_rate=tgrid_rate_12mon(good_tree);
rate=rate_12mon(good_tree);








mceres=mean(ceres_mon);

mtree=mean(rate);

figure
good=abs(nino)<.5;


hold on
ceres_out=ceres_mon-mceres+mtree;
plot(tgrid_ceres,ceres_out,'r')
% plot(tgrid_ceres(good),ceres_mon(good)-mceres+mtree,'r')
% 
hold on
plot(tgrid_rate,rate,'k')
plot(tgrid_rate_old,rate_old,'b')
plot(tgrid_rate_vert,rate_vert,'g')
% hold on
% plot(tgrid_nino,nino,'k')

[a,b]=crosscorr(rate,ceres_mon);
rate_no_enso=rate;
ceres_no_enso=ceres_mon;
rate_no_enso(~good)=nan;
ceres_no_enso(~good)=nan;
rate_no_enso=rate_no_enso(1:195);
ceres_no_enso=ceres_no_enso(1:195);

write_ascii_CERES_RFROM(rate',ceres_out',tgrid_rate','RFROMv21_CERES.txt')
rne=fillmissing(rate_no_enso,'linear');
cne=fillmissing(ceres_no_enso,'linear');

[ano,bno]=crosscorr(rate_no_enso,ceres_no_enso);
[ano,bno]=crosscorr(rne,cne);

