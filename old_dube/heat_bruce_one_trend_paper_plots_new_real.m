% this code computes and plots the ten year trend in heat content.

% df is the estimate of the subsambled TOPEX
% tp is the estimate form the whole TOPEX record
% per_var_t  is percent of the subsampled field in the 95% cofidence interval 
% tsub in the maped topex var
% tpave is the unmaped variabilty 


clear
close all
alpha=(.6e7)/(.04);
area_of_earth=5.1e14
area_of_ocean=3.4e14
scale=alpha*area_of_ocean
start_year=1993
end_year=2006
%alpha is in J/m^2 /(cm)
%figure(4);
load ../SAL/Floats/hc_factor_trend2
%load ../SAL/Floats/hc_factor
junk_years=[1995 1995 1995 1995];
tsub_real=[];
tsub_all=[];
for iyear=1995:1995
for tyear=start_year:end_year
    

    file_name=['hdata_twin_allheat_',num2str(tyear),'_1993_2006.nc']
    
%     [tsub,tsub_hc,tgrid]=heat_curv_gen_twin_trend(file_name);
% 
%     tsub=tsub./area_of_ocean;
%  eval(['save ./hc_curve/hc_curve_1993_2006_trend_',num2str(tyear),' tsub tgrid tsub_hc']); 
 eval(['load ./hc_curve/hc_curve_1993_2006_trend_',num2str(tyear)]);
pos_good_sub=find(tgrid == tyear+.5);

tsub_real(tyear-start_year+1)=tsub(pos_good_sub);
%tsub_all(tyear-start_year+1,:)=tsub;
%tgrid_all=tgrid;

if tyear == iyear
    tsub_real2=tsub;
end
%hold on 
%plot(tgrid,tsub,'.-k')
%plot(tgrid(pos_good_sub),tsub(pos_good_sub),'r.')

%pause
end

iyear
one_pos=find(time >= start_year+.5 & time <= end_year+.5);
    one_scale=hc_one(one_pos);
    tgrid=time(one_pos);
    
%     one_single_pos=find(time == iyear+.5);
%     one_scale=hc_one(one_single_pos);
%     [tpave_hc,tpave]=heat_curv_gen_twin_real(tgrid); 
% 
%     tpave=tpave./area_of_ocean;
    load tpave_1993_2006_trend tpave tgrid
    good=find(tgrid>= start_year+.5 & tgrid <= end_year+.5);
    tgrid=tgrid(good);
    
%plot(tgrid,tsub_real,'.-r')
%hold off
    tsub=tsub_real;

    tpave=tpave(good);
    N=length(tsub);
    %tsub=tsub(1:N-1);
   % tpave=tpave(:N);
    tsub=tsub-mean(tsub);
    tpave=tpave-mean(tpave);
%     [y_sub,y_model_err_95,slope_error,slope]=j_fit(tgrid(1:12),tsub,1)
%     [y_ave,y_model_err_95,slope_error,slope]=j_fit(tgrid(1:12),tpave,1)
%     tsub=tsub-y_sub;
%     tpave=tpave-y_ave;
%      tsub=tsub-tsub(1);
%      tpave=tpave-tpave(1);
%    


t2=tgrid-mean(tgrid);
% linear fit
[y_model,y_model_err_95,slope_error_map,slope_map]=j_fit(t2,tsub,1);

if iyear==junk_years(1)
    tsub_1_map=tsub;
end
if iyear==junk_years(2)
    tsub_2_map=tsub;
end
if iyear==junk_years(3)
    tsub_3_map=tsub;
end
if iyear==junk_years(4)
    tsub_4_map=tsub;
end
%ttsub=tsub;
tsub=tsub./one_scale;
[y_model,y_model_err_95,slope_error_rep,slope_rep]=j_fit(t2,tsub,1);

[y_model,y_model_err_95,slope_error_ave,slope_ave]=j_fit(t2,tpave,1);

if iyear==junk_years(1)
    tsub_1_one=tsub;
end
if iyear==junk_years(2)
    tsub_2_one=tsub;
end
if iyear==junk_years(3)
    tsub_3_one=tsub;
end
if iyear==junk_years(4)
    tsub_4_one=tsub;
end


    per_var=sum((abs(tsub-tpave)).^2)/sum((tsub).^2);
   % std_error(iyear-1949)=student(N)*(sum((tsub-tpave).^2))/N)*alpha*3.4e14
   
   
  
   
 %   std_error(iyear-1949)=sqrt(f1.^2+f2.^2)*3.4e14;
%    std_dev(iyear-1949)=sqrt((f2./student(36)).^2+(f1./student(N)).^2)*3.4e14;
    %std_dev=std_error;
   % std_error(iyear-1949)=student(N)*(sum((tsub-tpave).^2)/N)*alpha*3.4e14
    
   %std_error(iyear-1949)=((student(N)*sum((tsub-tpave).^2)/(N))*alpha)*3.4e14
    
    
    
    slope_map_t(1)=slope_map*scale./area_of_earth/86400/365.25;
    slope_rep_t(1)=slope_rep*scale./area_of_earth/86400/365.25;
    slope_ave_t(1)=slope_ave*scale./area_of_earth/86400/365.25;
    error_map_t(1)=slope_error_map*scale./area_of_earth/86400/365.25;
    error_rep_t(1)=slope_error_rep*scale./area_of_earth/86400/365.25;
    error_ave_t(1)=slope_error_ave*scale./area_of_earth/86400/365.25;
% %     df_a=df+df_a;
% %     df_t=[df_t,df'];
    tgrid_err(1)=iyear+.5;
    
%   plot(tsub*alpha)
%   title(num2str(iyear))
%   hold on
%   plot(tpave*alpha,'r')
%     
%    
%     hold off
%    pause
end


% % figure(1); clf; orient tall;wysiwyg
% % 
% % 
% % 
% % subplot(2,1,1)
% % 
% % hold on
tgrid_err
slope_ave_t
error_ave_t
slope_map_t
error_map_t
slope_rep_t
error_rep_t
% % p1=plot(tgrid_err,slope_ave_t,'k')
% % e1=errorbar(tgrid_err,slope_ave_t,error_ave_t,'k');set(e1,'linewidth',3)
% % 
% % p2=plot(tgrid_err,slope_map_t,'--k')
% % %e2=errorbar(tgrid_err,slope_map_t,error_map_t,'--k');set(e2,'linewidth',2)
% % 
% % p3=plot(tgrid_err,slope_rep_t,'--k')
% % %e3=errorbar(tgrid_err,slope_rep_t,error_rep_t,'--k');set(e3,'linewidth',3)
% % 
% % axis([1955 2007 0 1.5])
% % ylabel('slope [watts m^{-2}] ','fontsize',16);
% % set(p1,'linewidth',4)
% % set(gca,'tickdir','out')
% % 
% % xlabel('years','fontsize',16);
% % 
% % title('Slope of Linear Fit to Heat Content Anomaly','fontsize',16);
% % set(gca,'fontsize',11)
% % 
% % set(p2,'linewidth',2)
% % set(p1,'linewidth',4)
% % set(p3,'linewidth',4)
% % gray=[.7 .7 .7];
% % set(p1,'color',gray);
% % set(e1,'color',gray);
% % hold off
% % subplot(2,1,2)
% % pe1=plot(tgrid_err,error_ave_t,'k');set(pe1,'linewidth',4,'color',gray)
% % hold on
% % pe2=plot(tgrid_err,error_map_t,'--k');set(pe2,'linewidth',2);
% % 
% % pe3=plot(tgrid_err,error_rep_t,'--k');set(pe3,'linewidth',4);
% % ylabel('slope [watts m^{-2}] ','fontsize',16);
% % xlabel('years','fontsize',16);
% % title('95% confidence interval','fontsize',16);
% % set(gca,'fontsize',11)
% % axis([1955 2007 0 1.5])
figure(2); clf; orient tall;wysiwyg






subplot(2,1,1)
plot_bruce_aviso_real(tsub_1_one,tsub_1_map,scale,tgrid,tpave)

%subplot(3,1,2)
%plot_bruce_aviso(tsub_2_one,tsub_2_map,scale,tgrid,junk_years(2),tpave)

%subplot(2,1,2)
%plot_bruce_aviso(tsub_3_one,tsub_3_map,scale,tgrid,junk_years(3),tpave)

hold off



eval(['print -dtiff -f2 /home/shoko2/wills/globalhc_dirs/Globalhc/figs/trend_paper/aviso_estimate_new_real'])
%eval(['print -dpng -f1 /home/shoko2/wills/globalhc_dirs/Globalhc/figs/trend_paper/aviso_estimate_slope_new_real'])



