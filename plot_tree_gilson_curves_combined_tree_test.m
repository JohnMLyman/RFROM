name_comp='tree_gilson_LJ_test';
path_figs='C:\data\OHCA\figs\tree_paper\'

load('C:\Users\jlyma\OneDrive - University of Hawaii\data\OHCA\curves\pmel_hc_2021.mat')
load('C:\Users\jlyma\OneDrive - University of Hawaii\data\OHCA\curves\pmel_hc_2021_deep.mat')
time_pmel=time;
ohca_pmel=hc_one+hc_one_deep;

mycor=[228,26,28 
    55,126,184
    77,175,74
    152,78,163
    255,127,0
    55,78,0]./255;

min_year=1993;
max_year=2022;
min_year_cycle=1993;
max_year_cycle=2006;
  
path_file= 'C:\Users\jlyma\OneDrive - University of Hawaii\data\Roemmich_Gilson_Clim\';

load([path_file,'RG_ArgoClim_heatcurve_all.mat'],'ht_curve_gilson','time_gilson')

good_gilson=find(time_gilson>=min_year & time_gilson<=max_year & isfinite(ht_curve_gilson'));
time_gilson=time_gilson(good_gilson);
ht_curve_gilson=ht_curve_gilson(good_gilson);

good_gilson_cycle=find(time_gilson>=min_year_cycle & time_gilson<=max_year_cycle );
time_gilson_cycle=time_gilson(good_gilson_cycle);
ht_curve_gilson_cycle=ht_curve_gilson(good_gilson_cycle);

center_year_gilson=nanmean(time_gilson_cycle);




  [model_gilson,amp_annual,phase_annual,amp_semi,phase_semi,amp_third,phase_third,slope_gilson,mean_gilson,model_err]=...
    j_fit_annual_tree(time_gilson_cycle',ht_curve_gilson_cycle,time_gilson');
ndays=364.5/12;
area_of_earth=5.1e14;
sec_in_day=(60.*60*24);
fac=1./(sec_in_day*area_of_earth.*ndays)
start_ind=2;
end_ind_off=1;

ht_gilson_res=ht_curve_gilson-model_gilson;


ht_gilson_res_qu=smooth(ht_gilson_res,6,'rloess');
ht_gilson_res_year=smooth(ht_gilson_res,12);

ht_gilson_qu=ht_gilson_res_qu+model_gilson'-mean_gilson-slope_gilson.*center_year_gilson;
ht_gilson=ht_gilson_res'+model_gilson'-mean_gilson-slope_gilson.*center_year_gilson;


gilson_rate=(ht_gilson(start_ind:end)-ht_gilson(1:end-end_ind_off)).*fac;
gilson_rate_qu=(ht_gilson_qu(start_ind:end)-ht_gilson_qu(1:end-end_ind_off)).*fac;
time_gilson_rate=.5.*(time_gilson(1:end-end_ind_off)+time_gilson(start_ind:end));
ht_gilson_no_cyce=ht_gilson_res'+(time_gilson-center_year_gilson).*slope_gilson';
ht_gilson_year_no_cyce=ht_gilson_res_year+(time_gilson-center_year_gilson).*slope_gilson';

[model_gilson_qu,~,~,~,~,~,~,slope_qu_gilson,mean_qu_gilson,~]=...
    j_fit_annual_tree(time_gilson_rate',gilson_rate_qu');

cycle_qu_gilson=model_gilson_qu'-mean_qu_gilson-slope_qu_gilson.*center_year_gilson;
res_rate_qu_gilson=gilson_rate_qu-cycle_qu_gilson-mean_qu_gilson-slope_qu_gilson.*center_year_gilson;

%%%

path_OHCA_data_out='C:\data\OHCA\'

path_tree=[path_OHCA_data_out,'OHCA_trees\'];
load([path_tree,'test_tree_curve_yearly_7day_2000_yearly_new_cycle_combined_2_fixed.mat'], 'tgrid', 'ht_curve');

tgrid_all=tgrid;
ht_curve_all=ht_curve;

% 

good_all=find(tgrid_all>=min_year & tgrid_all<=max_year & isfinite(ht_curve_all'));
 
 ht_tree_all=double(ht_curve_all(good_all));
 time_tree_all=double(tgrid_all(good_all));

 good_all_cycle=find(tgrid_all>=min_year_cycle  & tgrid_all<=max_year_cycle );
 ht_tree_all_cycle=double(ht_curve_all(good_all_cycle));
 time_tree_all_cycle=double(tgrid_all(good_all_cycle));
 center_year_all=mean(time_tree_all_cycle);


[model_tree_all,amp_annual,phase_annual,amp_semi,phase_semi,amp_third,phase_third,slope_tree_all,mean_tree_all,model_err]=...
    j_fit_annual_tree(time_tree_all_cycle,ht_tree_all_cycle',time_tree_all);
% [model_tree_all,amp_annual,phase_annual,amp_semi,phase_semi,amp_third,phase_third,slope_tree_all,mean_tree_all,model_err]=...
%     j_fit_annual_tree(time_tree_all_cycle,ht_tree_all_cycle');

ht_tree_all_res=ht_tree_all-model_tree_all';

ht_tree_all_res_year=smooth(ht_tree_all_res,52);


ht_all_no_cyce=ht_tree_all_res'+(time_tree_all-center_year_all).*slope_tree_all';
ht_all_year_no_cyce=ht_tree_all_res_year'+(time_tree_all-center_year_all).*slope_tree_all';




%% now compute the curves for using the yearly esitmate

% load([path_tree,'test_tree_curve_yearly_7day_2000_yearly_new_cycle_2.mat'], 'tgrid', 'ht_curve');
tgrid=tgrid_all;
ht_curve=ht_curve_all;

good=find(tgrid>=min_year & tgrid<=max_year);

 
 ht_tree=double(ht_curve(good));
 time_tree=double(tgrid(good));
 center_year=mean(time_tree);




% plot(tgrid,ht_curve-nanmean(ht_curve))
%% 
figure(7)
clf;orient tall; wysiwyg_tuna
path_curve=[path_OHCA_data_out,'OHCA_curves\'];
% load([path_curve,'test_tree_curve_yearly_7day_2000_yearly_new_error_2xweight_combined.mat'],'layer_curve_error','tgrid')
% error_0_2000=4.*nansum(layer_curve_error)./1e21;
% error_0_2000=error_0_2000(2:end);
max_ohca=150;
min_ohca=-270 ;


scale_plot=.16./100;
plot_height=(max_ohca-min_ohca)*scale_plot;
% 
% save([path_figs,name_comp,'_ohca_curves.mat'],'time_tree_all','ht_all_no_cyce',...
%     'ht_all_year_no_cyce',...
%     'time_gilson','ht_gilson_year_no_cyce','ht_gilson_no_cyce',...
%     'time_pmel','ohca_pmel')
% plot(time_gilson,ht_curve_gilson-nanmean(ht_curve_gilson))
good_gilson=find(time_gilson>=min_year_cycle);
good_tree=find(time_tree_all>=min_year_cycle);
offset_gilson=nanmean(ht_gilson_no_cyce(good_gilson));
offset_tree=nanmean(ht_all_no_cyce(good_tree));

plot_pos_tree_year=time_tree_all>=min_year+.5&time_tree_all<=max_year-.5;
plot_pos_gilson_year=time_gilson>=min_year+.5&time_gilson<=max_year-.5;

plot(time_gilson,(ht_gilson_no_cyce-offset_gilson)./1e21,'color',mycor(4,:))
hold on
plot(time_gilson(plot_pos_gilson_year),(ht_gilson_year_no_cyce(plot_pos_gilson_year)-offset_gilson)./1e21,'color',mycor(4,:),LineWidth=2)
plot(time_tree_all,(ht_all_no_cyce-offset_tree)./1e21,'k')
plot(time_tree_all(plot_pos_tree_year),(ht_all_year_no_cyce(plot_pos_tree_year)-offset_tree)./1e21,'k',LineWidth=2)
% plot(time_pmel(time_pmel>=min(time_gilson)),ohca_pmel(time_pmel>=min(time_gilson))'-nanmean(ohca_pmel(time_pmel>=min_year_cycle & time_pmel<=max_year)),'color',mycor(2,:),LineWidth=2)
 plot(time_pmel,ohca_pmel'-nanmean(ohca_pmel(time_pmel>=min_year_cycle & time_pmel<=max_year)),'color',mycor(2,:),LineWidth=2)

% sub_pos=[1:8:length(time_tree_all)];
% et=errorbar(time_tree_all(sub_pos),(ht_all_no_cyce(sub_pos)-offset_tree)./1e21,error_0_2000(sub_pos),'color','k','none');%set(et,'linewidth',3);
% et=errorbar(time_tree_all(sub_pos),(ht_all_no_cyce(sub_pos)-offset_tree)./1e21,error_0_2000(sub_pos),'k.')
% plot(time_tree_all,ht_all_no_cyce./1e21,'b')

set(gca,'tickdir','out','Fontsize',16,'Fontname','Arial','box','on','xtick',[1970:5:max_year],'XAxisLocation','bottom',...
    'ytick',[min_ohca:20:max_ohca])
year_text=2000;
text_del=1.1;
  text_del=text_del*10;
  
  text_size=15;
  text_off=20;
text(year_text,text_off+text_del*4,'RG09','color',mycor(4,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*4 text_off+text_del*4],'color',mycor(4,:),'linewidth',2)

text(year_text,text_off+text_del*3,'LJ14','color',mycor(2,:),'FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*3 text_off+text_del*3],'color',mycor(2,:),'linewidth',2)

text(year_text,text_off+text_del*2,'RFROM','color','k','FontName','Arial','FontSize',text_size)
plot([year_text-2 year_text-1],[text_off+text_del*2 text_off+text_del*2],'color','k','linewidth',2)

axis([min_year max_year min_ohca max_ohca])
%plot([min_year max_year],[-49.99 -49.99],'k-');
axis([min_year max_year min_ohca max_ohca])
ylabel('OHCA (ZJ)','Fontsize',16,'Fontname','Arial')
xlabel('Time (yr)','Fontsize',16,'Fontname','Arial')
%xlabel('Time (yr)','Fontsize',11,'Fontname','Arial')
% text(1994.5,95,'(b)','Fontsize',16,'Fontname','Arial','Fontweight','Bold') 
% plot(tgrid,ht_curve-nanmean(ht_curve))
 eval(['print -dpng -r600 -f7 ',path_figs,'curve_',name_comp])

pos_warm_pmel=time_pmel>2008;
 [warming_rate_pmel_2008]=compute_warming_no_weight_3(ohca_pmel(pos_warm_pmel)'./10,hc_one_deep(pos_warm_pmel)'/1000,time_pmel(pos_warm_pmel));

 pos_warm_tree=time_tree_all>2008;
 [warming_rate_tree_2008]=compute_warming_no_weight_3(ht_all_no_cyce(pos_warm_tree)./(10.*1e21),ht_all_no_cyce(pos_warm_tree)/(1e21.*1000),time_tree_all(pos_warm_tree));

 pos_warm_gilson=time_gilson>2008;
 [warming_rate_gilson_2008]=compute_warming_no_weight_3(ht_gilson_no_cyce(pos_warm_gilson)'./(10.*1e21),ht_gilson_no_cyce(pos_warm_gilson)'/(1e21.*1000),time_gilson(pos_warm_gilson)');


  pos_warm_tree=time_tree_all>1993 &time_tree_all<2005;
 [warming_rate_tree_1993_2005]=compute_warming_no_weight_3(ht_all_no_cyce(pos_warm_tree)./(10.*1e21),ht_all_no_cyce(pos_warm_tree)/(1e21.*1000),time_tree_all(pos_warm_tree));

 pos_warm_pmel=time_pmel>1993 & time_pmel<2005;
 [warming_rate_pmel_1993_2005]=compute_warming_no_weight_3(ohca_pmel(pos_warm_pmel)'./10,hc_one_deep(pos_warm_pmel)'/1000,time_pmel(pos_warm_pmel));

  pos_warm_gilson=time_gilson>1993 & time_gilson<2005;
 [warming_rate_gilson_1993_2005]=compute_warming_no_weight_3(ht_gilson_no_cyce(pos_warm_gilson)'./(10.*1e21),ht_gilson_no_cyce(pos_warm_gilson)'/(1e21.*1000),time_gilson(pos_warm_gilson)');


  pos_warm_tree=time_tree_all>1993 ;
 [warming_rate_tree_1993]=compute_warming_no_weight_3(ht_all_no_cyce(pos_warm_tree)./(10.*1e21),ht_all_no_cyce(pos_warm_tree)/(1e21.*1000),time_tree_all(pos_warm_tree));

 pos_warm_pmel=time_pmel>1993 ;
 [warming_rate_pmel_1993]=compute_warming_no_weight_3(ohca_pmel(pos_warm_pmel)'./10,hc_one_deep(pos_warm_pmel)'/1000,time_pmel(pos_warm_pmel));

  pos_warm_gilson=time_gilson>1993 ;
 [warming_rate_gilson_1993]=compute_warming_no_weight_3(ht_gilson_no_cyce(pos_warm_gilson)'./(10.*1e21),ht_gilson_no_cyce(pos_warm_gilson)'/(1e21.*1000),time_gilson(pos_warm_gilson)');



warming_rate_pmel_1993
warming_rate_pmel_2008
warming_rate_pmel_1993_2005


warming_rate_tree_1993
warming_rate_tree_2008
warming_rate_tree_1993_2005


name_comp
warming_rate_gilson_1993
warming_rate_gilson_2008
warming_rate_gilson_1993_2005
