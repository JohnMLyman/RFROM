% makef3f5.m - matlab script to make figures 3 and 5 for the globahc paper
mycor = [

         0.88          0.31             0
         0.60             0             0
         0.30          0.31          0.99
            0          0.60          0.20
         0.28          0.77          0.96
         0.99          0.81             0
         1.00          0.20          0.8
         0.49          0.10          0.34
         0.60          0.60          0.60
         .7             .9             .2
         0             0             0];
     
     mycor=[27,158,119
217,95,2
117,112,179
231,41,138
124.9500,25.5000,86.7000]./255;

mycor=[228,26,28 
    55,126,184
    77,175,74
    152,78,163
    255,127,0
    55,78,0]./255;

% % 

path_curves='H:\Figs\OHC\data\curves\';
path_figs='H:\Figs\OHC\';
min_year=1993;
min_year_deep=1993;
max_year=2024;
max_year_deep=2024;
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

[tgrid,tgrid_annual_0_700,ht_curve_0_700,ht_no_cycle_0_700,ht_curve_annual_0_700,se_0_700]=load_tree_ohca_nocycle(TreeSetUp,0,700);
[tgrid_700_2000,tgrid_annual_700_2000,ht_curve_700_2000,ht_no_cycle_700_2000,ht_curve_annual_700_2000,se_700_2000]=load_tree_ohca_nocycle(TreeSetUp,700,2000);
[tgrid_0_2000,tgrid_annual_0_2000,ht_curve_0_2000,ht_no_cycle_0_2000,ht_curve_annual_0_2000,se_0_2000]=load_tree_ohca_nocycle(TreeSetUp,0,2000);



hc_se=se_0_700./1e21;
hc_se_deep=se_700_2000./1e21;
hc_se_total=se_0_2000./1e21;

time_se=tgrid_annual_700_2000;
good_se=find(time_se>min_year);
hc_se=hc_se(good_se);
% good_se_deep=find(time_se>1992);
% hc_se_deep=hc_se_deep(good_se_deep);
%hc_se_deep=hc_se_deep(good_se);
%area of the earth used to compute w/m^2
area_of_earth=5.1e14;

year_of_oco_pub=2023;
slope_min_year=1993;




hc_one=ht_curve_annual_0_700./1e21;
hc_one_deep=ht_curve_annual_700_2000./1e21;

 time=tgrid_annual_0_700;
time_se=time;
 time_deep=time;
good_se_deep=find(time_se>= min(time_deep));
hc_se_deep=hc_se_deep(good_se_deep);
 % this is just a place holder
% % %  ntime_deep=length(time_deep);
% % %  nhc_se=length(hc_se);
% % %  hc_se_deep=[repmat(hc_se(1),[1,ntime_deep-nhc_se]),hc_se]./2;

%subsect all and put into Zeta joules


good_pos=find(time >= min_year & time <=max_year);

span = 3; % Size of the averaging window
window = ones(span,1)/span; 
hc_one2 = convn(hc_one',window,'same');
% hc_one=hc_one2';


time=time(good_pos);
hc_one=hc_one(good_pos);

%%
save([path_curves,'pmel_hc_2023.mat'],'time', 'hc_one', 'hc_se')
%%
load([path_curves,'simon_hc_2022.mat'])
good_simon=find(simon_time> min_year);
simon_time=simon_time(good_simon);
simon_se=simon_se(good_simon);
simon_hc=simon_hc(good_simon);

load([path_curves,'tim_hc_2023.mat'])
good_tim=find(tim_time> min_year);
tim_time=tim_time(good_tim);
tim_se=tim_se(good_tim);
tim_hc=tim_hc(good_tim);

load([path_curves,'ishii_hc_2022.mat'])
good_ishii=find(ishii_time> min_year);
ishii_time=ishii_time(good_ishii);
ishii_se=ishii_se(good_ishii);
ishii_hc=ishii_hc(good_ishii);

load([path_curves,'catia_hc_2018.mat'])
good_catia=find(catia_time> min_year);
catia_time=catia_time(good_catia);
catia_se=catia_se(good_catia);
catia_hc=catia_hc(good_catia);

load([path_curves,'cheng_hc_2022.mat'])
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

% hc_all=[hc_one;tim_hc;simon_hc;catia_hc;ishii_hc;cheng_hc];
hc_all=[hc_one(1);tim_hc(1);simon_hc(1);catia_hc(1);ishii_hc(1);cheng_hc(1)];
hc_all=[hc_one(1);tim_hc(1);simon_hc(1);ishii_hc(1);cheng_hc(1)];

offset=nanmean(hc_all);


hc_one=hc_one-offset;
tim_hc=tim_hc-offset;
simon_hc=simon_hc-offset;
catia_hc=catia_hc-offset;
ishii_hc=ishii_hc-offset;
cheng_hc=cheng_hc-offset;

%%     
figure(3); clf;orient tall; wysiwyg_tuna




pch=plot(cheng_time,cheng_hc,'-*','color',mycor(6,:));
ech=errorbar(cheng_time,cheng_hc,cheng_se,'color',mycor(6,:));set(ech,'linewidth',3);
hold on



% % % pc=plot(catia_time,catia_hc,'-*','color',mycor(2,:));
% % % ec=errorbar(catia_time,catia_hc,catia_se,'color',mycor(2,:));set(ec,'linewidth',3);
% % % hold on

pi=plot(ishii_time,ishii_hc,'-*','color',mycor(5,:));
ei=errorbar(ishii_time,ishii_hc,ishii_se,'color',mycor(5,:));set(ei,'linewidth',3);
hold on



pt=plot(tim_time,tim_hc,'-*','color',mycor(3,:));
et=errorbar(tim_time,tim_hc,tim_se,'color',mycor(3,:));set(et,'linewidth',3);
hold on
p2=plot(time,hc_one,'-*','color',mycor(1,:));
e=errorbar(time,hc_one,hc_se,'color',mycor(1,:));set(e,'linewidth',3);

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

% % % text(year_text,text_off+text_del*5,'CSIRO/ACE CRC/IMAS-UTAS ','color',mycor(2,:),'FontName','Arial','FontSize',text_size)
% % % plot([year_text-2 year_text-1],[text_off+text_del*5 text_off+text_del*5],'color',mycor(2,:),'linewidth',3)

text(year_text,text_off+text_del*5,'JMA ','color',mycor(5,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*5 text_off+text_del*5],'color',mycor(5,:),'linewidth',3)



%e1=errorbar(time_argo,hc_one_argo,error_argo);set(e1,'linewidth',2)
%e2=errorbar(time_no_argo,hc_one_no_argo,error_no_argo,'r');set(e2,'linewidth',2)
%e3=errorbar(time,hc_one,error_all,'k');set(e3,'linewidth',2)

%plot the x-axis

plot([min_year-1 max_year+1],[0 0],'k')

off2=40;
max_ohca=175-off2;
min_ohca=-100-off2 ;

max_ohca=240;
min_ohca=-40 ;
max_ohca_deep=120;
min_ohca_deep=-60;


scale_plot=.16./100;
plot_height=(max_ohca-min_ohca)*scale_plot;
plot_height_deep=(max_ohca_deep-min_ohca_deep)*scale_plot;
plot_height_deep_0=.21;


set(gca,'tickdir','out','Fontsize',16,'Fontname','Arial','box','on','pos',[.15 plot_height_deep_0+plot_height_deep+scale_plot*20 .75 plot_height],'xtick',[1970:5:max_year],'xticklabel',[],...
    'ytick',[min_ohca:20:max_ohca])
axis([min_year max_year min_ohca max_ohca])
% plot([1967 2016],[-99.99 -99.99],'k-');
% plot([2011.99 2011.99],[-100 175],'k-');

text(1994.5,200,'(a)','Fontsize',16,'Fontname','Arial','Fontweight','Bold')


ylabel('0-700 m OHC (ZJ)','Fontsize',16,'Fontname','Arial')



axes
save_ascii_oco_hc_2022_tuna
% compute the deep OHCA curves


%compute offsett

load([path_curves,'tim_hc_2022_deep.mat'], 'tim_hc_deep', 'tim_time_deep', 'tim_se_deep')
% load /Volumes/ThunderBay/Data/Globalhc/SAL/Floats/tim_hc_2016_deep_pen.mat tim_hc_deep_pen tim_time_deep_pen tim_se_deep_pen


load([path_curves,'ishii_hc_2022_deep.mat'],'ishii_hc_deep', 'ishii_time_deep', 'ishii_se_deep')
% tim_hc_deep=hc_one_deep';
% tim_time_deep=time_deep;
% tim_se_deep=hc_se_deep;
load([path_curves,'cheng_hc_2022_deep.mat'], 'cheng_hc_deep', 'cheng_time_deep','cheng_se_deep')

load([path_curves,'simon_hc_2022_deep.mat'], 'simon_hc_deep', 'simon_time_deep', 'simon_se_deep')

%load /Volumes/ThunderBay/Data/Globalhc/SAL/Floats/ishii_hc_2016_deep.mat ishii_hc_deep ishii_time_deep ishii_se_deep

% select the part you want to plotk

pos_ishii_deep=find(ishii_time_deep> min_year_deep );
pos_tim_deep=find(tim_time_deep> min_year_deep);
pos_cheng_deep=find(cheng_time_deep> min_year_deep );
pos_simon_deep=find(simon_time_deep> min_year_deep );

% pos_tim_deep_pen=find(tim_time_deep_pen> min_year_deep);
pos_deep=find(time_deep> min_year_deep);

ishii_hc_deep=ishii_hc_deep(pos_ishii_deep);
ishii_time_deep=ishii_time_deep(pos_ishii_deep);
ishii_se_deep=ishii_se_deep(pos_ishii_deep);


tim_hc_deep=tim_hc_deep(pos_tim_deep);
tim_time_deep=tim_time_deep(pos_tim_deep);
tim_se_deep=tim_se_deep(pos_tim_deep);

cheng_hc_deep=cheng_hc_deep(pos_cheng_deep);
cheng_time_deep=cheng_time_deep(pos_cheng_deep);
cheng_se_deep=cheng_se_deep(pos_cheng_deep);

simon_hc_deep=simon_hc_deep(pos_simon_deep);
simon_time_deep=simon_time_deep(pos_simon_deep);
simon_se_deep=simon_se_deep(pos_simon_deep);


% tim_hc_deep_pen=tim_hc_deep_pen(pos_tim_deep_pen);
% tim_time_deep_pen=tim_time_deep_pen(pos_tim_deep_pen);
% tim_se_deep_pen=tim_se_deep_pen(pos_tim_deep_pen);


hc_one_deep=hc_one_deep(pos_deep);
time_deep=time_deep(pos_deep);
hc_se_deep=hc_se_deep(pos_deep);

%
save([path_curves,'pmel_hc_2022_deep.mat'], 'hc_one_deep', 'time_deep', 'hc_se_deep')


pos_ishii_deep_off=find(ishii_time_deep> 2004  & ishii_time_deep <=max_year_deep);
ishii_hc_deep=ishii_hc_deep-nanmean(ishii_hc_deep(pos_ishii_deep_off));

pos_cheng_deep_off=find(cheng_time_deep> 2004  & cheng_time_deep <=max_year_deep);
cheng_hc_deep=cheng_hc_deep-nanmean(cheng_hc_deep(pos_cheng_deep_off));

pos_simon_deep_off=find(simon_time_deep> 2004  & simon_time_deep <=max_year_deep);
simon_hc_deep=simon_hc_deep-nanmean(simon_hc_deep(pos_simon_deep_off));


% pos_tim_deep_pen_off=find(tim_time_deep_pen> 2004 & tim_time_deep_pen <=max_year_deep);
% tim_hc_deep_pen=tim_hc_deep_pen-nanmean(tim_hc_deep_pen(pos_tim_deep_pen_off));

pos_tim_deep_off=find(tim_time_deep> 2004 & tim_time_deep <=max_year_deep);
tim_hc_deep=tim_hc_deep-nanmean(tim_hc_deep(pos_tim_deep_off));

pos_deep_off=find(time_deep> 2004 & time_deep <=max_year_deep);
hc_one_deep=hc_one_deep-nanmean(hc_one_deep(pos_deep_off));

% hc_all=[hc_one_deep';tim_hc_deep;ishii_hc_deep;cheng_hc_deep;simon_hc_deep];
hc_all=[hc_one_deep(1)';tim_hc_deep(1);ishii_hc_deep(1);cheng_hc_deep(1);simon_hc_deep(1)];

offset=nanmean(hc_all);

simon_hc_deep=simon_hc_deep-offset;
cheng_hc_deep=cheng_hc_deep-offset;
ishii_hc_deep=ishii_hc_deep-offset;
hc_one_deep=hc_one_deep-offset;
tim_hc_deep=tim_hc_deep-offset;
% tim_hc_deep_pen=tim_hc_deep_pen-offset;


% % % abocean_year=[1992.5:2009.5];  
% % % 
% % % ind=find(abocean_year>1992);
% % % temp_abocean_heat(ind)=35e12*24*3600*365.25;
% % % temp_abocean_unct(ind)=11e12*24*3600*365.25;


abocean_year=[1992.0939:2010.3223];
abocean_year=[1992.7:2011.4];
abocean_year=[1992.4282:2011.5194];
abocean_year=[1992.4282:2011.6416];
abocean_year=[1992.7:2012];
abocean_year=[1992.7:2013];
area_of_earth=5.1e14;
abo_wm2=0.0438;
abo_wm2=0.0693;
abo_wm2=0.0637;
abo_wm2=0.0639;
abo_wm2=0.071;
abo_wm2=0.0725;
dof_abo=1054;
% abo_wm2_unct is a standard error
abo_wm2_unct=0.0384./student90(dof_abo);
abo_wm2_unct=0.0233;
abo_wm2_unct=0.0214;
abo_wm2_unct=0.0194;
abo_wm2_unct=0.0194;
abo_wm2_unct=0.0193;
abo_wm2_unct=0.0192;
ind=find(abocean_year>1992);
temp_abocean_heat(ind)=abo_wm2*24*3600*365.25*area_of_earth;
temp_abocean_unct(ind)=abo_wm2_unct*24*3600*365.25*area_of_earth;

% now get the index years

ind=1;

len=length(abocean_year);

% accumulate abyssal ocean heat and uncertainties out from index year,
% assuming errors are correlated since they are on the trend 

abocean_unct(ind)=0;
abocean_heat(ind)=0;
abocean_unct(ind+1:len)=cumsum(temp_abocean_unct(ind+1:len));
abocean_heat(ind+1:len)=cumsum(temp_abocean_heat(ind+1:len));
abocean_unct(1:ind-1)=fliplr(cumsum(fliplr((temp_abocean_unct(1:ind-1)))));
% abocean_unct=fliplr(abocean_unct);
abocean_heat(1:ind-1)=fliplr(cumsum(fliplr((-temp_abocean_heat(1:ind-1)))));

abocean_heat=abocean_heat/1e21;
abocean_unct=abocean_unct/1e21;


%plot deep curves

c4=[0, 52, 102]/255;
jab=patch([abocean_year,fliplr(abocean_year)],[abocean_heat+abocean_unct,fliplr(abocean_heat-abocean_unct)],c4);
hold on
set(jab,'Edgecolor',c4)
pi=plot(ishii_time_deep,ishii_hc_deep,'-*','color',mycor(5,:));
ei=errorbar(ishii_time_deep,ishii_hc_deep,ishii_se_deep,'color',mycor(5,:));set(ei,'linewidth',3);

psi=plot(simon_time_deep,simon_hc_deep,'-*','color',mycor(4,:));
esi=errorbar(simon_time_deep,simon_hc_deep,simon_se_deep,'color',mycor(4,:));set(esi,'linewidth',3);


pch=plot(cheng_time_deep,cheng_hc_deep,'-*','color',mycor(6,:));
ech=errorbar(cheng_time_deep,cheng_hc_deep,cheng_se_deep,'color',mycor(6,:));set(ech,'linewidth',3);

% % % ptp=plot(tim_time_deep_pen,tim_hc_deep_pen,'-*','color',mycor(3,:));
% % % etp=errorbar(tim_time_deep_pen,tim_hc_deep_pen,tim_se_deep_pen,'color',mycor(3,:));set(etp,'linewidth',3);

pt=plot(tim_time_deep,tim_hc_deep,'-*','color',mycor(3,:));
et=errorbar(tim_time_deep,tim_hc_deep,tim_se_deep,'color',mycor(3,:));set(et,'linewidth',3);


p2=plot(time_deep,hc_one_deep,'-*','color',mycor(1,:));
e=errorbar(time_deep,hc_one_deep,hc_se_deep,'color',mycor(1,:));set(e,'linewidth',3);
save_ascii_oco_hc_deep_2020
% pt_2=plot(tim_time,tim_hc,'-*','color',mycor(3,:));
% hold on
plot([min_year-1 max_year+1],[0 0],'k')
max_ohca=max_ohca_deep;
min_ohca=min_ohca_deep;
% scale_plot=.16./100;
% plot_height=(max_ohca-min_ohca)*scale_plot;

set(gca,'tickdir','out','Fontsize',16,'Fontname','Arial','box','on','pos',[.15 plot_height_deep_0 .75 plot_height_deep],'xtick',[1970:5:max_year],'XAxisLocation','bottom',...
    'ytick',[min_ohca:20:max_ohca])
axis([min_year max_year min_ohca max_ohca])
%plot([min_year max_year],[-49.99 -49.99],'k-');
axis([min_year max_year min_ohca max_ohca])
ylabel('Deep OHC (ZJ)','Fontsize',16,'Fontname','Arial')
xlabel('Time (yr)','Fontsize',16,'Fontname','Arial')
%xlabel('Time (yr)','Fontsize',11,'Fontname','Arial')
text(1994.5,95,'(b)','Fontsize',16,'Fontname','Arial','Fontweight','Bold') 
%hh=legend('700-2000 m','2000-6000 m','location','SouthEast');
%set(hh,'Fontsize',11,'Fontname','Arial')

% offset_axis=1;
%  text_off=9-offset_axis;
%   text_off=text_off*10;
%   text_del=1;
%   text_del=text_del*10;
   year_text=2011;
%   text_size=12;
  text_off=-61;

text(year_text,text_off+text_del*1,'z > 2000 m','color',c4,'FontName','Arial','FontSize',text_size)
  plot([year_text-2 year_text-1],[text_off+text_del*1 text_off+text_del*1],'color',c4,'linewidth',3)

  text(year_text,text_off+text_del*2,'700m > z > 2000m','color',mycor(6,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*2 text_off+text_del*2],'color',mycor(6,:),'linewidth',3)
  
text(year_text,text_off+text_del*3,'700m > z > 2000m ','color',mycor(3,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*3 text_off+text_del*3],'color',mycor(3,:),'linewidth',3)

% text(year_text,text_off+text_del*5,'Nature 1993-2008','color',mycor(2,:),'FontName','Arial','FontSize',text_size)
% plot([year_text-2 year_text-1],[text_off+text_del*5 text_off+text_del*5],'color',mycor(2,:),'linewidth',2)

text(year_text,text_off+text_del*4,'700m > z > 2000m','color',mycor(1,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*4 text_off+text_del*4],'color',mycor(1,:),'linewidth',3)


text(year_text,text_off+text_del*5,'700m > z > 2000m','color',mycor(5,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*5 text_off+text_del*5],'color',mycor(5,:),'linewidth',3)

text(year_text,text_off+text_del*6,'700m > z > 2000m','color',mycor(4,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*6 text_off+text_del*6],'color',mycor(4,:),'linewidth',3)

% 
  eval(['print -dpng -r600 -f3 ',path_figs,'curve_oco_new5_',num2str(year_of_oco_pub)])
%     eval(['print -depsc2 -f3 ',path_figs,'curve_oco_2022'])
% 
%       eval(['print  -dtiff -r600 -f3 ',path_figs,'curve_oco_2022'])
%       eval(['print  -dpng -r600 -f3 ',path_figs,'curve_oco_2022'])

%   eval(['print -dpdf -f3 /Users/lyman/figs/oco/Oceans/curve_oco_2016_topo_2_panel_NCEI'])
% % eval(['print -depsc2 -r300 -f3 /Users/lyman/figs/oco/Oceans/curve_oco_2016_topo'])
% eval(['print -dtiff -r300 -f3 /Users/lyman/figs/oco/Oceans/curve_oco_2016_topo'])
% %%
% 
 warming_rates_oco_deep
% %compute the slope of the line
% warming_rates_oco_deep_argo
