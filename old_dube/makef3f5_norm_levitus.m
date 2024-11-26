cd /Volumes/Data/Globalhc/HC

area_of_earth=5.1e14;
sec_in_year=(60.*60*24*365.25);
fac=1./(sec_in_year.*area_of_earth);

cd /Volumes/Data/Globalhc/HC
min_year=1993;
max_year=2011;
%load in error bars

load '/Volumes/Data/Globalhc/SAL/Floats/nature_2010_ohca_curve'

hc_se=[ohca_se ohca_se(end) ohca_se(end)]*10;

%area of the earth used to compute w/m^2
area_of_earth=5.1e14


time_error=time;


cd ../SAL/Floats

%%[hc,time,hc_one]=heat_curv_gen_mat('htanom_oco_realtime_1993_2010.mat');
%[hc,time,hc_one]=heat_curv_gen_mat('hdata_oco_realtime_jan_2011_700_real.mat');

%save '/Volumes/Data/Globalhc/SAL/Floats/nature_2010_ohca_curve_oco_greg' time hc_one hc_se
load '/Volumes/Data/Globalhc/SAL/Floats/nature_2010_ohca_curve_oco_greg' time hc_one hc_se
time_se=time;
%subsect all and put into Zeta joules

good_pos=find(time >= min_year & time <=max_year);


time=time(good_pos);
hc_one=hc_one(good_pos)/1e21;
%%
load /Volumes/Data/Globalhc/SAL/Floats/simon_hc_2010
good_simon=find(simon_time> 1993);
simon_time=simon_time(good_simon);
simon_se=simon_se(good_simon);
simon_hc=simon_hc(good_simon);

load /Volumes/Data/Globalhc/SAL/Floats/tim_hc_2010
good_tim=find(tim_time> 1993);
tim_time=tim_time(good_tim);
tim_se=tim_se(good_tim);
tim_hc=tim_hc(good_tim);

pos_tim_argo=find(tim_time> 2004);
tim_hc=tim_hc-nanmean(tim_hc(pos_tim_argo));

pos_simon_argo=find(simon_time> 2004);
simon_hc=simon_hc-nanmean(simon_hc(pos_simon_argo));

pos_argo=find(time> 2004);
hc_one=hc_one-nanmean(hc_one(pos_tim_argo));


% load in old levitus curves


load /Volumes/Data/Globalhc/SAL/Floats/lev_ohca_2009_2.mat error_lev hc_lev time_lev
good_lev_bams_2010=find(time_lev> 1993);

lev_hc_bams_2010=hc_lev(good_lev_bams_2010)/1e21;
lev_time_bams_2010=time_lev(good_lev_bams_2010);
lev_se_bams_2010=error_lev(good_lev_bams_2010)/1e21;


load /Volumes/Data/OHCA_curves/lev_curve.mat lev_ohca lev_se lev_time
good_lev_2009=find(lev_time> 1993);

lev_hc_2009=lev_ohca(good_lev_2009)*10;
lev_time_2009=lev_time(good_lev_2009);
lev_se_2009=lev_se(good_lev_2009)*10;

% load bams 2009 lyman and simon

load /Volumes/Data/Globalhc/SAL/Floats/simon_ohca_1993_2002_2005.mat error_1993_2002_simon hc_1993_2002_simon time_1993_2002_simon

simon_time_bams_2010=time_1993_2002_simon+.5;

good_simon_2010=find(simon_time_bams_2010> 1993);

simon_hc_bams_2010=hc_1993_2002_simon(good_simon_2010)/1e21;
simon_time_bams_2010=simon_time_bams_2010(good_simon_2010);
simon_se_bams_2010=error_1993_2002_simon(good_simon_2010)/1e21;


path_bams_2010='/Volumes/Data/Globalhc/SAL/Floats/';
[hc_oco_700_junk,time_oco_700_bams_2010,hc_bams_2010]=heat_curv_gen_mat([path_bams_2010,'htanom_1993_2002_realtime_oco_jan27_1993_2009']);

good_bams_2010=find(time_oco_700_bams_2010>1993);
hc_bams_2010=hc_bams_2010(good_bams_2010)/1e21;
time_bams_2010=time_oco_700_bams_2010(good_bams_2010);


%% compute rate of ocean heat change
figure(3); clf;orient landscape; wysiwyg

rate_lev_bams_2010=diff(lev_hc_bams_2010).*1e21.*fac;
time_rate_lev_bams_2010=.5.*(lev_time_bams_2010(1:end-1)+lev_time_bams_2010(2:end));

rate_lev_2009=diff(lev_hc_2009).*1e21.*fac;
time_rate_lev_2009=.5.*(lev_time_2009(1:end-1)+lev_time_2009(2:end));

rate_simon_bams_2010=diff(simon_hc_bams_2010).*1e21.*fac;
time_rate_simon_bams_2010=.5.*(simon_time_bams_2010(1:end-1)+simon_time_bams_2010(2:end));

rate_bams_2010=diff(hc_bams_2010).*1e21.*fac;
time_rate_bams_2010=.5.*(time_bams_2010(1:end-1)+time_bams_2010(2:end));

rate_tim=diff(tim_hc).*1e21.*fac;
se_rate_tim=sqrt(tim_se(1:end-1).^2+tim_se(2:end).^2).*1e21*fac;
time_rate_tim=.5.*(tim_time(1:end-1)+tim_time(2:end));

rate_simon=diff(simon_hc).*1e21.*fac;
se_rate_simon=sqrt(simon_se(1:end-1).^2+simon_se(2:end).^2).*1e21*fac;
time_rate_simon=.5.*(simon_time(1:end-1)+simon_time(2:end));

%% compute se from nature paper

se_rate=sqrt(hc_se(1:end-1).^2+hc_se(2:end).^2).*1e21*fac;
time_rate_se=.5.*(time_se(1:end-1)+time_se(2:end));

se_rate_lev_bams_2010=se_rate(ismember(time_rate_se,time_rate_lev_bams_2010));

se_rate_lev_2009=se_rate(ismember(time_rate_se,time_rate_lev_2009));

se_rate_simon_bams_2010=se_rate(ismember(time_rate_se,time_rate_simon_bams_2010));


se_rate_tim=se_rate(ismember(time_rate_se,time_rate_tim));


se_rate_simon=se_rate(ismember(time_rate_se,time_rate_simon));

se_rate_bams_2010=se_rate(ismember(time_rate_se,time_rate_bams_2010));
%%

span = 5; % Size of the averaging window
window = ones(span,1)/span; 
sm_tim_hc = convn(tim_hc,window,'same');
rate_sm_tim=diff(sm_tim_hc).*1e21.*fac;
%se_rate_sm_tim=sqrt(sm_tim_se(1:end-1).^2+sm_tim_se(2:end).^2).*1e21*fac;
time_rate_sm_tim=.5.*(tim_time(1:end-1)+tim_time(2:end));

rate_sm_tim(1:2)=NaN;
rate_sm_tim(end-1:end)=NaN;
%se_700=hc_se;
%p300=plot(time_300,hc_one_300,'-*','color',mycor(5,:));



%p=plot(time,hc,'-*','color','k');


%et=errorbar(time_300,hc_one_300,se_300,'color',mycor(5,:));set(et,'linewidth',3);
et=errorbar(time_rate_tim,rate_tim,se_rate_tim,'k');set(et,'linewidth',3);
hold on
es=errorbar(time_rate_simon,rate_simon,se_rate_simon,'g');set(es,'linewidth',3);

es=errorbar(time_rate_simon_bams_2010,rate_simon_bams_2010,se_rate_simon_bams_2010,'r');set(es,'linewidth',3);

es=errorbar(time_rate_lev_bams_2010,rate_lev_bams_2010,se_rate_lev_bams_2010,'y');set(es,'linewidth',3);
es=errorbar(time_rate_lev_2009,rate_lev_2009,se_rate_lev_2009,'m');set(es,'linewidth',3);

es=errorbar(time_rate_bams_2010,rate_bams_2010,se_rate_bams_2010);set(es,'linewidth',3);





%save levitus_tim_norm_mat_rate rate_tim se_rate_tim time_rate_tim
% et=errorbar(time_900(range),hc_one_900(range),se_900(range),'color',mycor(3,:));set(et,'linewidth',3);
% et=errorbar(time_1800(range),hc_one_1800(range),se_1800(range),'color',mycor(1,:));set(et,'linewidth',3);


ylabel('Ocean Heat Content Change [Wm^{-2}]','fontsize',16);


%set(p,'linewidth',3)

set(gca,'XTick',[1993:2:2011],'tickdir','out', 'XMinorTick','on')


xlabel('Time [years]','fontsize',16);

title('Ocean Heat Content Change 0-700 m NODC','fontsize',18);
axis([1993 2011 -3 3])
set(gca,'fontsize',16)


 
plot([1993 2011],[0 0],'k')



eval(['print -dpng -f3 /Users/johnlyman/figs/oco/Oceans/hc_change_700_lev_plus'])
%%






