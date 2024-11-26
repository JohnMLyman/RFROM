file_name_south='htanom_2004_2006_south'
file_name='htanom_2004_2006_south_all'

[hc_tpxs,hc_tpx_ones,times,hcs,hc_ones]=heat_curv_gen_mat_south(file_name_south);
[hc_tpx,hc_tpx_one,time,hc,hc_one]=heat_curv_gen_mat_south(file_name);
min_year=2004;
max_year=2007;

figure(1); clf; orient tall;wysiwyg



gray=[.7 .7 .7];




subplot(2,1,1)


p1=plot(time,hc./1e21,'b')
hold on
p2=plot(time,hcs./1e21,'b--*')
p3=plot(time,hc_ones./1e21,'b--*')
p4=plot(time,hc_tpx./1e21)
p5=plot(time,hc_tpxs./1e21,'k--*')
p6=plot(time,hc_tpx_ones./1e21,'k--*')


set(p1,'color',gray,'linewidth',2);
set(p2,'linewidth',2);
set(p3,'linewidth',4);
set(p4,'color',gray,'linewidth',4);
set(p5,'linewidth',2);
set(p6,'linewidth',4);
hold off
ylabel('0-750m OHCA for SSH proxy [zeta-joules] ','fontsize',16);
set(gca,'XTick',[min_year:1:max_year],'tickdir','out','box','on')
xlabel('Time [years]','fontsize',16);


axis([min_year max_year -110 110])



eval(['print -dpng -f1 /home/shoko2/wills/globalhc_dirs/Globalhc/figs/trend_paper/revb_plot'])

