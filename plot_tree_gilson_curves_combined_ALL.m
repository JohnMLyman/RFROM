
mycor=[228,26,28 
    55,126,184
    77,175,74
    152,78,163
    255,127,0
    0,100,100]./255;
name_comp='ALL';
path_figs='C:\data\OHCA\figs\tree_paper\'

min_year=1993;
max_year=2022;
min_year_cycle=2008;

load([path_figs,'tree_gilson_LJ_ohca_curves.mat'])
load([path_figs,'IAP_ohca_curves.mat'])
load([path_figs,'OPEN_ohca_curves.mat'])
load([path_figs,'OPENLSTM_ohca_curves.mat'])
load([path_figs,'NCEI_ohca_curves.mat'])



% plot(tgrid,ht_curve-nanmean(ht_curve))
%% 
figure(7)
clf;orient tall; wysiwyg_tuna
% path_curve=[path_OHCA_data_out,'OHCA_curves\'];
% load([path_curve,'test_tree_curve_yearly_7day_2000_yearly_new_error_2xweight_combined.mat'],'layer_curve_error','tgrid')
% error_0_2000=4.*nansum(layer_curve_error)./1e21;
% error_0_2000=error_0_2000(2:end);
max_ohca=110;
min_ohca=-270 ;


scale_plot=.16./100;
plot_height=(max_ohca-min_ohca)*scale_plot;


% plot(time_gilson,ht_curve_gilson-nanmean(ht_curve_gilson))
good_gilson=find(time_gilson>=min_year_cycle);
good_IAP=find(time_IAP>=min_year_cycle);
good_OPEN=find(time_OPEN>=min_year_cycle);
good_OPENLSTM=find(time_OPENLSTM>=min_year_cycle);
good_NCEI=find(time_NCEI>=min_year_cycle);
good_tree=find(time_tree_all>=min_year_cycle);

offset_gilson=nanmean(ht_gilson_no_cyce(good_gilson));
offset_IAP=nanmean(ht_IAP_no_cyce(good_IAP));
offset_OPEN=nanmean(ht_OPEN_no_cyce(good_OPEN));
offset_OPENLSTM=nanmean(ht_OPENLSTM_no_cyce(good_OPENLSTM));
offset_NCEI=nanmean(ht_NCEI_no_cyce(good_NCEI));
offset_tree=nanmean(ht_all_no_cyce(good_tree));

plot_pos_tree_year=time_tree_all>=min_year+.5&time_tree_all<=max_year-.5;
plot_pos_gilson_year=time_gilson>=min_year+.5&time_gilson<=max_year-.5;
plot_pos_IAP_year=time_IAP>=min_year+.5&time_IAP<=max_year-.5;
plot_pos_OPEN_year=time_OPEN>=min_year+.5&time_OPEN<=max_year-.5;
plot_pos_OPENLSTM_year=time_OPENLSTM>=min_year+.5&time_OPENLSTM<=max_year-.5;
plot_pos_NCEI_year=time_NCEI>=min_year+.5&time_NCEI<=max_year-.5;

plot(time_NCEI,(ht_NCEI_no_cyce-offset_NCEI)./1e21,'color',mycor(2,:),LineWidth=.5)
hold on
plot(time_NCEI(plot_pos_NCEI_year),(ht_NCEI_year_no_cyce(plot_pos_NCEI_year)-offset_NCEI)./1e21,'color',mycor(2,:),LineWidth=1)


plot(time_IAP,(ht_IAP_no_cyce-offset_IAP)./1e21,'color',mycor(3,:),LineWidth=.5)
plot(time_IAP(plot_pos_IAP_year),(ht_IAP_year_no_cyce(plot_pos_IAP_year)-offset_IAP)./1e21,'color',mycor(3,:),LineWidth=1)

plot(time_OPEN,(ht_OPEN_no_cyce-offset_OPEN)./1e21,'color',mycor(6,:),LineWidth=.5)
plot(time_OPEN(plot_pos_OPEN_year),(ht_OPEN_year_no_cyce(plot_pos_OPEN_year)-offset_OPEN)./1e21,'color',mycor(6,:),LineWidth=1)

plot(time_OPENLSTM,(ht_OPENLSTM_no_cyce-offset_OPENLSTM)./1e21,'color',mycor(4,:),LineWidth=.5)
plot(time_OPENLSTM(plot_pos_OPENLSTM_year),(ht_OPENLSTM_year_no_cyce(plot_pos_OPENLSTM_year)-offset_OPENLSTM)./1e21,'color',mycor(4,:),LineWidth=1)


plot(time_gilson,(ht_gilson_no_cyce-offset_gilson)./1e21,'color',mycor(5,:),LineWidth=.5)
plot(time_gilson(plot_pos_gilson_year),(ht_gilson_year_no_cyce(plot_pos_gilson_year)-offset_gilson)./1e21,'color',mycor(5,:),LineWidth=1)

plot(time_pmel,ohca_pmel'-nanmean(ohca_pmel(time_pmel>=min_year_cycle & time_pmel<=max_year)),'color',mycor(1,:),LineWidth=2)

plot(time_tree_all,(ht_all_no_cyce-offset_tree)./1e21,'k',LineWidth=.5)
plot(time_tree_all(plot_pos_tree_year),(ht_all_year_no_cyce(plot_pos_tree_year)-offset_tree)./1e21,'k',LineWidth=2)
% plot(time_pmel(time_pmel>=min(time_gilson)),ohca_pmel(time_pmel>=min(time_gilson))'-nanmean(ohca_pmel(time_pmel>=min_year_cycle & time_pmel<=max_year)),'color',mycor(2,:),LineWidth=2)

% sub_pos=[1:8:length(time_tree_all)];
% et=errorbar(time_tree_all(sub_pos),(ht_all_no_cyce(sub_pos)-offset_tree)./1e21,error_0_2000(sub_pos),'color','k','none');%set(et,'linewidth',3);
% et=errorbar(time_tree_all(sub_pos),(ht_all_no_cyce(sub_pos)-offset_tree)./1e21,error_0_2000(sub_pos),'k.')
% plot(time_tree_all,ht_all_no_cyce./1e21,'b')

set(gca,'tickdir','out','Fontsize',16,'Fontname','Arial','box','on','xtick',[1970:5:max_year],'XAxisLocation','bottom',...
    'ytick',[min_ohca:20:max_ohca])
year_text=2012;
text_del=1.1;
  text_del=text_del*10;
  
  text_size=15;
  text_off=-250;
text(year_text,text_off+text_del*4,'OPEN-LSTM','color',mycor(4,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*4 text_off+text_del*4],'color',mycor(4,:),'linewidth',1.5)

text(year_text,text_off+text_del*3,'RFROM','color','k','FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*3 text_off+text_del*3],'color','k','linewidth',1.5)

text(year_text,text_off+text_del*2,'LJ14','color',mycor(1,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*2 text_off+text_del*2],'color',mycor(1,:)','linewidth',1.5)

text(year_text,text_off+text_del,'NCEI','color',mycor(2,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del text_off+text_del],'color',mycor(2,:)','linewidth',1.5)


text(year_text,text_off+text_del*5,'OPEN','color',mycor(6,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*5 text_off+text_del*5],'color',mycor(6,:),'linewidth',1.5)

text(year_text,text_off+text_del*6,'IAP','color',mycor(3,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*6 text_off+text_del*6],'color',mycor(3,:),'linewidth',1.5)

text(year_text,text_off+text_del*7,'RG09','color',mycor(5,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*7 text_off+text_del*7],'color',mycor(5,:)','linewidth',1.5)

axis([min_year max_year min_ohca max_ohca])
%plot([min_year max_year],[-49.99 -49.99],'k-');
axis([min_year max_year min_ohca max_ohca])
ylabel('OHCA (ZJ)','Fontsize',16,'Fontname','Arial')
xlabel('Time (yr)','Fontsize',16,'Fontname','Arial')
%xlabel('Time (yr)','Fontsize',11,'Fontname','Arial')
% text(1994.5,95,'(b)','Fontsize',16,'Fontname','Arial','Fontweight','Bold') 
% plot(tgrid,ht_curve-nanmean(ht_curve))
 eval(['print -dpng -r600 -f7 ',path_figs,'curve_',name_comp])
% 
% pos_warm_pmel=time_pmel>2008;
%  [warming_rate_pmel_2008]=compute_warming_no_weight_3(ohca_pmel(pos_warm_pmel)'./10,hc_one_deep(pos_warm_pmel)'/1000,time_pmel(pos_warm_pmel));
% 
%  pos_warm_tree=time_tree_all>2008;
%  [warming_rate_tree_2008]=compute_warming_no_weight_3(ht_all_no_cyce(pos_warm_tree)./(10.*1e21),ht_all_no_cyce(pos_warm_tree)/(1e21.*1000),time_tree_all(pos_warm_tree));
% 
%  pos_warm_gilson=time_gilson>2008;
%  [warming_rate_gilson_2008]=compute_warming_no_weight_3(ht_gilson_no_cyce(pos_warm_gilson)'./(10.*1e21),ht_gilson_no_cyce(pos_warm_gilson)'/(1e21.*1000),time_gilson(pos_warm_gilson)');
% 
% 
%   pos_warm_tree=time_tree_all>1993 &time_tree_all<2005;
%  [warming_rate_tree_1993_2005]=compute_warming_no_weight_3(ht_all_no_cyce(pos_warm_tree)./(10.*1e21),ht_all_no_cyce(pos_warm_tree)/(1e21.*1000),time_tree_all(pos_warm_tree));
% 
%  pos_warm_pmel=time_pmel>1993 & time_pmel<2005;
%  [warming_rate_pmel_1993_2005]=compute_warming_no_weight_3(ohca_pmel(pos_warm_pmel)'./10,hc_one_deep(pos_warm_pmel)'/1000,time_pmel(pos_warm_pmel));
% 
%   pos_warm_gilson=time_gilson>1993 & time_gilson<2005;
%  [warming_rate_gilson_1993_2005]=compute_warming_no_weight_3(ht_gilson_no_cyce(pos_warm_gilson)'./(10.*1e21),ht_gilson_no_cyce(pos_warm_gilson)'/(1e21.*1000),time_gilson(pos_warm_gilson)');
% 
% 
%   pos_warm_tree=time_tree_all>1993 ;
%  [warming_rate_tree_1993]=compute_warming_no_weight_3(ht_all_no_cyce(pos_warm_tree)./(10.*1e21),ht_all_no_cyce(pos_warm_tree)/(1e21.*1000),time_tree_all(pos_warm_tree));
% 
%  pos_warm_pmel=time_pmel>1993 ;
%  [warming_rate_pmel_1993]=compute_warming_no_weight_3(ohca_pmel(pos_warm_pmel)'./10,hc_one_deep(pos_warm_pmel)'/1000,time_pmel(pos_warm_pmel));
% 
%   pos_warm_gilson=time_gilson>1993 ;
%  [warming_rate_gilson_1993]=compute_warming_no_weight_3(ht_gilson_no_cyce(pos_warm_gilson)'./(10.*1e21),ht_gilson_no_cyce(pos_warm_gilson)'/(1e21.*1000),time_gilson(pos_warm_gilson)');
% 
% 
% 
% warming_rate_pmel_1993
% warming_rate_pmel_2008
% warming_rate_pmel_1993_2005
% 
% 
% warming_rate_tree_1993
% warming_rate_tree_2008
% warming_rate_tree_1993_2005
% 
% 
% name_comp
% warming_rate_gilson_1993
% warming_rate_gilson_2008
% warming_rate_gilson_1993_2005
