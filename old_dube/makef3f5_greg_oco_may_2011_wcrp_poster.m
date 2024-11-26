% makef3f5.m - matlab script to make figures 3 and 5 for the globahc paper
mycor = [

         0.88          0.31             0
         0.60             0             0
         0.30          0.31          0.99
            0          0.60          0.20
         0.28          0.77          0.96
         0.99          0.81             0
         1.00          0.20          0.80
         0.49          0.10          0.34
         0.60          0.60          0.60
         .7             .9             .2
         0             0             0];

% global integrals of heat content and storage
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

%[hc,time,hc_one]=heat_curv_gen_mat('htanom_oco_realtime_1993_2010.mat');
[hc,time,hc_one]=heat_curv_gen_mat('hdata_oco_realtime_jan_2011_700_real.mat');

save '/Volumes/Data/Globalhc/SAL/Floats/nature_2010_ohca_curve_oco_greg' time hc_one hc_se
%subsect all and put into Zeta joules

good_pos=find(time >= min_year & time <=max_year);

hc=hc(good_pos)/1e21;
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

hc_all=[hc_one';tim_hc;simon_hc];
offset=nanmean(hc_all);


hc_one=hc_one-offset;
tim_hc=tim_hc-offset;
simon_hc=simon_hc-offset;




%%     
figure(3); clf;orient landscape; wysiwyg
xv=[[time;time(end:-1:1)]];
yv=[hc_one+hc_se,hc_one(end:-1:1)-hc_se(end:-1:1)];
verts=[xv,yv'];
faces=[1:36];

p3=patch('Faces',faces,'Vertices',verts,'FaceColor',[.8,.8,.8]);
hold on

p2=plot(time,hc_one,'color','k');

%e=errorbar(time,hc_one,hc_se,'color',[.6,.6,.6]);
set(p2,'linewidth',3);

%plot(time_argo,hc_one_argo,'-*');
%plot(time_no_argo,hc_one_no_argo,'r-*');
ylabel('0-700 m Heat Content Anomaly [zeta-joules]','fontsize',24);
%set(p2,'linewidth',3)

%set(pt,'linewidth',3)
set(gca,'XTick',[min_year:2:max_year],'tickdir','out', 'XMinorTick','on')


xlabel('Time [years]','fontsize',24);

title('0-700m Heat Content Anomaly','fontsize',24);
axis([min_year max_year -100 80])
set(gca,'fontsize',24)


%e1=errorbar(time_argo,hc_one_argo,error_argo);set(e1,'linewidth',2)
%e2=errorbar(time_no_argo,hc_one_no_argo,error_no_argo,'r');set(e2,'linewidth',2)
%e3=errorbar(time,hc_one,error_all,'k');set(e3,'linewidth',2)

%plot the x-axis

plot([min_year-.5 max_year+.5],[0 0],'k')





eval(['print -dpng -f3 /Users/johnlyman/figs/greg/hc_one_greg_oco_2010_poster'])
eval(['print -dpdf -f3 /Users/johnlyman/figs/greg/hc_one_greg_oco_2010_poster_wcrp'])
%%


%compute the slope of the line

