
path_file= 'C:\Users\jlyma\OneDrive - University of Hawaii\data\Roemmich_Gilson_Clim\';
load([path_file,'RG_ArgoClim_heat_2019.mat'],'heat','lon','lat','pres','time')
heat=double(heat);
time_gilson=double(time);
nt_gilson=length(time);
arw=areavec(lon,lat);
 arw_gilson=repmat(arw,1,1,nt_gilson);
  ht_curve_gilson=squeeze(nansum(heat,3));
  clear heat

  ht_curve_gilson=squeeze(nansum(ht_curve_gilson.*arw_gilson,1));
  ht_curve_gilson=double(squeeze(nansum(ht_curve_gilson,1)));
  good_gilson=find(time_gilson>=2008 & time_gilson<=2019);
  time_gilson=time_gilson(good_gilson);
  ht_curve_gilson=ht_curve_gilson(good_gilson);

  [model_gilson,amp_annual,phase_annual,amp_semi,phase_semi,amp_third,phase_third,slope_gilson,mean_gilson,model_err]=...
    j_fit_annual_tree(time_gilson',ht_curve_gilson);

path_OHCA_data_out='C:\data\OHCA\'

path_tree=[path_OHCA_data_out,'OHCA_trees\'];

load([path_tree,'test_tree_curve_yearly_7day_2000_yearly_new_cycle_mask.mat'], 'tgrid', 'ht_curve');
good=find(tgrid>=2008 & tgrid<=2019);
good=good(1:4:end);
 ht_filt=filter(ones(1,4)./4,1,ht_curve);

 ht_tree=double(ht_filt(good));
 time_tree=double(tgrid(good));
 ht_tree_hi=double(ht_curve(good))
 time_tree_hi=double(tgrid(good));

[model_tree,amp_annual,phase_annual,amp_semi,phase_semi,amp_third,phase_third,slope_tree,mean_tree,model_err]=...
    j_fit_annual_tree(time_tree,ht_tree');
figure(1)
plot(time_gilson,ht_curve_gilson-model_gilson)
hold on
plot(time_tree,ht_tree-model_tree')

center_year=mean(time_tree)
figure(2)
plot(time_gilson,ht_curve_gilson-mean_gilson-slope_gilson.*center_year)
hold on
plot(time_tree,ht_tree-mean_tree-slope_tree.*center_year)

figure(3)

[model_tree_hi,amp_annual,phase_annual,amp_semi,phase_semi,amp_third,phase_third,slope_tree_hi,mean_tree_hi,model_err]=...
    j_fit_annual_tree(time_tree_hi,ht_tree_hi');

plot(time_gilson,ht_curve_gilson-mean_gilson-slope_gilson.*center_year)
hold on
plot(time_tree_hi,ht_tree_hi-mean_tree_hi-slope_tree_hi.*center_year)



figure(4)
plot(time_gilson,ht_curve_gilson-model_gilson)
hold on
plot(time_tree_hi,ht_tree_hi-model_tree_hi')

var_gilson=nanvar(ht_curve_gilson-model_gilson);


var_tree=nanvar(ht_tree-model_tree');

var_tree_hi=nanvar(ht_tree_hi-model_tree_hi');

var_tree./var_gilson



var_tree_hi./var_gilson

%%  ALL OF THEIS IS HIGHLY SUBJECT!  NEEDS TO BE TRIPPLE CHECKED
% TOA is in W/m^2
[yr,TOA]=read_mon_CERES();

area_of_earth=5.1e14;

ndays=7*4;

sec_in_day=(60.*60*24);
fac=1./(sec_in_day*area_of_earth.*ndays)
start_ind=2;
end_ind_off=1;

cycle_tree_hi=model_tree_hi-mean_tree_hi-slope_tree_hi.*center_year;

rate_2000_tree=(ht_tree_hi(start_ind:end)-ht_tree_hi(1:end-end_ind_off)).*fac;
rate_2000_tree_cycle=(cycle_tree_hi(start_ind:end)-cycle_tree_hi(1:end-end_ind_off)).*fac;
time_rate_2000_tree=.5.*(time_tree_hi(1:end-end_ind_off)+time_tree_hi(start_ind:end));

ndays=364.5/12;

sec_in_day=(60.*60*24);
fac=1./(sec_in_day*area_of_earth.*ndays)
start_ind=2;
end_ind_off=1;


gilson_rate=(ht_curve_gilson(start_ind:end)-ht_curve_gilson(1:end-end_ind_off)).*fac;
time_gilson_rate=.5.*(time_gilson(1:end-end_ind_off)+time_gilson(start_ind:end));


load('C:\Users\jlyma\OneDrive - University of Hawaii\data\CERES\norm_ohca_toa.mat','ohca_norm','toa','toa_time')



figure(5)
plot(toa_time,toa)
hold on
plot(time_rate_2000_tree,rate_2000_tree,'k')
 xrange=[-40 40]
figure(6)
plot(toa_time,toa)
hold on
plot(time_gilson_rate,gilson_rate,'k')
 xrange=[-40 40]


  ht_filt=filter(hann(20)./sum(hann(20)),1,ht_curve);
good=[1:4:length(ht_curve)];
time_filt=tgrid(good);
 ht_filt=ht_filt(good);
ndays=7*4;

sec_in_day=(60.*60*24);
fac=1./(sec_in_day*area_of_earth.*ndays)
rate=diff(ht_filt);
time_rate=(time_filt(1:end-1)+time_filt(2:end))./2;



