% this code computes multi-depth ranges
cd('/Volumes/Data/Globalhc/SAL/Floats')
%%
file_name='hdata_new__ishii_EN3_pfloat_sal_greg_jan_20121950_2011_100_real';


[hc_one_100,hc_whole_100,hc_vol_100,vol_ocean,time_100]=heat_curv_gen_mat_input_gpra(file_name, 0, 100);

%%

file_name='hdata_new__ishii_EN3_pfloat_sal_greg_jan_20121950_2011_100_300_real';


[hc_one_100_300,hc_whole_100_300,hc_vol_100_300,vol_ocean,time_100_300]=heat_curv_gen_mat_input_gpra(file_name, 100, 300);


%%


file_name='hdata_new__ishii_EN3_pfloat_sal_greg_jan_20121950_2011_300_700_real';


[hc_one_300_700,hc_whole_300_700,hc_vol_300_700,vol_ocean,time_300_700]=heat_curv_gen_mat_input_gpra(file_name, 300, 700);

%%
file_name='hdata_new__ishii_EN3_pfloat_sal_greg_jan_20121950_2011_900_real';


[hc_one_700_900,hc_whole_700_900,hc_vol_700_900,vol_ocean,time_700_900]=heat_curv_gen_mat_input_gpra(file_name, 700, 900);


%%
file_name='hdata_new__ishii_EN3_pfloat_sal_greg_jan_20121950_2011_1800_real';


[hc_one_900_1800,hc_whole_900_1800,hc_vol_900_1800,vol_ocean,time_900_1800]=heat_curv_gen_mat_input_gpra(file_name, 900, 1800);


%%
file_name='hdata_new_gpra_ishii_EN3_pfloat_sal_greg_jan_20121950_2008_bottom_real';
cd('/Volumes/Data/Globalhc/HC')


[hc_one_bottom,hc_whole_bottom,hc_vol_bottom,vol_ocean,time_bottom]=heat_curv_gen_mat_input_gpra(file_name, 1800, 180000);

cd('/Volumes/Data/Globalhc/SAL/Floats')

%%

save 'gpra_2012' hc_whole_100 hc_vol_100 hc_whole_100_300 hc_vol_100_300 hc_whole_300_700 hc_vol_300_700 hc_whole_700_900 ...
    hc_vol_700_900 hc_whole_900_1800 hc_vol_900_1800 time_100 time_100_300 time_300_700 time_700_900 time_900_1800 ...
    hc_whole_bottom hc_vol_bottom time_bottom vol_ocean
