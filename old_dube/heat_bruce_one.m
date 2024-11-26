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
scale=alpha*3.4e14
start_year=1955
%alpha is in J/m^2 /(cm)

load ../SAL/Floats/hc_factor
junk_years=[1955 1970 1998 2005];
for ijunk_year=1:4
    junk_year=junk_years(ijunk_year);
for iyear=start_year:2005
    
    one_pos=find(time == iyear+.5);
    one_scale=hc_one(one_pos);
    
    
    load (['hcseries2_twin_',num2str(iyear)])
    good=find(tgrid <= 2004);
    tgrid=tgrid(good);
    tsub=tsub(good);
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

if iyear==junk_year
    tsub_1955_map=tsub;
end
%ttsub=tsub;
tsub=tsub./one_scale;
[y_model,y_model_err_95,slope_error_rep,slope_rep]=j_fit(t2,tsub,1);

[y_model,y_model_err_95,slope_error_ave,slope_ave]=j_fit(t2,tpave,1);

if iyear==junk_year
    tsub_1955_one=tsub;
end


    per_var=sum((abs(tsub-tpave)).^2)/sum((tsub).^2);
   % std_error(iyear-1949)=student(N)*(sum((tsub-tpave).^2))/N)*alpha*3.4e14
   
   
  
   
 %   std_error(iyear-1949)=sqrt(f1.^2+f2.^2)*3.4e14;
%    std_dev(iyear-1949)=sqrt((f2./student(36)).^2+(f1./student(N)).^2)*3.4e14;
    %std_dev=std_error;
   % std_error(iyear-1949)=student(N)*(sum((tsub-tpave).^2)/N)*alpha*3.4e14
    
   %std_error(iyear-1949)=((student(N)*sum((tsub-tpave).^2)/(N))*alpha)*3.4e14
    
    slope_map_t(iyear-start_year+1)=slope_map*scale./area_of_earth/86400/365.25;
    slope_rep_t(iyear-start_year+1)=slope_rep*scale./area_of_earth/86400/365.25;
    slope_ave_t(iyear-start_year+1)=slope_ave*scale./area_of_earth/86400/365.25;
    error_map_t(iyear-start_year+1)=slope_error_map*scale./area_of_earth/86400/365.25;
    error_rep_t(iyear-start_year+1)=slope_error_rep*scale./area_of_earth/86400/365.25;
    error_ave_t(iyear-start_year+1)=slope_error_ave*scale./area_of_earth/86400/365.25;
% %     df_a=df+df_a;
% %     df_t=[df_t,df'];
    tgrid_err(iyear-start_year+1)=iyear+.5;
    
%   plot(tsub*alpha)
%   title(num2str(iyear))
%   hold on
%   plot(tpave*alpha,'r')
%     
%    
%     hold off
%    pause
end


figure(2); clf; orient tall;wysiwyg



subplot(2,1,2)

hold on

p1=plot(tgrid_err,slope_ave_t,'k')
e1=errorbar(tgrid_err,slope_ave_t,error_ave_t,'k');%set(e1,'linewidth',2)

p2=plot(tgrid_err,slope_map_t,'.-b')
e2=errorbar(tgrid_err,slope_map_t,error_map_t);%set(e2,'linewidth',2)

p3=plot(tgrid_err,slope_rep_t,'.-r')
e3=errorbar(tgrid_err,slope_rep_t,error_rep_t,'r');%set(e3,'linewidth',2)

axis([1955 2010 0 1.5])
ylabel('slope [watts m^{-2}] ','fontsize',16);
set(p1,'linewidth',3)
set(gca,'tickdir','out')

xlabel('years','fontsize',16);

title('Slope of Linear Fit to Heat Content Anomaly','fontsize',16);
set(gca,'fontsize',11)

set(p2,'linewidth',3)
set(p1,'linewidth',3)
set(p3,'linewidth',3)

hold off








subplot(2,1,1)
min_year=1993;
max_year=2006;
  
;hold on
p=plot(tgrid,tpave*scale./1e21,'k-*');
ylabel('0-750m Heat Content Anomaly [zeta-joules] ','fontsize',16);
set(p,'linewidth',3)
set(gca,'XTick',[min_year:1:max_year],'tickdir','out')

xlabel('years','fontsize',16);

title(['0-750m Heat Content Anomaly estimated from SSH ',num2str(junk_year)],'fontsize',16);
axis([min_year max_year -100 100])
set(gca,'fontsize',11)


p2=plot(tgrid,tsub_1955_one*scale./1e21,'r-*')
set(p2,'linewidth',3)

p3=plot(tgrid,tsub_1955_map*scale./1e21,'b-*')
set(p3,'linewidth',3)



txt={[' All']; ...
    ['Map'];['Rep' ]};

space=11;
off_set=11;

 txth=text(2002.15,-39,txt,'fontsize',16);
pp=plot([2000.5 2001.5],[-39 -39]+off_set,'k-*')
pp1=plot([2000.5 2001.5],[-39 -39]-space+off_set,'b-*')
pp2=plot([2000.5 2001.5],[-39 -39]-2.*space+off_set,'r-*')
set(pp1,'linewidth',3)
set(pp2,'linewidth',3)
set(pp,'linewidth',3)



hold off



%eval(['print -dpng -f2 /home/shoko/C/','''IDL ps''','/heat/talk/mean_change2_uw_2006_',num2str(junk_year)])
eval(['print -dpng -f2 /home/shoko2/wills/globalhc_dirs/Globalhc/figs/trend_paper/mean_change2_uw_2006_2004_',num2str(junk_year)])

pause
end


%
%eval(['print -dpng -f2 /home/shoko/C/','''IDL ps''','/heat/talk/mean_change2_uw_2006'])

% % df_a=df_a/dof;
% % 
% % %this part adds the 
% % err=sqrt((.6e7)^2+(sqrt(var_t)/sqrt(dof)).^2)+1.1e7;
% % figure
% % e=errorbar(tgrid,tp,err);
% % figure
% % plot(tgrid,err);

