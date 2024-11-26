% Righc now the code is set up to fit a line with an off set
function plot_precent_cover_trend_paper


load ../SAL/Floats/hc_factor_trend2.mat
figure(1); clf;orient landscape; wysiwyg
p=plot(time,100.*hc_one,'k.-')
set(p,'linewidth',3)
ylabel('Percent of global coverage','fontsize',16);
%title('Global coverage of 0-750 m Ocean Heat Content Anomaly','fontsize',18);
xlabel('Time [years]','fontsize',16)
set(gca,'fontsize',16, 'tickdir','out')
axis(gca,[1954 2007 0 100])
eval(['print -dtiff -f1 /home/shoko2/wills/globalhc_dirs/Globalhc/figs/trend_paper/coverage_precent_trend2'])
