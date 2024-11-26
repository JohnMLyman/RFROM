function multi_plot_hc_hc_one


[hc_all,time_all,hc_one_all]=heat_curv_gen_mat('htanom_no_te2_2002_2006.mat');
[hc_no_argo,time_no_argo,hc_one_no_argo]=heat_curv_gen_nc('htanom_no_te2_no_argo_2002_2006.nc');
[hc_argo,time_argo,hc_one_argo]=heat_curv_gen_nc('htanom_no_te2_argo_2002_2006.nc');

[hc_josh,time_josh,hc_one_josh]=heat_curv_gen_nc('htanom_josh_march_2002_2006.nc');
[hc_josh_argo,time_josh_argo,hc_one_josh_argo]=heat_curv_gen_nc('htanom_josh_argo_2002_2006.nc');
[hc_josh_no_argo,time_josh_no_argo,hc_one_josh_no_argo]=heat_curv_gen_nc('htanom_josh_no_argo_2002_2006.nc');


figure (1)
hold on
plot(time_all,hc_all,'k')
 plot(time_no_argo,hc_no_argo,'r')
plot(time_argo,hc_argo)

plot(time_josh,hc_josh,'k.-')
plot(time_josh_argo,hc_josh_argo,'.-')
 plot(time_josh_no_argo,hc_josh_no_argo,'r.-')
hold off


figure(2)
hold on
plot(time_all,hc_one_all,'k')
 plot(time_no_argo,hc_one_no_argo,'r')
plot(time_argo,hc_one_argo)

plot(time_josh,hc_one_josh,'k.-')
plot(time_josh_argo,hc_one_josh_argo,'.-')
 plot(time_josh_no_argo,hc_one_josh_no_argo,'r.-')
hold off





eval(['print -dpng -f1 /home/shoko/C/','''IDL ps''','/heat/oco/2006/hc_curve_argo'])
eval(['print -dpng -f2 /home/shoko/C/','''IDL ps''','/heat/oco/2006/hc_curve_argo_one'])
