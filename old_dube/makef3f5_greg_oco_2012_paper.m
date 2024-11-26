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
max_year=2013;
%load in error bars

load '/Volumes/Data/Globalhc/SAL/Floats/nature_2010_ohca_curve'

hc_se=[ohca_se ohca_se(end) ohca_se(end) ohca_se(end)]*10;

%area of the earth used to compute w/m^2
area_of_earth=5.1e14


time_error=time;


cd ../SAL/Floats

%[hc,time,hc_one]=heat_curv_gen_mat('htanom_oco_realtime_1993_2010.mat');
%[hc,time,hc_one]=heat_curv_gen_mat('hdata_oco_realtime_jan_2012_700_real2.mat');
%[hc,time,hc_one]=heat_curv_gen_mat('hdata_oco_realtime_jan_clim_2011t_2012_700_real2.mat');
[hc,time,hc_one,one,area]=heat_curv_gen_mat_2012_new_un('hdata_oco_realtime_jan_clim_2011t_2012_700_real2');
% load '/Volumes/Data/Globalhc/SAL/Floats/nature_2013_ohca_curve_oco_greg' time hc_one hc_se
% time=time(1:end-1);
% hc_one=hc_one(1:end-1);
% hc_se=hc_se(1:end-1);
save '/Volumes/Data/Globalhc/SAL/Floats/nature_2012_ohca_curve_oco_greg' time hc_one hc_se
%subsect all and put into Zeta joules

good_pos=find(time >= min_year & time <=max_year);

%hc=hc(good_pos)/1e21;
time=time(good_pos);
hc_one=hc_one(good_pos)/1e21;
%%



load /Volumes/Data/Globalhc/SAL/Floats/ohca_layers time_layers hc_0_1800 hc_0_700 y_700 y_1800
min_year=y_700-.5;
max_year=2015;

good_700=find(time_layers>= y_700);
hc_0_1800(time_layers <y_1800)=NaN;
hc_0_700(time_layers <y_700)=NaN;

pos_oco=find(time_layers >1993);


pos_argo=find(time> 2008);
hc_one=hc_one-nanmean(hc_one(pos_argo));

% hc_all=[hc_one';tim_hc;simon_hc];
% offset=nanmean(hc_all);
% 
% 
% hc_one=hc_one-offset;
% tim_hc=tim_hc-offset;
% simon_hc=simon_hc-offset;




%%     
figure(3); clf;orient landscape; wysiwyg

pt=plot(time_layers,hc_0_1800,'-*','color',mycor(3,:));set(pt,'linewidth',3);
%et=errorbar(tim_time,tim_hc,tim_se,'color',mycor(3,:));set(et,'linewidth',3);
hold on
p2=plot(time,hc_one,'-*','color',mycor(4,:));
e=errorbar(time,hc_one,hc_se,'color',mycor(4,:));set(e,'linewidth',3);

hold on
ps=plot(time_layers,hc_0_700,'-*','color',mycor(1,:));set(ps,'linewidth',3);
es=errorbar(time_layers(pos_oco),hc_0_700(pos_oco),hc_se,'color',mycor(1,:));set(es,'linewidth',3);


%plot(time_argo,hc_one_argo,'-*');
%plot(time_no_argo,hc_one_no_argo,'r-*');
ylabel('Heat Content Anomaly [zeta-joules]','fontsize',16);
%set(p2,'linewidth',3)
set(ps,'linewidth',3)
%set(pt,'linewidth',3)
set(gca,'XTick',[min_year:2:max_year],'tickdir','out', 'XMinorTick','off')


xlabel('Time [years]','fontsize',16);

title('Heat Content Anomaly','fontsize',18);
axis([min_year max_year -200 40])
set(gca,'fontsize',16)


 
 offset_axis=1;
 text_off=9-offset_axis;
  text_off=text_off*10;
  text_del=1;
  text_del=text_del*10;
  year_text=1987.5;
  text_size=12;
  text_off=-50;
  all_color=mycor(11,:);
text(year_text,text_off+text_del*1,'0-700 m layers ','color',mycor(1,:),'FontName','Arial','FontSize',text_size)
  

 plot([year_text-2 year_text-1],[text_off+text_del*1 text_off+text_del*1],'color',mycor(1,:),'linewidth',3)


% text(year_text,text_off+text_del*3,'PMEL/JPL/JIMAR (0-750m)','color',mycor(5,:),'FontName','Arial','FontSize',text_size)
% plot([year_text-2 year_text-1],[text_off+text_del*3 text_off+text_del*3],'color',mycor(5,:),'linewidth',2)

text(year_text,text_off+text_del*2,'0-1800 m layers ','color',mycor(3,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*2 text_off+text_del*2],'color',mycor(3,:),'linewidth',3)

% text(year_text,text_off+text_del*5,'Nature 1993-2008','color',mycor(2,:),'FontName','Arial','FontSize',text_size)
% plot([year_text-2 year_text-1],[text_off+text_del*5 text_off+text_del*5],'color',mycor(2,:),'linewidth',2)

text(year_text,text_off+text_del*3,'0-700 oco 2012 ','color',mycor(4,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*3 text_off+text_del*3],'color',mycor(4,:),'linewidth',3)


%e1=errorbar(time_argo,hc_one_argo,error_argo);set(e1,'linewidth',2)
%e2=errorbar(time_no_argo,hc_one_no_argo,error_no_argo,'r');set(e2,'linewidth',2)
%e3=errorbar(time,hc_one,error_all,'k');set(e3,'linewidth',2)

%plot the x-axis

plot([min_year-1 max_year+1],[0 0],'k')





eval(['print -dpng -f3 /Users/johnlyman/figs/oco/Oceans/ohca_curve_comp_paper_2012s'])
%eval(['print -depsc2 -r600 -f3 /Users/johnlyman/figs/oco/Oceans/hc_one_greg_oco_t2012_new'])
%%


%compute the slope of the line

