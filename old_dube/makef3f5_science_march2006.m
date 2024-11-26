% makef3f5.m - matlab script to make figures 3 and 5 for the globahc paper
% global integrals of heat content and storage
load h_error_est_new 
tgrid_alpha=tgrid;
alpha_error=error_globe;
tp_alone_error=error_globe_tp;

heat_content_var2
make_slope_error

%per_var_t=[per_var_t,per_var_t(12)]
load hcseries
tgrid=tgrid(1:222);

max_ind=length(tgrid);

%total time series
min_ind=find(tgrid == 1993.5);
max_ind=find(tgrid == 2005.5);

%cooling years 
cool_max=2005.5;
cool_min=2003.5;

%warming years
warm_max=2005.5
warm_min=1993.5

%ploting 
max_year=tgrid(max_ind)+.5;
min_year=tgrid(min_ind)-.5;

%area of the earth used to compute w/m^2
area_of_earth=5.1e14

tgrid=tgrid(min_ind:max_ind);
hc=hc(min_ind:max_ind);
hc2=hc2(min_ind:max_ind);

tp=tp(min_ind:max_ind);
df=df(min_ind:max_ind);

time_place=abs(tgrid-floor(tgrid));
good=find(time_place == .5 | time_place == 0);
good=find(time_place == .5 );

hc2=hc2(good);
tgrid=tgrid(good);
load hcseries_march2005
tgrid=tgrid(4:end)+.5;
hc2=hc2(4:end);

%put into Joules
mean_hc2=mean(hc2);

hc2=hc2-mean_hc2;

hc2=hc2*3.4e14;

%cooling

cooling=find(tgrid >= cool_min & tgrid <= cool_max);
hc2_cool=hc2(cooling);
tgrid_cool=tgrid(cooling);

%warming 

warming=find(tgrid >= warm_min & tgrid <= warm_max);
hc2_warm=hc2(warming);
tgrid_warm=tgrid(warming);




%grid error
error_insitu=interp1(tgrid_err,std_error,tgrid);
std_error_hc2=interp1(tgrid_err,std_dev,tgrid);


%cooling griding 
cooling=find(tgrid >= cool_min & tgrid <= cool_max);
hc2_cool=hc2(cooling);
tgrid_cool=tgrid(cooling);
std_error_hc2_cool=std_error_hc2(cooling);

%warming griding 
warming=find(tgrid >= warm_min & tgrid <= warm_max);
hc2_warm=hc2(warming);
tgrid_warm=tgrid(warming);
std_error_hc2_warm=std_error_hc2(warming);

% now compute the amount of varience in the difference field and mulitiply
% it by the amount of varience in the diference field
% .6e7 is a random error expressed as the standard deviation of the mean and 
%   is computed from a TOPEX estimate of SSH computed in Wills 2004 
% 13 dof for student-t with the samp error because there were 13 estimates
%   that determined the std, but it is not divided by sqrt(13) becuase only
%   one estimate was used (ie only one world)

close all

figure(2); clf;orient landscape; wysiwyg



p=plot(tgrid,hc2,'k-*');hold on
ylabel('0-750m Heat Content Anomaly [J]','fontsize',16);
set(p,'linewidth',3)
set(gca,'XTick',[min_year:1:max_year],'tickdir','out')

xlabel('years','fontsize',16);

title('0-750m Heat Content Anomaly','fontsize',16);
axis([min_year max_year -7.0e22 7.0e22])
set(gca,'fontsize',11)



e1=errorbar(tgrid,hc2,error_insitu,'k');set(e1,'linewidth',1)

%plot the x-axis

plot([min_year-1 max_year+1],[0 0],'k')

scale_fit_hc2=std(hc2)./std(tgrid);
scale_fit_hc2_cool=std(hc2_cool)./std(tgrid_cool);
scale_fit_hc2_warm=std(hc2_warm)./std(tgrid_warm);


hc2_2=hc2./scale_fit_hc2;
hc2_2_cool=hc2_cool./scale_fit_hc2_cool;
hc2_2_warm=hc2_warm./scale_fit_hc2_warm;

std_error_hc2=std_error_hc2./scale_fit_hc2;
std_error_hc2_cool=std_error_hc2_cool./scale_fit_hc2_cool;
std_error_hc2_warm=std_error_hc2_warm./scale_fit_hc2_warm;

w_hc2=1./(std_error_hc2.^2);
w_hc2_cool=1./(std_error_hc2_cool.^2);
w_hc2_warm=1./(std_error_hc2_warm.^2);
 
 [y_model,y_model_err_95,slope_error_hc2,sl_hc2]=j_fit_weighted(tgrid,hc2_2,w_hc2);
 [y_model_cool,y_model_err_95_cool,slope_error_hc2_cool,sl_hc2_cool]=  ...
     j_fit_weighted(tgrid_cool,hc2_2_cool,w_hc2_cool);
 
[y_model_warm,y_model_err_95_warm,slope_error_hc2_warm,sl_hc2_warm]=  ...
     j_fit_weighted(tgrid_warm,hc2_2_warm,w_hc2_warm);
 
  
     
slope_error_hc2=slope_error_hc2*scale_fit_hc2./area_of_earth;
sl_hc2=sl_hc2*scale_fit_hc2./area_of_earth;

slope_error_hc2_cool=slope_error_hc2_cool*scale_fit_hc2_cool./area_of_earth;
sl_hc2_cool=sl_hc2_cool*scale_fit_hc2_cool./area_of_earth;

slope_error_hc2_warm=slope_error_hc2_warm*scale_fit_hc2_warm./area_of_earth;
sl_hc2_warm=sl_hc2_warm*scale_fit_hc2_warm./area_of_earth;

w2=num2str(sl_hc2/86400/365.25,'%4.2f');
w4=num2str(sl_hc2_cool/86400/365.25,'%4.2f');
w5=num2str(sl_hc2_warm/86400/365.25,'%4.2f');


w2_err=num2str(slope_error_hc2/86400/365.25,'%4.2f');
w4_err=num2str(slope_error_hc2_cool/86400/365.25,'%4.2f');
w5_err=num2str(slope_error_hc2_warm/86400/365.25,'%4.2f');
% txt={'warming rate:'; ...
% ['            ',w2,'\pm',w2_err,' W/m^2']};
% txth=text(1999.15,-3.9e22,txt,'fontsize',16);
% pp4=plot([1998 1999]+1, ...
% [-3.67e22 -3.67e22]-.44e22,'k');
% set(pp4,'linewidth',3)


% txt={'warming rate (1993-2005): ';[w2,'\pm',w2_err,' W/m^2']; ...
%     'cooling rate (2003-2005): ';[w4,'\pm',w4_err,' W/m^2']};


txt={['warming rate (',num2str(warm_min-.5),'-',num2str(warm_max-.5),'): '];[w5,'\pm',w5_err,' W/m^2']; ...
    ['cooling rate (',num2str(cool_min-.5),'-',num2str(cool_max-.5),'): '];[w4,'\pm',w4_err,' W/m^2']};


 txth=text(1999.15,-3.9e22,txt,'fontsize',16);

eval(['print -dpng -f2 /home/shoko/C/','''IDL ps''','/heat/science/heat_1993_2005_march2006'])
eval(['print -deps -f2 /home/shoko/C/','''IDL ps''','/heat/agu/heat_1993_2005_march2006'])
