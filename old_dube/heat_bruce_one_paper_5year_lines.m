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

for junk_year=2005:2005
    
for iyear=start_year:2005
    
    one_pos=find(time == iyear+.5);
    one_scale=hc_one(one_pos);
    
    
    load (['hcseries2_twin_',num2str(iyear)])
    good=find(tgrid <= 2006);
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
% seperate the time into 5 sections 1993-1997, 1995-1999,1997-2001,1999-2003,2001-2005

pos1=find(tgrid>= 1993.5 & tgrid<=1997.5);
pos2=find(tgrid>= 1995.5 & tgrid<=1999.5);
pos3=find(tgrid>= 1997.5 & tgrid<=2001.5);
pos4=find(tgrid>= 1999.5 & tgrid<=2003.5);
pos5=find(tgrid>= 2001.5 & tgrid<=2005.5);

t2=[-2,-1,0,1,2];

[y_model,y_model_err_95,slope_error_map1,slope_map1]=j_fit(t2,tsub(pos1),1);
[y_model,y_model_err_95,slope_error_map2,slope_map2]=j_fit(t2,tsub(pos2),1);
[y_model,y_model_err_95,slope_error_map3,slope_map3]=j_fit(t2,tsub(pos3),1);
[y_model,y_model_err_95,slope_error_map4,slope_map4]=j_fit(t2,tsub(pos4),1);
[y_model,y_model_err_95,slope_error_map5,slope_map5]=j_fit(t2,tsub(pos5),1);

if iyear==junk_year
    tsub_1955_map=tsub;
end
%ttsub=tsub;
tsub=tsub./one_scale;


[y_model,y_model_err_95,slope_error_rep1,slope_rep1]=j_fit(t2,tsub(pos1),1);
[y_model,y_model_err_95,slope_error_rep2,slope_rep2]=j_fit(t2,tsub(pos2),1);
[y_model,y_model_err_95,slope_error_rep3,slope_rep3]=j_fit(t2,tsub(pos3),1);
[y_model,y_model_err_95,slope_error_rep4,slope_rep4]=j_fit(t2,tsub(pos4),1);
[y_model,y_model_err_95,slope_error_rep5,slope_rep5]=j_fit(t2,tsub(pos5),1);

[y_model,y_model_err_95,slope_error_ave1,slope_ave1]=j_fit(t2,tpave(pos1),1);
[y_model,y_model_err_95,slope_error_ave2,slope_ave2]=j_fit(t2,tpave(pos2),1);
[y_model,y_model_err_95,slope_error_ave3,slope_ave3]=j_fit(t2,tpave(pos3),1);
[y_model,y_model_err_95,slope_error_ave4,slope_ave4]=j_fit(t2,tpave(pos4),1);
[y_model,y_model_err_95,slope_error_ave5,slope_ave5]=j_fit(t2,tpave(pos5),1);

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
    
    slope_map_t1(iyear-start_year+1)=slope_map1*scale./area_of_earth/86400/365.25;
    slope_rep_t1(iyear-start_year+1)=slope_rep1*scale./area_of_earth/86400/365.25;
    slope_ave_t1(iyear-start_year+1)=slope_ave1*scale./area_of_earth/86400/365.25;
    
    slope_map_t2(iyear-start_year+1)=slope_map2*scale./area_of_earth/86400/365.25;
    slope_rep_t2(iyear-start_year+1)=slope_rep2*scale./area_of_earth/86400/365.25;
    slope_ave_t2(iyear-start_year+1)=slope_ave2*scale./area_of_earth/86400/365.25;

    slope_map_t3(iyear-start_year+1)=slope_map3*scale./area_of_earth/86400/365.25;
    slope_rep_t3(iyear-start_year+1)=slope_rep3*scale./area_of_earth/86400/365.25;
    slope_ave_t3(iyear-start_year+1)=slope_ave3*scale./area_of_earth/86400/365.25;


    slope_map_t4(iyear-start_year+1)=slope_map4*scale./area_of_earth/86400/365.25;
    slope_rep_t4(iyear-start_year+1)=slope_rep4*scale./area_of_earth/86400/365.25;
    slope_ave_t4(iyear-start_year+1)=slope_ave4*scale./area_of_earth/86400/365.25;
    
    slope_map_t5(iyear-start_year+1)=slope_map5*scale./area_of_earth/86400/365.25;
    slope_rep_t5(iyear-start_year+1)=slope_rep5*scale./area_of_earth/86400/365.25;
    slope_ave_t5(iyear-start_year+1)=slope_ave5*scale./area_of_earth/86400/365.25;

    error_map_t1(iyear-start_year+1)=slope_error_map1*scale./area_of_earth/86400/365.25;
    error_rep_t1(iyear-start_year+1)=slope_error_rep1*scale./area_of_earth/86400/365.25;
    error_ave_t1(iyear-start_year+1)=slope_error_ave1*scale./area_of_earth/86400/365.25;

    error_map_t2(iyear-start_year+1)=slope_error_map2*scale./area_of_earth/86400/365.25;
    error_rep_t2(iyear-start_year+1)=slope_error_rep2*scale./area_of_earth/86400/365.25;
    error_ave_t2(iyear-start_year+1)=slope_error_ave2*scale./area_of_earth/86400/365.25;

    error_map_t3(iyear-start_year+1)=slope_error_map3*scale./area_of_earth/86400/365.25;
    error_rep_t3(iyear-start_year+1)=slope_error_rep3*scale./area_of_earth/86400/365.25;
    error_ave_t3(iyear-start_year+1)=slope_error_ave3*scale./area_of_earth/86400/365.25;

    error_map_t4(iyear-start_year+1)=slope_error_map4*scale./area_of_earth/86400/365.25;
    error_rep_t4(iyear-start_year+1)=slope_error_rep4*scale./area_of_earth/86400/365.25;
    error_ave_t4(iyear-start_year+1)=slope_error_ave4*scale./area_of_earth/86400/365.25;

    error_map_t5(iyear-start_year+1)=slope_error_map5*scale./area_of_earth/86400/365.25;
    error_rep_t5(iyear-start_year+1)=slope_error_rep5*scale./area_of_earth/86400/365.25;
    error_ave_t5(iyear-start_year+1)=slope_error_ave5*scale./area_of_earth/86400/365.25;
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


figure(1); clf; orient tall;wysiwyg



subplot(2,1,1)
 plot_slope_error(tgrid_err,error_map_t1,error_rep_t1,error_ave_t1,...
        slope_map_t1,slope_rep_t1,slope_ave_t1)


subplot(2,1,2)
 plot_slope_error(tgrid_err,error_map_t2,error_rep_t2,error_ave_t2,...
        slope_map_t2,slope_rep_t2,slope_ave_t2)

figure(2); clf; orient tall;wysiwyg
subplot(2,1,1)
 plot_slope_error(tgrid_err,error_map_t3,error_rep_t3,error_ave_t3,...
        slope_map_t3,slope_rep_t3,slope_ave_t3)
subplot(2,1,2)
 plot_slope_error(tgrid_err,error_map_t4,error_rep_t4,error_ave_t4,...
        slope_map_t4,slope_rep_t4,slope_ave_t4)

figure(3); clf; orient tall;wysiwyg
subplot(2,1,1)
 plot_slope_error(tgrid_err,error_map_t5,error_rep_t5,error_ave_t5,...
        slope_map_t5,slope_rep_t5,slope_ave_t5)





%subplot(2,1,1)
%min_year=1993;
%max_year=2006;
  
%;hold on
%p=plot(tgrid,tpave*scale./1e21,'k-*');
%ylabel('0-750m Heat Content Anomaly [zeta-joules] ','fontsize',16);
%set(p,'linewidth',3)
%set(gca,'XTick',[min_year:1:max_year],'tickdir','out')

%xlabel('years','fontsize',16);

%title(['0-750m Heat Content Anomaly estimated from SSH ',num2str(junk_year)],'fontsize',16);
%axis([min_year max_year -100 100])
%set(gca,'fontsize',11)


%p2=plot(tgrid,tsub_1955_one*scale./1e21,'r-*')
%set(p2,'linewidth',3)

%p3=plot(tgrid,tsub_1955_map*scale./1e21,'b-*')
%set(p3,'linewidth',3)



%txt={[' All']; ...
%    ['Map'];['Rep' ]};

%space=11;
%off_set=11;

% txth=text(2002.15,-39,txt,'fontsize',16);
%pp=plot([2000.5 2001.5],[-39 -39]+off_set,'k-*')
%pp1=plot([2000.5 2001.5],[-39 -39]-space+off_set,'b-*')
%pp2=plot([2000.5 2001.5],[-39 -39]-2.*space+off_set,'r-*')
%set(pp1,'linewidth',3)
%set(pp2,'linewidth',3)
%set(pp,'linewidth',3)



%hold off



%eval(['print -dpng -f2 /home/shoko2/figs/trend_paper/mean_one_map_5_year_',num2str(junk_year)])


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

