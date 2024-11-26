% makef3f5.m - matlab script to make figures 3 and 5 for the globahc paper

% global integrals of heat content and storage

min_year=1993;
max_year=2008;
%load in error bars
cd '/Users/johnlyman/data/Globalhc/HC'
load greg_talk_april_2007_error

%area of the earth used to compute w/m^2
area_of_earth=5.1e14


time_error=time;
time_all_error=[time_all 2007.5];
error_all=[error_all error_all(end)];

cd ../SAL/Floats

[hc,time,hc_one]=heat_curv_gen_mat('htanom_no_xbt_2006_1993_2007.mat');
[hc,time,hc_diff]=heat_curv_gen_mat_diff('htanom_no_xbt_2006_1993_2007.mat');



%subsect all and put into Zeta joules

good_pos=find(time >= min_year & time <=max_year);
hc=hc(good_pos)/1e21;
time=time(good_pos);
hc_one=hc_one(good_pos)/1e21;
hc_diff=hc_diff(good_pos)/1e21;

%subsect error and put into Zeta joules



good_pos=find(time_all_error >=min_year & time_all_error <=max_year);
time_all_error=time_all_error(good_pos);
error_all=error_all(good_pos)/1e21;


close all

figure(2); clf;orient landscape; wysiwyg

p=plot(time,hc,'k-*');
hold on
pdiff=plot(time,hc_diff,'-*');
pone=plot(time,hc_one,'r-*');
ylabel('0-750 m Heat Content Anomaly [zeta-joules]','fontsize',16);
set(p,'linewidth',3)
set(pdiff,'linewidth',3)
set(pone,'linewidth',3)
set(gca,'XTick',[min_year:1:max_year],'tickdir','out')

xlabel('Time [years]','fontsize',16);

title('0-750m Heat Content Anomaly','fontsize',18);
axis([min_year max_year -100 100])
set(gca,'fontsize',16)




%e2=errorbar(time_no_argo,hc_no_argo,error_no_argo,'r');set(e2,'linewidth',2)
e3=errorbar(time,hc,error_all,'k');set(e3,'linewidth',2)
e1=errorbar(time,hc_one,error_all,'r');set(e1,'linewidth',2)
%plot the x-axis

plot([min_year-1 max_year+1],[0 0],'k')

% % %      
% % % figure(3); clf;orient landscape; wysiwyg
% % % 
% % % p=plot(time,hc_one,'k-*');
% % % hold on
% % % %plot(time_argo,hc_one_argo,'-*');
% % % %plot(time_no_argo,hc_one_no_argo,'r-*');
% % % ylabel('0-750 m Heat Content Anomaly [zeta-joules]','fontsize',16);
% % % set(p,'linewidth',3)
% % % set(gca,'XTick',[min_year:1:max_year],'tickdir','out')
% % % 
% % % xlabel('Time [years]','fontsize',16);
% % % 
% % % title('0-750m Heat Content Anomaly','fontsize',18);
% % % axis([min_year max_year -80 160])
% % % set(gca,'fontsize',16)
% % % 
% % % 
% % % 
% % % %e1=errorbar(time_argo,hc_one_argo,error_argo);set(e1,'linewidth',2)
% % % %e2=errorbar(time_no_argo,hc_one_no_argo,error_no_argo,'r');set(e2,'linewidth',2)
% % % e3=errorbar(time,hc_one,error_all,'k');set(e3,'linewidth',2)
% % % 
% % % %plot the x-axis
% % % 
% % % plot([min_year-1 max_year+1],[0 0],'k')
% % % 
% % % 


eval(['print -dtiff -f2 /Users/johnlyman/figs/oco/poster/hc_oco_2008_poster'])


%compute the slope of the line and output it to the screen



% put heat content back in to joules

hc2=hc*1e21;
hc_one2=hc_one*1e21;
hc_diff2=hc_diff*1e21;
tgrid=time;
std_error_hc2=error_all*1e21;

scale_fit_hc2=std(hc2)./std(tgrid);
scale_fit_hc_one2=std(hc_one2)./std(tgrid);
scale_fit_hc_diff2=std(hc_diff2)./std(tgrid);

hc2_2=hc2./scale_fit_hc2;
hc_one2_2=hc_one2./scale_fit_hc_one2;
hc_diff2_2=hc_diff2./scale_fit_hc_diff2;

std_error_junk=std_error_hc2;
std_error_hc2=std_error_junk./scale_fit_hc2;
std_error_hc_one2=std_error_junk./scale_fit_hc_one2;
std_error_hc_diff2=std_error_junk./scale_fit_hc_diff2;

w_hc2=1./(std_error_hc2.^2);
w_hc_one2=1./(std_error_hc_one2.^2);

% Note: I am notweighting the combined estimate because the error is hard
% to define!

w_hc_diff2=ones(1,length(w_hc2));

 [y_model,y_model_err_95,slope_error_hc2,sl_hc2]=j_fit_weighted(tgrid,hc2_2,w_hc2);
 [y_model,y_model_err_95,slope_error_hc_one2,sl_hc_one2]=j_fit_weighted(tgrid,hc_one2_2,w_hc_one2); 
 [y_model,y_model_err_95,slope_error_hc_diff2,sl_hc_diff2]=j_fit_weighted(tgrid,hc_diff2_2,w_hc_diff2);


slope_error_hc2=slope_error_hc2*scale_fit_hc2./area_of_earth;
sl_hc2=sl_hc2*scale_fit_hc2./area_of_earth;

slope_error_hc_one2=slope_error_hc_one2*scale_fit_hc_one2./area_of_earth;
sl_hc_one2=sl_hc_one2*scale_fit_hc_one2./area_of_earth;

slope_error_hc_diff2=slope_error_hc_diff2*scale_fit_hc_diff2./area_of_earth;
sl_hc_diff2=sl_hc_diff2*scale_fit_hc_diff2./area_of_earth;

w2=num2str(sl_hc2/86400/365.25,'%4.2f');
w2_one=num2str(sl_hc_one2/86400/365.25,'%4.2f');
w2_diff=num2str(sl_hc_diff2/86400/365.25,'%4.2f');

w2_err=num2str(slope_error_hc2/86400/365.25,'%4.2f');
w2_err_one=num2str(slope_error_hc_one2/86400/365.25,'%4.2f');
w2_err_diff=num2str(slope_error_hc_diff2/86400/365.25,'%4.2f');


txt= ['Normal ',w2,'\pm',w2_err,' W/m^2']
txt_one= ['Weighted ',w2_one,'\pm',w2_err_one,' W/m^2']
txt_diff= ['Combined estimate ',w2_diff,'\pm',w2_err_diff,' W/m^2']

