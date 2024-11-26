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
     
     mycor=[27,158,119
217,95,2
117,112,179
231,41,138
124.9500,25.5000,86.7000]./255;

mycor=[228,26,28 
    55,126,184
    77,175,74
    152,78,163
    255,127,0 ]./255;

% global integrals of heat content and storage
cd /Volumes/ThunderBay/Data/Globalhc/HC
min_year=1993;
min_year_deep=1993;
max_year=2017;
max_year_deep=2017;
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
file_name_argo='argo_2017_1_3_QC';
min_year_mapped='1990'; % the minimum year that was used to produce the OHCA fields.
max_year_mapped='2016';% the maximumyear that was used to produece the OHCA fields.

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

span = 3; % Size of the averaging window
window = ones(span,1)/span; 
hc_one2 = convn(hc_one',window,'same');
% hc_one=hc_one2';


time=time(good_pos);
hc_one=hc_one(good_pos)/1e21;
%%
load /Volumes/ThunderBay/Data/Globalhc/SAL/Floats/simon_hc_2016
good_simon=find(simon_time> min_year);
simon_time=simon_time(good_simon);
simon_se=simon_se(good_simon);
simon_hc=simon_hc(good_simon);

load /Volumes/ThunderBay/Data/Globalhc/SAL/Floats/tim_hc_2016
good_tim=find(tim_time> min_year);
tim_time=tim_time(good_tim);
tim_se=tim_se(good_tim);
tim_hc=tim_hc(good_tim);

load /Volumes/ThunderBay/Data/Globalhc/SAL/Floats/ishii_hc_2016
good_ishii=find(ishii_time> min_year);
ishii_time=ishii_time(good_ishii);
ishii_se=ishii_se(good_ishii);
ishii_hc=ishii_hc(good_ishii);

load /Volumes/ThunderBay/Data/Globalhc/SAL/Floats/catia_hc_2016
good_catia=find(catia_time> min_year);
catia_time=catia_time(good_catia);
catia_se=catia_se(good_catia);
catia_hc=catia_hc(good_catia);

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

hc_all=[hc_one';tim_hc;simon_hc;catia_hc;ishii_hc];
hc_all=[hc_one(1)';tim_hc(1);simon_hc(1);catia_hc(1);ishii_hc(1)];

offset=nanmean(hc_all);


hc_one=hc_one-offset;
tim_hc=tim_hc-offset;
simon_hc=simon_hc-offset;
catia_hc=catia_hc-offset;
ishii_hc=ishii_hc-offset;


%%     
figure(3); clf;orient tall; wysiwyg


pi=plot(ishii_time,ishii_hc,'-*','color',mycor(5,:));
ei=errorbar(ishii_time,ishii_hc,ishii_se,'color',mycor(5,:));set(ei,'linewidth',3);
hold on

hold on
ps=plot(simon_time,simon_hc,'-*','color',mycor(4,:));
es=errorbar(simon_time,simon_hc,simon_se,'color',mycor(4,:));set(es,'linewidth',3);
hold on
p2=plot(time,hc_one,'-*','color',mycor(1,:));
e=errorbar(time,hc_one,hc_se,'color',mycor(1,:));set(e,'linewidth',3);


pt=plot(tim_time,tim_hc,'-*','color',mycor(3,:));
et=errorbar(tim_time,tim_hc,tim_se,'color',mycor(3,:));set(et,'linewidth',3);
hold on
pc=plot(catia_time,catia_hc,'-*','color',mycor(2,:));
ec=errorbar(catia_time,catia_hc,catia_se,'color',mycor(2,:));set(ec,'linewidth',3);




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
  text_off=-61;
  
text(year_text,text_off+text_del*1,'Met Office Hadley Centre ','color',mycor(4,:),'FontName','Arial','FontSize',text_size)
  

 plot([year_text-2 year_text-1],[text_off+text_del*1 text_off+text_del*1],'color',mycor(4,:),'linewidth',3)


% text(year_text,text_off+text_del*3,'PMEL/JPL/JIMAR (0-750m)','color',mycor(5,:),'FontName','Arial','FontSize',text_size)
% plot([year_text-2 year_text-1],[text_off+text_del*3 text_off+text_del*3],'color',mycor(5,:),'linewidth',2)

text(year_text,text_off+text_del*2,'NCEI ','color',mycor(3,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*2 text_off+text_del*2],'color',mycor(3,:),'linewidth',3)

% text(year_text,text_off+text_del*5,'Nature 1993-2008','color',mycor(2,:),'FontName','Arial','FontSize',text_size)
% plot([year_text-2 year_text-1],[text_off+text_del*5 text_off+text_del*5],'color',mycor(2,:),'linewidth',2)

text(year_text,text_off+text_del*3,'PMEL/JPL/JIMAR ','color',mycor(1,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*3 text_off+text_del*3],'color',mycor(1,:),'linewidth',3)

text(year_text,text_off+text_del*4,'CSIRO/ACE CRC/IMAS-UTAS ','color',mycor(2,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*4 text_off+text_del*4],'color',mycor(2,:),'linewidth',3)

text(year_text,text_off+text_del*5,'MRI/JMA ','color',mycor(5,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*5 text_off+text_del*5],'color',mycor(5,:),'linewidth',3)

%e1=errorbar(time_argo,hc_one_argo,error_argo);set(e1,'linewidth',2)
%e2=errorbar(time_no_argo,hc_one_no_argo,error_no_argo,'r');set(e2,'linewidth',2)
%e3=errorbar(time,hc_one,error_all,'k');set(e3,'linewidth',2)

%plot the x-axis

plot([min_year-1 max_year+1],[0 0],'k')

off2=25;
max_ohca=175-off2;
min_ohca=-100-off2 ;

max_ohca=160;
min_ohca=-60 ;

scale_plot=.16./100;
plot_height=(max_ohca-min_ohca)*scale_plot;



set(gca,'tickdir','out','Fontsize',16,'Fontname','Arial','box','on','pos',[.15 .5 .75 plot_height],'xtick',[1970:5:max_year],'xticklabel',[],...
    'ytick',[min_ohca:20:max_ohca])
axis([min_year max_year min_ohca max_ohca])
% plot([1967 2016],[-99.99 -99.99],'k-');
% plot([2011.99 2011.99],[-100 175],'k-');

text(1994.5,135,'(a)','Fontsize',16,'Fontname','Arial','Fontweight','Bold')


ylabel('0-700 m OHC (ZJ)','Fontsize',16,'Fontname','Arial')



axes
save_ascii_oco_hc_2016
% compute the deep OHCA curves


%compute offsett

load /Volumes/ThunderBay/Data/Globalhc/SAL/Floats/tim_hc_2017_deep.mat tim_hc_deep tim_time_deep tim_se_deep
% load /Volumes/ThunderBay/Data/Globalhc/SAL/Floats/tim_hc_2016_deep_pen.mat tim_hc_deep_pen tim_time_deep_pen tim_se_deep_pen


load /Volumes/ThunderBay/Data/Globalhc/SAL/Floats/ishii_hc_2016_deep.mat ishii_hc_deep ishii_time_deep ishii_se_deep
% tim_hc_deep=hc_one_deep';
% tim_time_deep=time_deep;
% tim_se_deep=hc_se_deep;


%load /Volumes/ThunderBay/Data/Globalhc/SAL/Floats/ishii_hc_2016_deep.mat ishii_hc_deep ishii_time_deep ishii_se_deep

% select the part you want to plotk

pos_ishii_deep=find(ishii_time_deep> min_year_deep );
pos_tim_deep=find(tim_time_deep> min_year_deep);
% pos_tim_deep_pen=find(tim_time_deep_pen> min_year_deep);
pos_deep=find(time_deep> min_year_deep);

ishii_hc_deep=ishii_hc_deep(pos_ishii_deep);
ishii_time_deep=ishii_time_deep(pos_ishii_deep);
ishii_se_deep=ishii_se_deep(pos_ishii_deep);


tim_hc_deep=tim_hc_deep(pos_tim_deep);
tim_time_deep=tim_time_deep(pos_tim_deep);
tim_se_deep=tim_se_deep(pos_tim_deep);

% tim_hc_deep_pen=tim_hc_deep_pen(pos_tim_deep_pen);
% tim_time_deep_pen=tim_time_deep_pen(pos_tim_deep_pen);
% tim_se_deep_pen=tim_se_deep_pen(pos_tim_deep_pen);


hc_one_deep=hc_one_deep(pos_deep);
time_deep=time_deep(pos_deep);
hc_se_deep=hc_se_deep(pos_deep);

%



pos_ishii_deep_off=find(ishii_time_deep> 2004  & ishii_time_deep <=max_year_deep);
ishii_hc_deep=ishii_hc_deep-nanmean(ishii_hc_deep(pos_ishii_deep_off));


% pos_tim_deep_pen_off=find(tim_time_deep_pen> 2004 & tim_time_deep_pen <=max_year_deep);
% tim_hc_deep_pen=tim_hc_deep_pen-nanmean(tim_hc_deep_pen(pos_tim_deep_pen_off));

pos_tim_deep_off=find(tim_time_deep> 2004 & tim_time_deep <=max_year_deep);
tim_hc_deep=tim_hc_deep-nanmean(tim_hc_deep(pos_tim_deep_off));

pos_deep_off=find(time_deep> 2004 & time_deep <=max_year_deep);
hc_one_deep=hc_one_deep-nanmean(hc_one_deep(pos_deep_off));

hc_all=[hc_one_deep';tim_hc_deep;ishii_hc_deep];
hc_all=[hc_one_deep(1)';tim_hc_deep(1);ishii_hc_deep(1)];

offset=nanmean(hc_all);

ishii_hc_deep=ishii_hc_deep-offset;
hc_one_deep=hc_one_deep-offset;
tim_hc_deep=tim_hc_deep-offset;
% tim_hc_deep_pen=tim_hc_deep_pen-offset;


abocean_year=[1992.5:2009.5];  

ind=find(abocean_year>1992);
temp_abocean_heat(ind)=35e12*24*3600*365.25;
temp_abocean_unct(ind)=11e12*24*3600*365.25;

% now get the index year

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


% % % ptp=plot(tim_time_deep_pen,tim_hc_deep_pen,'-*','color',mycor(3,:));
% % % etp=errorbar(tim_time_deep_pen,tim_hc_deep_pen,tim_se_deep_pen,'color',mycor(3,:));set(etp,'linewidth',3);

pt=plot(tim_time_deep,tim_hc_deep,'-*','color',mycor(3,:));
et=errorbar(tim_time_deep,tim_hc_deep,tim_se_deep,'color',mycor(3,:));set(et,'linewidth',3);


p2=plot(time_deep,hc_one_deep,'-*','color',mycor(1,:));
e=errorbar(time_deep,hc_one_deep,hc_se_deep,'color',mycor(1,:));set(e,'linewidth',3);

% pt_2=plot(tim_time,tim_hc,'-*','color',mycor(3,:));
% hold on
plot([min_year-1 max_year+1],[0 0],'k')
max_ohca=100;
min_ohca=-60;
scale_plot=.16./100;
plot_height=(max_ohca-min_ohca)*scale_plot;

set(gca,'tickdir','out','Fontsize',16,'Fontname','Arial','box','on','pos',[.15 .26-.04 .75 plot_height],'xtick',[1970:5:max_year],'XAxisLocation','bottom',...
    'ytick',[min_ohca:20:max_ohca])
axis([min_year max_year min_ohca max_ohca])
%plot([min_year max_year],[-49.99 -49.99],'k-');
axis([min_year max_year min_ohca max_ohca])
ylabel('Deep OHC (ZJ)','Fontsize',16,'Fontname','Arial')
xlabel('Time (yr)','Fontsize',16,'Fontname','Arial')
%xlabel('Time (yr)','Fontsize',11,'Fontname','Arial')
text(1994.5,80,'(b)','Fontsize',16,'Fontname','Arial','Fontweight','Bold')
%hh=legend('700-2000 m','2000-6000 m','location','SouthEast');
%set(hh,'Fontsize',11,'Fontname','Arial')

% offset_axis=1;
%  text_off=9-offset_axis;
%   text_off=text_off*10;
%   text_del=1;
%   text_del=text_del*10;
%   year_text=2007;
%   text_size=12;
  text_off=-50;

text(year_text,text_off+text_del*1,'z > 2000 m','color',c4,'FontName','Arial','FontSize',text_size)
  plot([year_text-2 year_text-1],[text_off+text_del*1 text_off+text_del*1],'color',c4,'linewidth',3)

text(year_text,text_off+text_del*2,'700m > z > 2000m ','color',mycor(3,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*2 text_off+text_del*2],'color',mycor(3,:),'linewidth',3)

% text(year_text,text_off+text_del*5,'Nature 1993-2008','color',mycor(2,:),'FontName','Arial','FontSize',text_size)
% plot([year_text-2 year_text-1],[text_off+text_del*5 text_off+text_del*5],'color',mycor(2,:),'linewidth',2)

text(year_text,text_off+text_del*3,'700m > z > 2000m','color',mycor(1,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*3 text_off+text_del*3],'color',mycor(1,:),'linewidth',3)


text(year_text,text_off+text_del*4,'700m > z > 2000m','color',mycor(5,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*4 text_off+text_del*4],'color',mycor(5,:),'linewidth',3)

% 
  eval(['print -dpng -f3 /Users/lyman/Documents/figs/oco/Oceans/curve_oco_2017_topo_2_panel_NCEI_new2'])
    eval(['print -depsc2 -f3 /Users/lyman/Documents/figs/oco/Oceans/curve_oco_2017_topo_2_panel_NCEI_new2'])

      eval(['print  -dtiff -r300 -f3 /Users/lyman/Documents/figs/oco/Oceans/curve_oco_2017_topo_2_panel_NCEI_new2'])

%   eval(['print -dpdf -f3 /Users/lyman/figs/oco/Oceans/curve_oco_2016_topo_2_panel_NCEI'])
% % eval(['print -depsc2 -r300 -f3 /Users/lyman/figs/oco/Oceans/curve_oco_2016_topo'])
% eval(['print -dtiff -r300 -f3 /Users/lyman/figs/oco/Oceans/curve_oco_2016_topo'])
% %%
% 
 warming_rates_oco_deep
% %compute the slope of the line

