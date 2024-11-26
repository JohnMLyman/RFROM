path_figs='C:\data\OHCA\figs\tree_paper\';
path_OHCA_data_out='C:\data\OHCA\'
name_comp='tree_gilson_LJ';

path_tree=[path_OHCA_data_out,'OHCA_trees\'];


load([path_tree,'test_tree_curve_yearly_7day_2000_yearly_new_cycle_combined_2_fixed.mat'], 'tgrid', 'ht_curve');

load([path_figs,'tree_gilson_ceres_rate.mat'],'rate_mon_all','rate_qu_all','rate_year_all_no_cycle',...
    'time_rate_tree_all_year',"time_rate_tree_all_mon","time_rate_tree_all_qu")

load([path_figs,name_comp,'_ohca_curves.mat'],'time_tree_all','ht_all_no_cyce')

write_netcfd_cf_OHCA_OHU_curves(time_aviso,ohca,ohca_cycle,...
    ohu_cycle,ohu_cycle_qu,ohu_annual,file_name_nc)