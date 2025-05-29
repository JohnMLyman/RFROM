function [rate_ceres,tgrid_ceres]=OHU_CERESl(TreeSetUp)
% TreeSetUp=TreeSetUp_2024_orca_heat_novert_test_mid;

end_year=TreeSetUp.end_year;
path_Fig_data=TreeSetUp.path_Fig_data;
tree_prefix=TreeSetUp.tree_prefix;
OUTOUT_type=TreeSetUp.OUTOUT_type;





file_txt=[path_Fig_data,'RFROMv22_OHU_',num2str(end_year.*10),'_junk.txt'];

files_ceres='C:\Users\jlyma\Downloads\ceres_ohca.mat'
load(files_ceres,'yr_ceres_ohca','ceres_ohca')
tgrid_all=yr_ceres_ohca';
tgrid=tgrid_all;
ht_curve_all=ceres_ohca*1e22;

 ht_tree_all=double(ht_curve_all);
 time_tree_all=double(tgrid_all);
good_fit=time_tree_all>=2010 & time_tree_all<=2021;

 center_year_all=mean(time_tree_all(good_fit));

 [model_tree_all,amp_annual,phase_annual,amp_semi,phase_semi,amp_third,phase_third,slope_tree_all,mean_tree_all,model_err]=...
    j_fit_annual_tree(time_tree_all(good_fit),ht_tree_all(good_fit)',time_tree_all);

ht_tree_all_res=ht_tree_all-model_tree_all';


ht_all_no_cycle=ht_tree_all_res'+(time_tree_all-center_year_all).*slope_tree_all';



% monthly then smoothed
area_of_earth=5.1e14;

ndays=365.25;
ndays_month=ndays/12.;

sec_in_day=(60.*60*24);
fac_year=1./(sec_in_day*area_of_earth.*ndays);
fac_month=1./(sec_in_day*area_of_earth.*ndays_month);

% fac_day=1./(sec_in_day*area_of_earth.*1);



tgrid_12mon=[(1993.5-1/24):1./12.:end_year-1/24];
ht_12mon=nans(1,length(tgrid_12mon));
ht_1mon=ht_12mon;
% ht_12mon_nofilt=nans(1,length(tgrid_12mon));


for iyear=tgrid_12mon

    good=tgrid>=iyear-.5 & tgrid<=iyear+.5;
    good_month=tgrid>=iyear-1/24 & tgrid<=iyear+1/24;
  
    

    ht_12mon(tgrid_12mon==iyear)=mean(ht_all_no_cycle(good),'omitnan');
    ht_1mon(tgrid_12mon==iyear)=mean(ht_all_no_cycle(good_month),'omitnan');
%     ht_12mon_nofilt(tgrid_12mon==iyear)=mean(ht_tree_all(good),'omitnan');
end


rate_12mon=-1.*(ht_12mon(1:end-12)-ht_12mon(13:end)).*fac_year;
rate_1mon=-1.*(ht_12mon(1:end-5)-ht_12mon(6:end)).*fac_month;
rate_12mon_s=-1.*(ht_1mon(1:end-12)-ht_1mon(13:end)).*fac_year;
% rate_12mon_nofilt=-1.*(ht_12mon_nofilt(1:end-12)-ht_12mon_nofilt(13:end)).*fac_year;

tgrid_rate_12mon=(tgrid_12mon(1:end-12)+tgrid_12mon(13:end))./2;
tgrid_rate_1mon=(tgrid_12mon(1:end-4)+tgrid_12mon(5:end))./2;


good_tree=tgrid_rate_12mon>=2005.5;
tgrid_rate=tgrid_rate_12mon(good_tree);
rate=rate_12mon(good_tree);



tgrid_ceres=tgrid_rate;
rate_ceres=rate;





% 
% write_ascii_CERES_RFROM_new(rate',tgrid_rate',file_txt)
