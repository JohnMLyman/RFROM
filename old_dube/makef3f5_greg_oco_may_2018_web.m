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
     
%%
% global integrals of heat content and storage
cd /Volumes/ThunderBay/Data/Globalhc/HC
min_year=1993;
min_year_deep=1993;
max_year=2018;
max_year_deep=2018;
%load in error bars
% 
% load '/Volumes/ThunderBay/Data/Globalhc/SAL/Floats/nature_2010_ohca_curve'
% 
% hc_se=[ohca_se ohca_se(end) ohca_se(end) ohca_se(end) ohca_se(end) ohca_se(end) ohca_se(end) ohca_se(end)]*10;
% hc_se=[repmat(hc_se(1),[1,26]),hc_se];
% 
% 
% time_se=[1967.5:2015.5];
% % 
load '/Volumes/ThunderBay/Data/OHCA_curves/total_uncertainty_paper_2015_0_700_1800_oco'  time_se total_se_0_700 samp_un_sd_700_1800 total_se_0_1800
del_time=max_year-2010-1;
time_se=[time_se' [2010.5:1:2010.5+del_time]];
hc_se=[total_se_0_700 repmat(total_se_0_700(end),1,del_time+1)];
hc_se_deep=[samp_un_sd_700_1800 repmat(samp_un_sd_700_1800(end),1,del_time+1)];

hc_se_total=[total_se_0_1800 repmat(total_se_0_1800(end),1,del_time+1)];


good_se=find(time_se>min_year);
hc_se=hc_se(good_se);
% good_se_deep=find(time_se>1992);
% hc_se_deep=hc_se_deep(good_se_deep);
%hc_se_deep=hc_se_deep(good_se);
%area of the earth used to compute w/m^2
area_of_earth=5.1e14;



cd ../HC/

 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
file_name_argo='argo_2018_1_5_QC';
min_year_mapped='1990'; % the minimum year that was used to produce the OHCA fields.
max_year_mapped='2017';% the maximumyear that was used to produece the OHCA fields.

[~,time,~]=...
         heat_curv_gen_mat_2012_new_un_topo_new_layers(['hdata_new_layers__ishii_EN3_2014_',file_name_argo,...
         min_year_mapped,'_',max_year_mapped,'_'],...
         layer_bounds(1),layer_bounds(2));
      hc_one=zeros(1,length(time));
      hc_one_deep=hc_one;
for ilayer=2:length(layer_bounds)
 
    hc_one_junk=[];
     [hc,time,hc_one_junk]=...
         heat_curv_gen_mat_2012_new_un_topo_new_layers(['hdata_new_layers__ishii_EN3_2014_',file_name_argo,...
         min_year_mapped,'_',max_year_mapped,'_'],...
         layer_bounds(ilayer-1),layer_bounds(ilayer));
     eval(['hc_one_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),'=hc_one_junk;'])
     
     if layer_bounds(ilayer)<= 700
         hc_one=hc_one_junk+hc_one;
     end
     if layer_bounds(ilayer-1)>= 700
         hc_one_deep=hc_one_junk./1e21+hc_one_deep;
     end
end
% % % 
% % %  [hc,time,hc_one_100]=heat_curv_gen_mat_2012_new_un_topo('hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_2016_QC1992_2015_100_real',0,100);
% % % [hc,time,hc_one_100_300]=heat_curv_gen_mat_2012_new_un_topo('hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_2016_QC1992_2015_100_300_real',100,300);
% % %  [hc,time,hc_one_300_700]=heat_curv_gen_mat_2012_new_un_topo('hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_2016_QC1992_2015_300_700_real',300,700);
% % %  [hc,time,hc_one_700_900]=heat_curv_gen_mat_2012_new_un_topo('hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_2016_QC1992_2015_900_real',700,900);
% % %  [hc,time,hc_one_900_1800]=heat_curv_gen_mat_2012_new_un_topo('hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_2016_QC1992_2015_1800_real',900,1800);
% % % 
% % %  save '/Volumes/ThunderBay/Data/Globalhc/SAL/Floats/ohca_1992_2015_curve_100_300_700_900_1800_jan_2016' time hc_one_100 hc_one_100_300 hc_one_300_700 hc_one_700_900 hc_one_900_1800
%%%%load '/Volumes/ThunderBay/Data/Globalhc/SAL/Floats/ohca_1992_2015_curve_100_300_700_900_1800_jan_2016' time hc_one_100 hc_one_100_300 hc_one_300_700 hc_one_700_900 hc_one_900_1800

% % % load '/Volumes/ThunderBay/Data/Globalhc/SAL/Floats/ohca_1950_2015_curve_100_300_700_900_1800_jan_2016' time hc_one_100 hc_one_100_300 hc_one_300_700 hc_one_700_900 hc_one_900_1800


% 
% hc_one=hc_one_100+hc_one_100_300+hc_one_300_700;
%  
% 
%  hc_one_deep=(hc_one_700_900+hc_one_900_1800)./1e21;
 time_deep=time;
good_se_deep=find(time_se>= min(time_deep));
hc_se_deep=hc_se_deep(good_se_deep);
 % this is just a place holder
% % %  ntime_deep=length(time_deep);
% % %  nhc_se=length(hc_se);
% % %  hc_se_deep=[repmat(hc_se(1),[1,ntime_deep-nhc_se]),hc_se]./2;

%subsect all and put into Zeta joules
cd ../SAL/Floats

good_pos=find(time >= min_year & time <=max_year);


% hc_one=hc_one2';


time=time(good_pos);
hc_one=hc_one(good_pos)/1e21;



%%

% global integrals of heat content and storage
cd /Volumes/ThunderBay/Data/Globalhc/HC
min_year=1993;
max_year=2018;
%load in error bars



%area of the earth used to compute w/m^2
area_of_earth=5.1e14


cd ../SAL/Floats

%[hc,time,hc_one]=heat_curv_gen_mat('htanom_oco_realtime_1993_2010.mat');
%[hc,time,hc_one]=heat_curv_gen_mat('hdata_oco_realtime_jan_2012_700_real2.mat');

% % load '/Volumes/Data/Globalhc/SAL/Floats/nature_2014_ohca_curve_oco_greg2' time hc_one hc_se
% % hc_se=[hc_se,hc_se(end)];
%subsect all and put into Zeta joules

load /Volumes/ThunderBay/Data/Globalhc/SAL/Floats/simon_hc_2017
good_simon=find(simon_time> min_year);
simon_time=simon_time(good_simon);
simon_se=simon_se(good_simon);
simon_hc=simon_hc(good_simon);

load /Volumes/ThunderBay/Data/Globalhc/SAL/Floats/tim_hc_2017
good_tim=find(tim_time> min_year);
tim_time=tim_time(good_tim);
tim_se=tim_se(good_tim);
tim_hc=tim_hc(good_tim);

load /Volumes/ThunderBay/Data/Globalhc/SAL/Floats/ishii_hc_2017
good_ishii=find(ishii_time> min_year);
ishii_time=ishii_time(good_ishii);
ishii_se=ishii_se(good_ishii);
ishii_hc=ishii_hc(good_ishii);

load /Volumes/ThunderBay/Data/Globalhc/SAL/Floats/catia_hc_2017
good_catia=find(catia_time> min_year);
catia_time=catia_time(good_catia);
catia_se=catia_se(good_catia);
catia_hc=catia_hc(good_catia);

load /Volumes/ThunderBay/Data/Globalhc/SAL/Floats/cheng_hc_2017
good_cheng=find(cheng_time> min_year);
cheng_time=cheng_time(good_cheng);
cheng_se=cheng_se(good_cheng);
cheng_hc=cheng_hc(good_cheng);

pos_catia_argo=find(catia_time> 2004);
catia_hc=catia_hc-nanmean(catia_hc(pos_catia_argo));

pos_tim_argo=find(tim_time> 2004);
tim_hc=tim_hc-nanmean(tim_hc(pos_tim_argo));

pos_ishii_argo=find(ishii_time> 2004);
ishii_hc=ishii_hc-nanmean(ishii_hc(pos_ishii_argo));

pos_simon_argo=find(simon_time> 2004);
simon_hc=simon_hc-nanmean(simon_hc(pos_simon_argo));

pos_argo=find(time> 2004);
hc_one=hc_one-nanmean(hc_one(pos_argo));

pos_cheng_argo=find(cheng_time> 2004);
cheng_hc=cheng_hc-nanmean(cheng_hc(pos_cheng_argo));

hc_all=[hc_one';tim_hc;simon_hc;catia_hc;ishii_hc;cheng_hc];
hc_all=[hc_one(1)';tim_hc(1);simon_hc(1);catia_hc(1);ishii_hc(1);cheng_hc(1)];

offset=nanmean(hc_all);


hc_one=hc_one-offset;
tim_hc=tim_hc-offset;
simon_hc=simon_hc-offset;
catia_hc=catia_hc-offset;
ishii_hc=ishii_hc-offset;
cheng_hc=cheng_hc-offset;

%%     
figure(3); clf;orient tall; wysiwyg




pch=plot(cheng_time,cheng_hc,'-*','color',mycor(6,:));
ech=errorbar(cheng_time,cheng_hc,cheng_se,'color',mycor(6,:));set(ech,'linewidth',3);
hold on



pc=plot(catia_time,catia_hc,'-*','color',mycor(2,:));
ec=errorbar(catia_time,catia_hc,catia_se,'color',mycor(2,:));set(ec,'linewidth',3);
hold on

pi=plot(ishii_time,ishii_hc,'-*','color',mycor(5,:));
ei=errorbar(ishii_time,ishii_hc,ishii_se,'color',mycor(5,:));set(ei,'linewidth',3);
hold on



pt=plot(tim_time,tim_hc,'-*','color',mycor(3,:));
et=errorbar(tim_time,tim_hc,tim_se,'color',mycor(3,:));set(et,'linewidth',3);
hold on
p2=plot(time,hc_one,'-*','color',mycor(1,:));
% e=errorbar(time,hc_one,hc_se,'color',mycor(1,:));set(e,'linewidth',3);

hold on
ps=plot(simon_time,simon_hc,'-*','color',mycor(4,:));
es=errorbar(simon_time,simon_hc,simon_se,'color',mycor(4,:));set(es,'linewidth',3);



%plot(time_argo,hc_one_argo,'-*');
%plot(time_no_argo,hc_one_no_argo,'r-*');
% ylabel('0-700 m Heat Content Anomaly (Zettajoules)','fontsize',16);
%set(p2,'linewidth',3)
set(ps,'linewidth',3)
%set(pt,'linewidth',3)
% set(gca,'XTick',[min_year:2:max_year],'tickdir','out', 'XMinorTick','off')
% 
% 
% xlabel('Time (years)','fontsize',16);

%title('0-700m Heat Content Anomaly','fontsize',18);
% axis([min_year max_year -100 80])
% set(gca,'fontsize',16)


 
 offset_axis=1;
 text_off=9-offset_axis;
  text_off=text_off*10;
  text_del=1.1;
  text_del=text_del*10;
  year_text=2005;
  text_size=15;
  text_off=-39;
  
  
  text(year_text,text_off+text_del*1,'IAP/CAS ','color',mycor(6,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*1 text_off+text_del*1],'color',mycor(6,:),'linewidth',3)
  
text(year_text,text_off+text_del*2,'Met Office Hadley Centre ','color',mycor(4,:),'FontName','Arial','FontSize',text_size)
  

 plot([year_text-2 year_text-1],[text_off+text_del*2 text_off+text_del*2],'color',mycor(4,:),'linewidth',3)


% text(year_text,text_off+text_del*3,'PMEL/JPL/JIMAR (0-750m)','color',mycor(5,:),'FontName','Arial','FontSize',text_size)
% plot([year_text-2 year_text-1],[text_off+text_del*3 text_off+text_del*3],'color',mycor(5,:),'linewidth',2)

text(year_text,text_off+text_del*3,'NCEI ','color',mycor(3,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*3 text_off+text_del*3],'color',mycor(3,:),'linewidth',3)

% text(year_text,text_off+text_del*5,'Nature 1993-2008','color',mycor(2,:),'FontName','Arial','FontSize',text_size)
% plot([year_text-2 year_text-1],[text_off+text_del*5 text_off+text_del*5],'color',mycor(2,:),'linewidth',2)

text(year_text,text_off+text_del*4,'PMEL/JPL/JIMAR ','color',mycor(1,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*4 text_off+text_del*4],'color',mycor(1,:),'linewidth',3)

text(year_text,text_off+text_del*5,'CSIRO/ACE CRC/IMAS-UTAS ','color',mycor(2,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*5 text_off+text_del*5],'color',mycor(2,:),'linewidth',3)

text(year_text,text_off+text_del*6,'MRI/JMA ','color',mycor(5,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*6 text_off+text_del*6],'color',mycor(5,:),'linewidth',3)



%e1=errorbar(time_argo,hc_one_argo,error_argo);set(e1,'linewidth',2)
%e2=errorbar(time_no_argo,hc_one_no_argo,error_no_argo,'r');set(e2,'linewidth',2)
%e3=errorbar(time,hc_one,error_all,'k');set(e3,'linewidth',2)

%plot the x-axis

plot([min_year-1 max_year+1],[0 0],'k')

off2=25;
max_ohca=175-off2;
min_ohca=-100-off2 ;

max_ohca=180;
min_ohca=-40 ;

scale_plot=.16./100;
plot_height=(max_ohca-min_ohca)*scale_plot;



set(gca,'tickdir','out','Fontsize',16,'Fontname','Arial','box','on','pos',[.15 .5 .75 plot_height],'xtick',[1970:5:max_year],'xticklabel',[],...
    'ytick',[min_ohca:20:max_ohca])
axis([min_year max_year min_ohca max_ohca])
% plot([1967 2016],[-99.99 -99.99],'k-');
% plot([2011.99 2011.99],[-100 175],'k-');

text(1994.5,145,'(a)','Fontsize',16,'Fontname','Arial','Fontweight','Bold')


ylabel('0-700 m OHC (ZJ)','Fontsize',16,'Fontname','Arial')



axes
%save_ascii_oco_hc_2017
% compute the deep OHCA curves



%%     
figure(3); clf;orient landscape; wysiwyg

% pt=plot(tim_time,tim_hc,'-*','color',mycor(3,:));
% et=errorbar(tim_time,tim_hc,tim_se,'color',mycor(3,:));set(et,'linewidth',3);
% hold on
p2=plot(time,hc_one-70,'-*','color','k');
e=errorbar(time,hc_one-70,hc_se,'color','k');set(e,'linewidth',3);

hold on
% ps=plot(simon_time,simon_hc,'-*','color',mycor(1,:));
% es=errorbar(simon_time,simon_hc,simon_se,'color',mycor(1,:));set(es,'linewidth',3);


%plot(time_argo,hc_one_argo,'-*');
%plot(time_no_argo,hc_one_no_argo,'r-*');
ylabel('0-700 m Heat Content Anomaly [zeta-joules]','fontsize',16);
%set(p2,'linewidth',3)
% set(ps,'linewidth',3)
%set(pt,'linewidth',3)
set(gca,'XTick',[min_year:2:max_year],'tickdir','out', 'XMinorTick','off')


xlabel('Time [years]','fontsize',16);

title('0-700m Heat Content Anomaly','fontsize',18);
axis([min_year max_year -100 100])
set(gca,'fontsize',16)


 
 offset_axis=1;
 text_off=9-offset_axis;
  text_off=text_off*10;
  text_del=1;
  text_del=text_del*10;
  year_text=1995.5;
  text_size=12;
  text_off=20;
  all_color=mycor(11,:);
% text(year_text,text_off+text_del*1,'Hadley ','color',mycor(1,:),'FontName','Arial','FontSize',text_size)
%   
% 
%  plot([year_text-2 year_text-1],[text_off+text_del*1 text_off+text_del*1],'color',mycor(1,:),'linewidth',3)
% 
% 
% % text(year_text,text_off+text_del*3,'PMEL/JPL/JIMAR (0-750m)','color',mycor(5,:),'FontName','Arial','FontSize',text_size)
% % plot([year_text-2 year_text-1],[text_off+text_del*3 text_off+text_del*3],'color',mycor(5,:),'linewidth',2)
% 
% text(year_text,text_off+text_del*2,'NODC ','color',mycor(3,:),'FontName','Arial','FontSize',text_size)
% plot([year_text-2 year_text-1],[text_off+text_del*2 text_off+text_del*2],'color',mycor(3,:),'linewidth',3)
% 
% % text(year_text,text_off+text_del*5,'Nature 1993-2008','color',mycor(2,:),'FontName','Arial','FontSize',text_size)
% % plot([year_text-2 year_text-1],[text_off+text_del*5 text_off+text_del*5],'color',mycor(2,:),'linewidth',2)
% 
% text(year_text,text_off+text_del*3,'PMEL/JPL/JIMAR ','color',mycor(4,:),'FontName','Arial','FontSize',text_size)
% plot([year_text-2 year_text-1],[text_off+text_del*3 text_off+text_del*3],'color',mycor(4,:),'linewidth',3)


%e1=errorbar(time_argo,hc_one_argo,error_argo);set(e1,'linewidth',2)
%e2=errorbar(time_no_argo,hc_one_no_argo,error_no_argo,'r');set(e2,'linewidth',2)
%e3=errorbar(time,hc_one,error_all,'k');set(e3,'linewidth',2)

%plot the x-axis

plot([min_year-1 max_year+1],[0 0],'k')





eval(['print -dpng -f3 /Users/lyman/Documents/figs/oco/Oceans/OHCA_curve_2017'])
eval(['print -dpdf -f3 /Users/lyman/Documents/figs/oco/Oceans/OHCA_curve_2017'])
%%


%compute the slope of the line

