%load and compute heat content curvs

current_dir=cd('/Volumes/Data/Globalhc/HC')

[hc_100,time,hc_one_100]=heat_curv_gen_mat('hdata_new_pfloat_sal_greg_jan_2011_new_100_real.mat');
'100'

[hc_300,time,hc_one_300]=heat_curv_gen_mat('hdata_new_pfloat_sal_greg_jan_2011_new_300_real.mat');
'300'

[hc_700,time,hc_one_700]=heat_curv_gen_mat('hdata_new_pfloat_sal_greg_jan_2011_new_700_real.mat');
'700'

[hc_900,time,hc_one_900]=heat_curv_gen_mat('hdata_new_pfloat_sal_greg_jan_2011_new_900_real.mat');
'900'

[hc_1800,time,hc_one_1800]=heat_curv_gen_mat('hdata_new_pfloat_sal_greg_jan_2011_new_1800_real.mat');

cd(current_dir)



