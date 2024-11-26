function OHU_curve_and_ascii_file(TreeSetUp,min_depth,max_depth)
% TreeSetUp=TreeSetUp_2024_orca_heat_novert_test_mid;

end_year=TreeSetUp.end_year;
path_Fig_data=TreeSetUp.path_Fig_data;
tree_prefix=TreeSetUp.tree_prefix;
OUTOUT_type=TreeSetUp.OUTOUT_type;


depth_range_name=[num2str(min_depth),'_',num2str(max_depth)];

curve_name=['curve_',tree_prefix,'_',depth_range_name,'_ohca_nomean_',OUTOUT_type,'.mat'];
file_new=[path_Fig_data,curve_name];

file_txt=[path_Fig_data,'RFROMv21_OHU_',num2str(end_year.*10),'.txt'];


load(file_new,'tgrid','ht_curve')

tgrid_all=double(tgrid);
ht_curve_all=double(ht_curve);

 ht_tree_all=double(ht_curve_all);
 time_tree_all=double(tgrid_all);
good_fit=time_tree_all>=2010 & time_tree_all<=2022;

 center_year_all=mean(time_tree_all(good_fit));

 [model_tree_all,amp_annual,phase_annual,amp_semi,phase_semi,amp_third,phase_third,slope_tree_all,mean_tree_all,model_err]=...
    j_fit_annual_tree(time_tree_all(good_fit),ht_tree_all(good_fit)',time_tree_all);

ht_tree_all_res=ht_tree_all-model_tree_all';


ht_all_no_cycle=ht_tree_all_res'+(time_tree_all-center_year_all).*slope_tree_all';



% monthly then smoothed
area_of_earth=5.1e14;

ndays=365.25;

sec_in_day=(60.*60*24);
fac_year=1./(sec_in_day*area_of_earth.*ndays);
% fac_day=1./(sec_in_day*area_of_earth.*1);



tgrid_12mon=[(1993.5-1/24):1./12.:end_year-1/24];
ht_12mon=nans(1,length(tgrid_12mon));

for iyear=tgrid_12mon

    good=tgrid>=iyear-.5 & tgrid<=iyear+.5;
  
    

    ht_12mon(tgrid_12mon==iyear)=mean(ht_all_no_cycle(good),'omitnan');
end


rate_12mon=-1.*(ht_12mon(1:end-12)-ht_12mon(13:end)).*fac_year;

tgrid_rate_12mon=(tgrid_12mon(1:end-12)+tgrid_12mon(13:end))./2;


good_tree=tgrid_rate_12mon>=2005.5;
tgrid_rate=tgrid_rate_12mon(good_tree);
rate=rate_12mon(good_tree);








write_ascii_CERES_RFROM_new(rate',tgrid_rate',file_txt)
