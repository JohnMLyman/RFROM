% Righc now the code is set up to fit a line with an off set
function plot_precent_cover_greg_greg_wcrp_poster

load /Users/johnlyman/data/Globalhc/SAL/Floats/per_1955_2010.mat
figure(1); clf;orient landscape; wysiwyg
time=time_per;

%get rid of 2008.5 because not enough data yet
% time(end)=[];
% per(end)=[];
hc_one=per;
p=plot(time,100.*hc_one,'k.-')
set(p,'linewidth',3)
ylabel('Percent of global coverage','fontsize',24);
%title('Global coverage of 0-750 m Ocean Heat Content Anomaly','fontsize',18);
xlabel('Time [years]','fontsize',24)
set(gca,'fontsize',24, 'tickdir','out')
axis(gca,[1954 2011 0 100])
eval(['print -dpdf -f1 /Users/johnlyman/figs/greg/coverage_1955_2010'])
