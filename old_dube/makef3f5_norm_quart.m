cd /Volumes/Data/Globalhc/HC

area_of_earth=5.1e14;
sec_in_year=(60.*60*24*365.25);
fac=1./(sec_in_year.*area_of_earth);

load /Volumes/Data/Globalhc/HC/enso

load error_300_700_900_1800 se_1800 se_900 se_700 se_300 time

time_error=time;

load hc_300_700_900_1800 hc_one_1800 hc_1800 time_1800 hc_one_900 hc_900 time_900 hc_one_700 hc_700 time_700 hc_one_300 hc_300 time_300 ...
    hc_one hc time 

%%
path_bams_2010='/Volumes/Data/Globalhc/SAL/Floats/';
[hc_oco_700_junk,time_oco_700_bams_2010,hc_bams_2010]=heat_curv_gen_mat([path_bams_2010,'htanom_1993_2002_realtime_oco_jan27_1993_2009']);

good_bams_2010=find(time_oco_700_bams_2010>1993);
hc_bams_2010=hc_bams_2010(good_bams_2010)/1e21;
time_bams_2010=time_oco_700_bams_2010(good_bams_2010);

%%
figure(3); clf;orient landscape; wysiwyg
load '/Volumes/Data/Globalhc/SAL/Floats/nature_2010_ohca_curve_oco_greg' time hc_one hc_se

hc_se_oco=hc_se(end-6:end);
time_oco=time(end-6:end);
hc_one_oco=hc_one(end-6:end);

range=[2:7];

% p300=plot(time_300,hc_one_300-mean(hc_one_300),'-*','color',mycor(5,:));
% hold on
% p700=plot(time_700,hc_one_700-mean(hc_one_700),'-*','color',mycor(4,:));
% p900=plot(time_900,hc_one_900-mean(hc_one_900),'-*','color',mycor(3,:));
% p1800=plot(time_1800,hc_one_1800-mean(hc_one_1800),'-*','color',mycor(1,:));


hc_one_700=hc_one_oco./1e21;


hc_t=hc_one_700+hc_one_900+hc_one_1800;

rate_t=diff(hc_t).*fac*1e21;
se_rate_t=se_700+se_900+se_1800;
se_rate_t=sqrt(se_rate_t(1:end-1).^2+se_rate_t(2:end).^2).*1e21.*fac;
time_rate_t=.5.*(time_700(1:end-1)+time_700(2:end));

rate_700=diff(hc_one).*fac;
se_rate_700=[hc_se(1:end-7) se_700];
se_rate_700=sqrt(se_rate_700(1:end-1).^2+se_rate_700(2:end).^2).*1e21*fac;
time_rate_700=.5.*(time(1:end-1)+time(2:end));

rate_700_sm=diff(hc_one_700).*1e21.*fac;
se_rate_700_sm=se_700;
se_rate_700_sm=sqrt(se_rate_700_sm(1:end-1).^2+se_rate_700_sm(2:end).^2).*1e21*fac;
time_rate_700_sm=.5.*(time_700(1:end-1)+time_700(2:end));



%se_700=hc_se;
%p300=plot(time_300,hc_one_300,'-*','color',mycor(5,:));



%p=plot(time,hc,'-*','color','k');


%et=errorbar(time_300,hc_one_300,se_300,'color',mycor(5,:));set(et,'linewidth',3);
et=errorbar(time_rate_700_sm(2:end),rate_700_sm(2:end),se_rate_700_sm(2:end),'k');set(et,'linewidth',3);
hold on 
et=errorbar(time_rate_t(2:end),rate_t(2:end),se_rate_t(2:end),'r');set(et,'linewidth',3);

hold on


%save norm_mat_file time_rate_700 rate_700 se_rate_700 rate_t se_rate_t time_rate_t
% et=errorbar(time_900(range),hc_one_900(range),se_900(range),'color',mycor(3,:));set(et,'linewidth',3);
% et=errorbar(time_1800(range),hc_one_1800(range),se_1800(range),'color',mycor(1,:));set(et,'linewidth',3);


ylabel('Ocean Heat Content Change [Wm^{-2}]','fontsize',16);


%set(p,'linewidth',3)

set(gca,'XTick',[2004:2011],'tickdir','out', 'XMinorTick','on')


xlabel('Time [years]','fontsize',16);

title('Ocean Heat Content Change','fontsize',18);
axis([2004 2011 -1 1])
set(gca,'fontsize',16)


 
plot([1993 2011],[0 0],'k')


%% enso fig
figure(4); clf;orient landscape; wysiwyg

p1=plot(time_rate_700,rate_700./std(rate_700),'k');set(p1,'linewidth',3);
hold on 
p2=plot(time_enso,multi_enso);set(p2,'linewidth',3);

%set(p,'linewidth',3)

set(gca,'XTick',[1994:2:2011],'tickdir','out', 'XMinorTick','on')


xlabel('Time [years]','fontsize',16);

title('Normalized Ocean Heat Content Change and Multivariate ENSO Index ','fontsize',18);
%axis([1993 2011 -1 1])
set(gca,'fontsize',16)

axis([1993 2011 -1.5 2])
 
plot([1993 2011],[0 0],'k')

eval(['print -dpng -f4 /Users/johnlyman/figs/oco/Oceans/hc_change_700_enso'])
%%
eval(['print -dpng -f3 /Users/johnlyman/figs/oco/Oceans/hc_change_300_700_900_1800'])






