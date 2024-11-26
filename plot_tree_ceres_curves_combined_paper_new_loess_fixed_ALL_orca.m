clearvars
close all

mycor=[228,26,28 
    55,126,184
    77,175,74
    152,78,163
    255,127,0
    55,78,0]./255;
mycor=[228,26,28 
    55,126,184
    77,175,74
    152,78,163
    255,127,0
    0,100,100]./255;

min_year=2008;
max_year=2022;
  
path_fileG= 'D:\data\Roemmich_Gilson_Clim\';
path_figs='D:\data\OHCA\figs\tree_paper\';
 path_file='D:\data\OHCA\OPEN\';

% load([path_file,'RG_ArgoClim_heatcurve_all2.mat'],'ht_curve_gilson','time_gilson')
% load([path_fileG,'RG_ArgoClim_heatcurve_all.mat'],'ht_curve_gilson','time_gilson')
% load([path_file,'IAP_OHCA_0_2000_cycle.mat'],'ohca','yr')
% ht_curve_gilson=ohca';
% time_gilson=yr;
name_comp_all='ALL';

%%

% eval([name_comp,'_rate=gilson_rate;'])
% eval([name_comp,'_rate_qu=gilson_rate_qu;'])
% eval([name_comp,'_rate_year_no_cycle=gilson_rate_year_no_cycle;'])
% eval(['time_',name_comp,'_rate_year=time_gilson_rate_year;'])
% eval(['time_',name_comp,'_rate_qu=time_gilson_rate_qu;'])
% eval(['time_',name_comp,'_rate=time_gilson_rate;'])
% eval([name_comp,'_rate_cycle=gilson_rate_cycle;'])
% eval(['frac_',name_comp,'_cycle=frac_gilson_cycle;'])
%   
% load([path_figs,name_comp,'_rate.m'],...
%     [name_comp,'_rate'],[name_comp,'_rate_qu'],[name_comp,'_rate_year_no_cycle'],...
%     ['time_',name_comp,'_rate_year'],['time_',name_comp,'_rate_qu'],['time_',name_comp,'_rate'],...
%     [name_comp,'_rate_cycle'],['frac_',name_comp,'_cycle'])
load([path_figs,'tree_gilson_ceres_rate_orca.mat'])
load([path_figs,'IAP_rate.mat'])
load([path_figs,'NCEI_rate.mat'])
load([path_figs,'OPEN_rate.mat'])
load([path_figs,'OPENLSTM_rate.mat'])
%%

figure(1)
clf;orient tall; wysiwyg_tuna

 subplot(2,1,1)
%  plot(time_NCEI_rate,NCEI_rate,'color',mycor(2,:),'LineWidth',1)

  plot(time_IAP_rate,IAP_rate,'color',mycor(3,:),'LineWidth',1)
 hold on
 plot(time_OPEN_rate,OPEN_rate,'color',mycor(6,:),'LineWidth',.5)
 plot(time_OPEN_rate_qu,OPEN_rate_qu,'color',mycor(6,:),'LineWidth',1)
 plot(time_OPENLSTM_rate,OPENLSTM_rate,'color',mycor(4,:),'LineWidth',1)
 plot(time_gilson_rate,gilson_rate,'color',mycor(5,:),'LineWidth',.5)
 plot(time_gilson_rate_qu,gilson_rate_qu,'color',mycor(5,:),'LineWidth',1)
 
 
plot(time_rate_tree_all_mon,rate_mon_all,'k','LineWidth',.5)
plot(time_rate_tree_all_qu,rate_qu_all,'k','LineWidth',2)
plot(toa_time,toa,'color',mycor(1,:),'LineWidth',2)
plot(toa_time,toa_qu_all,'color',mycor(1,:),'LineWidth',.5)
hold on

% text(2009,-30,['OPEN ratio= ',num2str(round(frac_gilson_all))],'color',mycor(4,:),'fontsize',8)
% text(2009,-35,['RFROM ratio= ',num2str(round(frac_tree_all))],'color','k','fontsize',8)
text(2008.5,36,'(a)')
ylabel('W m^{-2}','Fontsize',10,'Fontname','Arial')
set(gca,'tickdir','out','Fontname','Arial','box','on')
year_text=2018;
text_del=5;
%   text_del=text_del*10;
  
  text_size=12;
  text_off=-52;
text(year_text,text_off+text_del*4,'OPEN-LSTM','color',mycor(4,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*4 text_off+text_del*4],'color',mycor(4,:),'linewidth',1.5)

text(year_text,text_off+text_del*3,'RFROM','color','k','FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*3 text_off+text_del*3],'color','k','linewidth',1.5)

text(year_text,text_off+text_del*2,'CERES','color',mycor(1,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*2 text_off+text_del*2],'color',mycor(1,:)','linewidth',1.5)


year_text=2012

text(year_text,text_off+text_del*4,'OPEN','color',mycor(6,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*4 text_off+text_del*4],'color',mycor(6,:),'linewidth',1.5)

text(year_text,text_off+text_del*3,'IAP','color',mycor(3,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*3 text_off+text_del*3],'color',mycor(3,:),'linewidth',1.5)

text(year_text,text_off+text_del*2,'RG09','color',mycor(5,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*2 text_off+text_del*2],'color',mycor(5,:)','linewidth',1.5)
% 
% plot(time_rate_tree_all_mon,rate_mon_all_cycle,'k')
% hold on
% plot(toa_time,cycle_toa,'color',mycor(4,:))
% plot(time_gilson_rate,gilson_rate_cycle,'color',mycor(4,:))
% text(2009,-10,['RG ratio= ',num2str(round(frac_gilson_cycle))],'color',mycor(4,:),'fontsize',6)
% text(2009,-15,['FM ratio= ',num2str(round(frac_tree_cycle))],'color','k','fontsize',6)
% text(2008.3,8,'b)')
% subplot(2,1,2)
% plot(time_rate_tree_all_mon,rate_mon_all_no_cycle,'k','LineWidth',1.25)
% hold on
% plot(toa_time,res_rate_toa,'color',mycor(1,:),'LineWidth',1.25)
% plot(time_gilson_rate,gilson_rate_no_cycle,'color',mycor(4,:),'LineWidth',1.25)
% text(2009,-25,['RG ratio= ',num2str(round(frac_gilson_mon))],'color',mycor(4,:),'fontsize',8)
% text(2009,-30,['FM ratio= ',num2str(round(frac_tree_mon))],'color','k','fontsize',8)
% text(2008.6,18,'b)')
% ylabel('W m^{-2}','Fontsize',10,'Fontname','Arial')
% subplot(4,1,3)
% plot(time_rate_tree_all_qu,rate_qu_all_no_cycle,'k','LineWidth',1.25)
% hold on
% plot(toa_time,toa_qu,'color',mycor(1,:),'LineWidth',1.25)
% plot(time_gilson_rate_qu,gilson_rate_qu_no_cycle,'color',mycor(4,:),'LineWidth',1.25)
% text(2009,-7,['RG ratio= ',num2str(round(frac_gilson_qu))],'color',mycor(4,:),'fontsize',8)
% text(2009,-8.5,['FM ratio= ',num2str(round(frac_tree_qu))],'color','k','fontsize',8)
% text(2008.6,8,'c)')
% ylabel('W m^{-2}','Fontsize',10,'Fontname','Arial')
subplot(2,1,2)
delt_tsm=1/2;
delt_tsm=1;

plot_pos_tree_year=time_rate_tree_all_year>=min_year+delt_tsm&time_rate_tree_all_year<=max_year-delt_tsm;
plot_pos_gilson_year=time_gilson_rate_year>=min_year+delt_tsm&time_gilson_rate_year<=max_year-delt_tsm;
plot_pos_toa_year=toa_time>=min_year+delt_tsm&toa_time<=max_year-delt_tsm;
plot_pos_IAP_year=time_IAP_rate_year>=min_year+delt_tsm&time_IAP_rate_year<=max_year-delt_tsm;
plot_pos_OPEN_year=time_OPEN_rate_year>=min_year+delt_tsm&time_OPEN_rate_year<=max_year-delt_tsm;
plot_pos_OPENLSTM_year=time_OPENLSTM_rate_year>=min_year+delt_tsm&time_OPENLSTM_rate_year<=max_year-delt_tsm;
plot_pos_NCEI_year=time_NCEI_rate_year>=min_year+delt_tsm&time_NCEI_rate_year<=max_year-delt_tsm;

plot(time_NCEI_rate_year(plot_pos_NCEI_year),NCEI_rate_year_no_cycle(plot_pos_NCEI_year),'color',mycor(2,:),'LineWidth',1)
hold on
plot(time_IAP_rate_year(plot_pos_IAP_year),IAP_rate_year_no_cycle(plot_pos_IAP_year),'color',mycor(3,:),'LineWidth',1)
plot(time_OPEN_rate_year(plot_pos_OPEN_year),OPEN_rate_year_no_cycle(plot_pos_OPEN_year),'color',mycor(6,:),'LineWidth',1)
plot(time_OPENLSTM_rate_year(plot_pos_OPENLSTM_year),OPENLSTM_rate_year_no_cycle(plot_pos_OPENLSTM_year),'color',mycor(4,:),'LineWidth',1)
plot(time_gilson_rate_year(plot_pos_gilson_year),gilson_rate_year_no_cycle(plot_pos_gilson_year),'color',mycor(5,:),'LineWidth',1)
plot(time_rate_tree_all_year(plot_pos_tree_year),rate_year_all_no_cycle(plot_pos_tree_year),'k','LineWidth',2)

plot(toa_time(plot_pos_toa_year),toa_yearly(plot_pos_toa_year),'color',mycor(1,:),'LineWidth',2)

%% 
year_text=2014;
text_del=5;
%   text_del=text_del*10;
  
  text_size=12;
  text_off=-6.5;
text(year_text,text_off+text_del,'NCEI','color',mycor(2,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del text_off+text_del],'color',mycor(2,:)','linewidth',1.5)
%% 

set(gca,'tickdir','out','Fontname','Arial','box','on')
% text(2009,-.5,['OPEN ratio= ',num2str(round(frac_gilson_year))],'color',mycor(4,:),'fontsize',8)
% text(2009,-.7,['RFROM ratio= ',num2str(round(frac_tree_year))],'color','k','fontsize',8)
text(2008.6,3,'(b)')
ylabel('W m^{-2}','Fontsize',10,'Fontname','Arial')
% toa_gilson=interp1(toa_time,toa_yearly,time_gilson_rate_year);
% toa_tree=interp1(toa_time,toa_yearly,time_rate_tree_all_year);
% 
% corr(toa_tree(plot_pos_tree_year&isfinite(toa_tree))',rate_year_all_no_cycle(plot_pos_tree_year&isfinite(toa_tree))')
% corr(toa_gilson(plot_pos_gilson_year),gilson_rate_year_no_cycle(plot_pos_gilson_year))

 eval(['print -dpng -r600 -f1 ',path_figs,'toa_tree_',name_comp_all,'_ceres2_loess_orca'])

figure(2)
clf;orient landscape; wysiwyg_tuna
good_tree_cycle=find(time_rate_tree_all_mon>=2008 & time_rate_tree_all_mon<2010);
good_gilson_cycle=find(time_gilson_rate>=2008 & time_gilson_rate<2010);
good_IAP_cycle=find(time_IAP_rate>=2008 & time_IAP_rate<2010);
good_OPEN_cycle=find(time_OPEN_rate>=2008 & time_OPEN_rate<2010);
good_OPENLSTM_cycle=find(time_OPENLSTM_rate>=2008 & time_OPENLSTM_rate<2010);
good_NCEI_cycle=find(time_NCEI_rate>=2008 & time_NCEI_rate<2010);




clf
toa_gilson_cycle=interp1(toa_time,cycle_toa,time_gilson_rate);
toa_tree_cycle=interp1(toa_time,cycle_toa,time_rate_tree_all_mon);
% plot(time_NCEI_rate(good_NCEI_cycle),NCEI_rate_cycle(good_NCEI_cycle),'color',mycor(2,:),'LineWidth',1)
% hold on
plot(time_IAP_rate(good_IAP_cycle),IAP_rate_cycle(good_IAP_cycle),'color',mycor(3,:),'LineWidth',1)
hold on
plot(time_OPEN_rate(good_OPEN_cycle),OPEN_rate_cycle(good_OPEN_cycle),'color',mycor(6,:),'LineWidth',1)
plot(time_OPENLSTM_rate(good_OPENLSTM_cycle),OPENLSTM_rate_cycle(good_OPENLSTM_cycle),'color',mycor(4,:),'LineWidth',1)




plot(time_gilson_rate(good_gilson_cycle),gilson_rate_cycle(good_gilson_cycle),'color',mycor(5,:),'LineWidth',1)
plot(time_rate_tree_all_mon(good_tree_cycle),toa_tree_cycle(good_tree_cycle),'color',mycor(1,:),'LineWidth',2)
plot(time_rate_tree_all_mon(good_tree_cycle),rate_mon_all_cycle(good_tree_cycle),'k','LineWidth',2)

ttl=['J','F','M','A','M','J','J','A','S','O','N','D'];
 ttt=[2008:1/12:2010-1/12]+1/24;
set(gca,'tickdir','out','Fontsize',16,'Fontname','Arial','box','on','xtick',ttt+1/24,'xticklabel',ttl','XTickLabelRotation',0)
ylabel('W m^{-2}','Fontsize',16,'Fontname','Arial')


year_text=2009.85;
text_del=2;
%   text_del=text_del*10;
  
  text_size=11;
  text_off=-19;
% text(year_text-.95,text_off+text_del*4,'RG09','color',mycor(4,:),'FontName','Arial','FontSize',text_size)
% plot([year_text-1.1 year_text-1],[text_off+text_del*4 text_off+text_del*4],'color',mycor(4,:),'linewidth',2)
% 
% text(year_text-.95,text_off+text_del*3,'RFROM','color','k','FontName','Arial','FontSize',text_size)
% plot([year_text-1.1 year_text-1],[text_off+text_del*3 text_off+text_del*3],'color','k','linewidth',2)
% 
% text(year_text-.95,text_off+text_del*2,'CERES','color',mycor(1,:),'FontName','Arial','FontSize',text_size)
% plot([year_text-1.1 year_text-1],[text_off+text_del*2 text_off+text_del*2],'color',mycor(1,:)','linewidth',2)


text(year_text-.95,text_off+text_del*4,'OPEN-LSTM','color',mycor(4,:),'FontName','Arial','FontSize',text_size)
plot([year_text-1.1 year_text-1],[text_off+text_del*4 text_off+text_del*4],'color',mycor(4,:),'linewidth',1.5)

text(year_text-.95,text_off+text_del*3,'RFROM','color','k','FontName','Arial','FontSize',text_size)
plot([year_text-1.1 year_text-1],[text_off+text_del*3 text_off+text_del*3],'color','k','linewidth',1.5)

text(year_text-.95,text_off+text_del*2,'CERES','color',mycor(1,:),'FontName','Arial','FontSize',text_size)
plot([year_text-1.1 year_text-1],[text_off+text_del*2 text_off+text_del*2],'color',mycor(1,:)','linewidth',1.5)
% 
% text(year_text-.95,text_off+text_del,'NCEI','color',mycor(2,:),'FontName','Arial','FontSize',text_size)
% plot([year_text-1.1 year_text-1],[text_off+text_del text_off+text_del],'color',mycor(2,:)','linewidth',1.5)



text(year_text-.95,text_off+text_del*5,'OPEN','color',mycor(6,:),'FontName','Arial','FontSize',text_size)
plot([year_text-1.1 year_text-1],[text_off+text_del*5 text_off+text_del*5],'color',mycor(6,:),'linewidth',1.5)

text(year_text-.95,text_off+text_del*6,'IAP','color',mycor(3,:),'FontName','Arial','FontSize',text_size)
plot([year_text-1.1 year_text-1],[text_off+text_del*6 text_off+text_del*6],'color',mycor(3,:),'linewidth',1.5)

text(year_text-.95,text_off+text_del*7,'RG09','color',mycor(5,:),'FontName','Arial','FontSize',text_size)
plot([year_text-1.1 year_text-1],[text_off+text_del*7 text_off+text_del*7],'color',mycor(5,:)','linewidth',1.5)

path_figs='D:\data\OHCA\figs\tree_paper\'
 eval(['print -dpng -r600 -f2 ',path_figs,'toa_tree_',name_comp_all,'_ceres_cycle_new_loess_orca'])
