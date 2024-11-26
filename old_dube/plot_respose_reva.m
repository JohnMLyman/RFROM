

file_name='htanom_1993_2006_reva_no_trend';
[hc_tpx,hc_tpx_one,time,hc_tpx_no,hc_tpx_no_one]=heat_curv_gen_mat_reva(file_name);

min_year=1993;
max_year=2007;

figure(1); clf; orient tall;wysiwyg






subplot(2,1,1)


p1=plot(time,hc_tpx./1e21,'k--*')
hold on
p2=plot(time,hc_tpx_no./1e21,'k-*')

p3=plot(time,hc_tpx_one./1e21,'k--*')
p4=plot(time,hc_tpx_no_one./1e21,'k-*')

set(p1,'linewidth',2);
set(p2,'linewidth',2);
set(p3,'linewidth',4);
set(p4,'linewidth',4);;
hold off
ylabel('0-750m OHCA for SSH proxy [zeta-joules] ','fontsize',16);
set(gca,'XTick',[min_year:1:max_year],'tickdir','out','box','on')
xlabel('Time [years]','fontsize',16);


axis([min_year max_year -110 110])



eval(['print -dpng -f1 /home/shoko2/wills/globalhc_dirs/Globalhc/figs/trend_paper/reva_plot'])

