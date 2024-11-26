function plot_precent_cover_trend_paper


load ../SAL/Floats/hc_factor.mat
figure(1); clf;orient landscape; wysiwyg
p=plot(time,100.*hc_one,'k.-')
set(p,'linewidth',3)
ylabel('Amount of the globe covered [%]','fontsize',16);
title('Global coverage of 0-750 m Ocean Heat Content Anomaly','fontsize',18);
xlabel('Time [years]','fontsize',16)
set(gca,'fontsize',16, 'tickdir','out')
axis(gca,[1954 2007 0 100])
eval(['print -dpng -f1 /home/shoko2/wills/globalhc_dirs/Globalhc/figs/trend_paper/coverage_precent'])
