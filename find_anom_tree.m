function [ht_tree_all_res]=find_anom_tree(ht_curve,tgrid)


tgrid_all=double(tgrid);
ht_curve_all=double(ht_curve);

 ht_tree_all=double(ht_curve_all);
 time_tree_all=double(tgrid_all);
good_fit=time_tree_all>=2010 & time_tree_all<=2022;

 center_year_all=mean(time_tree_all(good_fit));

 [model_tree_all,amp_annual,phase_annual,amp_semi,phase_semi,amp_third,phase_third,slope_tree_all,mean_tree_all,model_err]=...
    j_fit_annual_tree(time_tree_all(good_fit),ht_tree_all(good_fit)',time_tree_all);

ht_tree_all_res=ht_tree_all-model_tree_all';










end