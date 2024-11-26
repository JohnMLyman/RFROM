
% global integrals of heat content and storage

min_year=1993;
max_year=2009;
%load in error bars

load '/Volumes/Data/Globalhc/SAL/Floats/nature_2010_ohca_curve'

hc_se=ohca_se*10.;
hc_one=ohca_curve*10;




%%     
figure(3); clf;orient landscape; wysiwyg


p2=plot(time,hc_one,'k-*');
e=errorbar(time,hc_one,hc_se,'k');set(e,'linewidth',3);

hold on


%plot(time_argo,hc_one_argo,'-*');
%plot(time_no_argo,hc_one_no_argo,'r-*');
ylabel('0-700 m Heat Content Anomaly [zeta-joules]','fontsize',16);
%set(p2,'linewidth',3)
set(e,'linewidth',3)
%set(pt,'linewidth',3)
set(gca,'XTick',[min_year:2:max_year],'tickdir','out', 'XMinorTick','on')


xlabel('Time [years]','fontsize',16);

title('0-700m Heat Content Anomaly','fontsize',18);
axis([min_year max_year -80 100])
set(gca,'fontsize',16,'FontName','Arial')


plot([min_year-1 max_year+1],[0 0],'k')





eval(['print -dpng -f3 /Users/johnlyman/figs/issi/fig1'])
%eval(['print -depsc2 -r600 -f3 /Users/johnlyman/figs/oco/Oceans/hc_one_greg_oco_2010'])
%%


%compute the slope of the line

