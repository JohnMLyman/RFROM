% Righc now the code is set up to fit a line with an off set
function plot_precent_cover_greg_argo_meetting

load /Users/johnlyman/data/Globalhc/SAL/Floats/per_1955_2008.mat
figure(1); clf;orient landscape; wysiwyg
time=time_per;

%get rid of 2008.5 because not enough data yet
time(end)=[];
per(end)=[];
hc_one=per;
p=plot(time,100.*hc_one,'k.-')
set(p,'linewidth',3)
ylabel('Percent of global coverage','fontsize',16);
%title('Global coverage of 0-750 m Ocean Heat Content Anomaly','fontsize',18);
xlabel('Time [years]','fontsize',16)
set(gca,'fontsize',16, 'tickdir','out')
axis(gca,[1954 2009 0 100])
eval(['print -dpng -f1 /Users/johnlyman/figs/greg/coverage_precent_argo'])
