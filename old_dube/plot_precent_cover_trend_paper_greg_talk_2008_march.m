% Righc now the code is set up to fit a line with an off set
function plot_precent_cover_trend_paper_greg_talk_2008_march

load greg_josh_march_2008
time_good=find(time_per > 1998);
time_per=time_per(time_good);
per_cov=per_cov(time_good);
load ../SAL/Floats/hc_factor_trend2.mat
% this part I figured out by had as a quick calculation for a talk Greg gave in march 2008

time_good2=find(time <= 1998);
hc_one=[hc_one(time_good2) per_cov];
time=[time(time_good2) time_per];
figure(1); clf;orient landscape; wysiwyg
p=plot(time,100.*hc_one,'k.-')
set(p,'linewidth',3)
ylabel('Percent of global coverage','fontsize',16);
%title('Global coverage of 0-750 m Ocean Heat Content Anomaly','fontsize',18);
xlabel('Time [years]','fontsize',16)
set(gca,'fontsize',16, 'tickdir','out')
axis(gca,[1954 2008 0 100])
eval(['print -dpng -f1 /home/shoko2/wills/globalhc_dirs/Globalhc/figs/trend_paper/coverage_precent_greg_march'])
