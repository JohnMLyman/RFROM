%% Define a color table 

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

% %% Compute global integrals of heat content 
cd /Volumes/Data/Globalhc/HC
min_year=2004;
max_year=2011;
%% 
% 

[hc_900_1800,time_900_1800,hc_one_900_1800]=heat_curv_gen_mat_takeout_map_mean('hdata_new__table1_EN3_pfloat_sal_greg_jan_20121950_2011_1800_real.mat');
[hc_700_900,time_700_900,hc_one_700_900]=heat_curv_gen_mat_takeout_map_mean('hdata_new__table1_EN3_pfloat_sal_greg_jan_20121950_2011_900_real.mat');
[hc_700,time_700,hc_one_700]=heat_curv_gen_mat_takeout_map_mean('hdata_new__table1_EN3_pfloat_sal_greg_jan_20121950_2011_700_real.mat');
[hc_300_700,time_300_700,hc_one_300_700]=heat_curv_gen_mat_takeout_map_mean('hdata_new__table1_EN3_pfloat_sal_greg_jan_20121950_2011_300_700_real.mat');
[hc_100_300,time_100_300,hc_one_100_300]=heat_curv_gen_mat_takeout_map_mean('hdata_new__table1_EN3_pfloat_sal_greg_jan_20121950_2011_100_300_real.mat');

cd ../SAL/Floats

[hc,time,hc_one]=heat_curv_gen_mat_takeout_map_mean('hdata_oco_realtime_jan_2011_700_real.mat');

cd /Volumes/Data/Globalhc/HC

% 
%% %% subsect all and put into Zeta joules

good_pos_1800=find(time_1800 >= min_year& time_1800 <=max_year);
good_pos_900=find(time_900 >= min_year & time_900 <=max_year);
good_pos_700=find(time_700 >= min_year & time_700 <=max_year);
good_pos_300=find(time_300 >= min_year & time_300 <=max_year);
good_pos=find(time >= min_year & time <=max_year);


hc_1800=hc_1800(good_pos_1800)/1e21;
time_1800=time_1800(good_pos_1800);
hc_one_1800=hc_one_1800(good_pos_1800)/1e21;

hc_900=hc_900(good_pos_900)/1e21;
time_900=time_900(good_pos_900);
hc_one_900=hc_one_900(good_pos_900)/1e21;

hc_700=hc_700(good_pos_700)/1e21;
time_700=time_700(good_pos_700);
hc_one_700=hc_one_700(good_pos_700)/1e21;
hc_300=hc_300(good_pos_300)/1e21;
time_300=time_300(good_pos_300);
hc_one_300=hc_one_300(good_pos_300)/1e21;

hc=hc(good_pos)/1e21;
time=time(good_pos);
hc_one=hc_one(good_pos)/1e21;


save hc_300_700_900_1800 hc_one_1800 hc_1800 time_1800 hc_one_900 hc_900 time_900 hc_one_700 hc_700 time_700 hc_one_300 hc_300 time_300 ...
    hc_one hc time 
%% Compute error

[se_1800,time_1800,f2]=twin_error_realtime(1800);
[se_300,time_300,f2]=twin_error_realtime(300);
[se_700,time_700,f2]=twin_error_realtime(700);
[se_900,time_900,f2]=twin_error_realtime(900);


se_1800=se_1800./1e21;
se_900=se_900./1e21;
se_700=se_700./1e21;
se_300=se_300./1e21;

save error_300_700_900_1800 se_1800 se_900 se_700 se_300 time
%% Load other OHCA curves 
% load /Volumes/Data/Globalhc/SAL/Floats/simon_hc_2010
% good_simon=find(simon_time> 1993);
% simon_time=simon_time(good_simon);
% simon_se=simon_se(good_simon);
% simon_hc=simon_hc(good_simon);
% 
% load /Volumes/Data/Globalhc/SAL/Floats/tim_hc_2010
% good_tim=find(tim_time> 1993);
% tim_time=tim_time(good_tim);
% tim_se=tim_se(good_tim);
% tim_hc=tim_hc(good_tim);
% 
% load /Volumes/Data/Globalhc/SAL/Floats/josh_hc_2010
% good_josh=find(josh_time> 1993);
% josh_time=josh_time(good_josh);
% josh_hc_tpx=josh_hc_tpx(good_josh);
% josh_hc=josh_hc(good_josh);
% 
% 
% 
% pos_tim_argo=find(tim_time> 2004);
% tim_hc=tim_hc-nanmean(tim_hc(pos_tim_argo));
% 
% pos_josh_argo=find(josh_time> 2004);
% josh_hc=josh_hc-nanmean(josh_hc(pos_josh_argo));
% josh_hc_tpx=josh_hc_tpx-nanmean(josh_hc_tpx(pos_josh_argo));
% 
% pos_simon_argo=find(simon_time> 2004);
% simon_hc=simon_hc-nanmean(simon_hc(pos_simon_argo));
% 
%  pos_argo=find(time> 2004);
%  hc_one=hc_one-nanmean(hc_one(pos_argo));
% 
%  hc_all=[hc_one';tim_hc;simon_hc];
% offset=nanmean(hc_all);
% 
% 
% hc_one=hc_one-offset;
% tim_hc=tim_hc-offset;
% simon_hc=simon_hc-offset;
% josh_hc=josh_hc-offset;
% josh_hc_tpx=josh_hc_tpx-offset;
% 
% %%
% hc=hc-nanmean(hc(pos_argo));
% hc=hc-offset;
% 


%%     
figure(3); clf;orient landscape; wysiwyg
load '/Volumes/Data/Globalhc/SAL/Floats/nature_2010_ohca_curve_oco_greg' time hc_one hc_se

hc_se=hc_se(end-6:end);
time_oco=time(end-6:end);
hc_one_oco=hc_one(end-6:end);

range=[2:7];

% p300=plot(time_300,hc_one_300-mean(hc_one_300),'-*','color',mycor(5,:));
% hold on
% p700=plot(time_700,hc_one_700-mean(hc_one_700),'-*','color',mycor(4,:));
% p900=plot(time_900,hc_one_900-mean(hc_one_900),'-*','color',mycor(3,:));
% p1800=plot(time_1800,hc_one_1800-mean(hc_one_1800),'-*','color',mycor(1,:));

hc_c_900=hc_one_700+hc_one_900;
hc_c_1800=hc_1800+hc_c_900;
se_c_900=se_900+se_700;
se_c_1800=se_c_900+se_1800;
hc_one_700=hc_one_oco./1e21;
%se_700=hc_se;
%p300=plot(time_300,hc_one_300,'-*','color',mycor(5,:));
hold on
p700=plot(time_700(range),hc_one_700(range)-mean(hc_one_oco./1e21),'-*','color',mycor(4,:));
p900=plot(time_900(range),hc_one_900(range),'-*','color',mycor(3,:));
p1800=plot(time_1800(range),hc_one_1800(range),'-*','color',mycor(1,:));


%p=plot(time,hc,'-*','color','k');


%et=errorbar(time_300,hc_one_300,se_300,'color',mycor(5,:));set(et,'linewidth',3);
et=errorbar(time_700(range),hc_one_700(range)-mean(hc_one_oco./1e21),se_700(range),'color',mycor(4,:));set(et,'linewidth',3);
et=errorbar(time_900(range),hc_one_900(range),se_900(range),'color',mycor(3,:));set(et,'linewidth',3);
et=errorbar(time_1800(range),hc_one_1800(range),se_1800(range),'color',mycor(1,:));set(et,'linewidth',3);


ylabel('Heat Content Anomaly [zeta-joules]','fontsize',16);

%set(p300,'linewidth',3)
set(p700,'linewidth',3)
set(p900,'linewidth',3)
set(p1800,'linewidth',3)
%set(p,'linewidth',3)

set(gca,'XTick',[min_year:2:max_year],'tickdir','out', 'XMinorTick','on')


xlabel('Time [years]','fontsize',16);

title('Heat Content Anomaly','fontsize',18);
axis([min_year+1 max_year -30 30])
set(gca,'fontsize',16)


 
 offset_axis=1;
 text_off=9-offset_axis;
  text_off=text_off*10;
  text_del=.25;
  text_del=text_del*10;
  year_text=2008.5;
  text_size=12;
  text_off=15;
  all_color=mycor(11,:);
  
text(year_text,text_off+text_del*1,'900-1800 m','color',mycor(1,:),'FontName','Arial','FontSize',text_size)
  

 plot([year_text-2 year_text-1],[text_off+text_del*1 text_off+text_del*1],'color',mycor(1,:),'linewidth',3)



text(year_text,text_off+text_del*2,'700-900 m','color',mycor(3,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*2 text_off+text_del*2],'color',mycor(3,:),'linewidth',3)


text(year_text,text_off+text_del*3,'0-700 m','color',mycor(4,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*3 text_off+text_del*3],'color',mycor(4,:),'linewidth',3)

%text(year_text,text_off+text_del*4,'0-300 m','color',mycor(5,:),'FontName','Arial','FontSize',text_size)
%plot([year_text-2 year_text-1],[text_off+text_del*4 text_off+text_del*4],'color',mycor(5,:),'linewidth',3)



%plot the x-axis

plot([min_year-1 max_year+1],[0 0],'k')





eval(['print -dpng -f3 /Users/johnlyman/figs/oco/Oceans/hc_1800_900_700_300'])
%%


%compute the slope of the line

%%
figure(1)
i=8
pcolor(lon,lat,one(:,:,i)')
shading flat
plot_coasts_black
colorbar

