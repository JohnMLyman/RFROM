
min_year=2004;
max_year=2019;


area_of_earth=5.1e14;
sec_in_day=(60.*60*24);

path_file= 'C:\Users\jlyma\OneDrive - University of Hawaii\data\Roemmich_Gilson_Clim\';

load([path_file,'RG_ArgoClim_heat_curve_2019.mat'],'ht_curve_gilson','time_gilson')

min_year_gilson=min(time_gilson);
max_year_gilson=max(time_gilson);
ht_curve_gilson_all=ht_curve_gilson-nanmean(ht_curve_gilson);
time_gilson_all=time_gilson;

good_gilson=find(time_gilson>=min_year & time_gilson<=max_year);
time_gilson=time_gilson(good_gilson);
ht_curve_gilson=ht_curve_gilson(good_gilson);
center_year_gilson=nanmean(time_gilson);

  [model_gilson,amp_annual_gilson,phase_annual_gilson,amp_semi_gilson,phase_semi_gilson,amp_third_gilson,phase_third_gilson,slope_gilson,mean_gilson,model_err]=...
    j_fit_annual_tree(time_gilson',ht_curve_gilson);
ndays=364.5/12;

fac_gilson=1./(sec_in_day*area_of_earth.*ndays);
start_ind=2;
end_ind_off=1;

ht_gilson_res=ht_curve_gilson-model_gilson;


ht_gilson_res_qu=smooth(ht_gilson_res,6,'rloess');

ht_gilson_qu=ht_gilson_res_qu+model_gilson'-mean_gilson-slope_gilson.*center_year_gilson;
ht_gilson=ht_gilson_res'+model_gilson'-mean_gilson-slope_gilson.*center_year_gilson;


gilson_rate=(ht_gilson(start_ind:end)-ht_gilson(1:end-end_ind_off)).*fac_gilson;
gilson_rate_qu=(ht_gilson_qu(start_ind:end)-ht_gilson_qu(1:end-end_ind_off)).*fac_gilson;
time_gilson_rate=.5.*(time_gilson(1:end-end_ind_off)+time_gilson(start_ind:end));
ht_gilson_no_cyce=ht_gilson_res'+(time_gilson-center_year_gilson).*slope_gilson';


[model_gilson_qu,~,~,~,~,~,~,slope_qu_gilson,mean_qu_gilson,~]=...
    j_fit_annual_tree(time_gilson_rate',gilson_rate_qu');

cycle_qu_gilson=model_gilson_qu'-mean_qu_gilson-slope_qu_gilson.*center_year_gilson;
res_rate_qu_gilson=gilson_rate_qu-cycle_qu_gilson-mean_qu_gilson-slope_qu_gilson.*center_year_gilson;


%% load the combined tree heat content estimate

%%%

path_OHCA_data_out='C:\data\OHCA\'

path_tree=[path_OHCA_data_out,'OHCA_trees\'];
load([path_tree,'test_tree_curve_yearly_7day_2000_yearly_new_cycle_combined.mat'], 'tgrid', 'ht_curve');


good_gilson=find(tgrid>=min_year_gilson & tgrid<=max_year_gilson);
ht_curve_all=ht_curve-nanmean(ht_curve(good_gilson));
time_tree_all=tgrid;
good=find(tgrid>=min_year & tgrid<=max_year);
 
 ht_tree=double(ht_curve(good));
 time_tree=double(tgrid(good));
 center_year=mean(time_tree);

[model_tree,amp_annual_tree,phase_annual_tree,amp_semi_tree,phase_semi_tree,amp_third_tree,phase_third_tree,slope_tree,mean_tree,model_err]=...
    j_fit_annual_tree(time_tree,ht_tree');

ht_tree_res=ht_tree-model_tree';

ht_tree_res_mon=smooth(ht_tree_res,10,'rloess');
ht_tree_res_qu=smooth(ht_tree_res,26,'rloess');

ht_qu=ht_tree_res_qu+model_tree'-mean_tree-slope_tree.*center_year;
ht_mon=ht_tree_res_mon+model_tree'-mean_tree-slope_tree.*center_year;
ht_mon_no_cyce=ht_tree_res_mon'+(time_tree-center_year).*slope_tree';


area_of_earth=5.1e14;

ndays=7;


fac_tree=1./(sec_in_day*area_of_earth.*ndays);
start_ind=2;
end_ind_off=1;


rate_mon=(ht_mon(start_ind:end)-ht_mon(1:end-end_ind_off)).*fac_tree;
rate_qu=(ht_qu(start_ind:end)-ht_qu(1:end-end_ind_off)).*fac_tree;

time_rate_tree=.5.*(time_tree(1:end-end_ind_off)+time_tree(start_ind:end));
% make a monthly estimate of quartly 

time_aviso_mon=min(floor(time_tree))+1/24:1/12.:max(floor(time_tree))+1;
pos_aviso_mon=nans(1,length(time_aviso_mon));
for ipos=1:length(time_aviso_mon)
    [dist_junk,pos_junk]=min(abs(time_rate_tree-time_aviso_mon(ipos)));
    if dist_junk<=(1/50) % make sure that the estimate is close to the estimate.
        pos_aviso_mon(ipos)=pos_junk;
    end
end
good_pos_mon=isfinite(pos_aviso_mon);
pos_aviso_mon=pos_aviso_mon(good_pos_mon);
time_aviso_mon=time_aviso_mon(good_pos_mon);
rate_qu_mon=rate_qu(pos_aviso_mon);

[model_qu,~,~,~,~,~,~,slope_qu,mean_qu,~]=...
    j_fit_annual_tree(time_rate_tree,rate_qu');

cycle_qu=model_qu'-mean_qu-slope_qu.*center_year;
res_rate_qu=rate_qu-cycle_qu-mean_qu-slope_qu.*center_year;


%% load in the TOA from CERES
load('C:\Users\jlyma\OneDrive - University of Hawaii\data\CERES\norm_ohca_toa.mat','ohca_norm','toa','toa_time')
good_toa=find(toa_time>=min_year & toa_time<=max_year);
toa=toa(good_toa);
toa_time=toa_time(good_toa);

center_year_toa=nanmean(toa_time);


[model_toa,~,~,~,~,~,~,slope_toa,mean_toa,~]=...
    j_fit_annual_tree(toa_time',toa');

cycle_toa=model_toa'-mean_toa-slope_toa.*center_year_toa;
res_rate_toa=toa-cycle_toa-mean_toa-slope_toa.*center_year_toa;

%% 
   figure(1)
plot(toa_time,res_rate_toa,'k')
hold on

plot(time_gilson_rate,res_rate_qu_gilson,'m')
plot(time_rate_tree,res_rate_qu,'r')

% figure
% 
% time_aviso_mon=time_aviso_mon(good_pos_mon);
res_rate_qu_mon=res_rate_qu(pos_aviso_mon);

corr(res_rate_toa(1:end-1),res_rate_qu_mon)

var_gilson=nanvar(res_rate_qu_gilson)
var_tree=nanvar(res_rate_qu)
var_toa=nanvar(res_rate_toa)

figure(2)

plot(time_rate_tree,cycle_qu,'r')
cycle_qu_mon=cycle_qu(pos_aviso_mon);
% plot(time_aviso_mon,cycle_qu_mon,'g')
hold on
plot(time_gilson_rate,cycle_qu_gilson,'m')
plot(toa_time,cycle_toa,'k')


figure(3)

period=1;
period2=1/2;
period3=1/3;
% this takes out the annual cycle that was computed over the time period
% min_year max_year
 ht_cycle_gilson_all=amp_annual_gilson.*sin((2*pi.*time_gilson_all./period)+...
                phase_annual_gilson)+amp_semi_gilson.*sin((2.*time_gilson_all*pi./period2)+phase_semi_gilson)+...
                amp_third_gilson.*sin((2*pi.*time_gilson_all./period3)+phase_third_gilson);

  ht_cycle_tree_all=amp_annual_tree.*sin((2*pi.*time_tree_all./period)+...
                phase_annual_tree)+amp_semi_tree.*sin((2.*time_tree_all*pi./period2)+phase_semi_tree)+...
                amp_third_tree.*sin((2*pi.*time_tree_all./period3)+phase_third_tree);


plot(time_gilson_all,smooth(ht_curve_gilson_all'-ht_cycle_gilson_all,12),'m')
hold on
plot(time_tree_all,smooth(ht_curve_all-ht_cycle_tree_all',52),'r')

figure(4)


plot(time_gilson_all,(ht_curve_gilson_all'-ht_cycle_gilson_all),'m')
hold on
plot(time_tree_all,(ht_curve_all-ht_cycle_tree_all'),'r')
