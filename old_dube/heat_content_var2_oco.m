% this code computes and plots the ten year trend in heat content.

% df is the estimate of the subsambled TOPEX
% tp is the estimate form the whole TOPEX record
% per_var_t  is percent of the subsampled field in the 95% cofidence interval 
% tsub in the maped topex var
% tpave is the unmaped variabilty 


clear
close all
%alpha is in J/m^2 /(cm)
alpha=(.6e7)/(.04);
for junk_year=1955:2005
    
for iyear=1950:2005
    
    load (['hcseries2_twin_',num2str(iyear)])
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

if iyear==junk_year
    tsub_1955=tsub;
end

if iyear==2005
    tsub_2005=tsub;
end


    per_var=sum((abs(tsub-tpave)).^2)/sum((tsub).^2);
   % std_error(iyear-1949)=student(N)*(sum((tsub-tpave).^2))/N)*alpha*3.4e14
   
   diff=abs(tsub)-abs(tpave)
   
   pos_pos=find(diff >=0);
   pos_neg=find(diff <0);
   
   
   
 %   std_error(iyear-1949)=sqrt(f1.^2+f2.^2)*3.4e14;
%    std_dev(iyear-1949)=sqrt((f2./student(36)).^2+(f1./student(N)).^2)*3.4e14;
    %std_dev=std_error;
   % std_error(iyear-1949)=student(N)*(sum((tsub-tpave).^2)/N)*alpha*3.4e14
    
   %std_error(iyear-1949)=((student(N)*sum((tsub-tpave).^2)/(N))*alpha)*3.4e14
    pos_diff(iyear-1949)=sum(diff(pos_pos))/length(pos_pos);
    neg_diff(iyear-1949)=sum(diff(pos_neg))/length(pos_neg);
% %     df_a=df+df_a;
% %     df_t=[df_t,df'];
    tgrid_err(iyear-1949)=iyear+.5;
    
%   plot(tsub*alpha)
%   title(num2str(iyear))
%   hold on
%   plot(tpave*alpha,'r')
%     
%    
%     hold off
%    pause
end
scale=alpha*3.4e14

figure(2); clf; orient tall;wysiwyg



subplot(2,1,2)

hold on 
p=plot(tgrid_err,pos_diff*scale,'k-*')
p2=plot(tgrid_err,neg_diff*scale,'k-*')
p3=plot([1950 2010],[0 0],'k-')

ylabel('Diffenerce in 0-750m Heat Content Anomaly [J] ','fontsize',16);
set(p,'linewidth',3)
set(gca,'tickdir','out')

xlabel('years','fontsize',16);

title('Mean difference in Heat Content Anomaly estimates','fontsize',16);
set(gca,'fontsize',11)

set(p2,'linewidth',3)
set(p,'linewidth',3)


hold off








subplot(2,1,1)
min_year=1993;
max_year=2006;

;hold on
p=plot(tgrid,tpave*scale,'k-*');
ylabel('0-750m Heat Content Anomaly [J] ','fontsize',16);
set(p,'linewidth',3)
set(gca,'XTick',[min_year:1:max_year],'tickdir','out')

xlabel('years','fontsize',16);

title('0-750m Heat Content Anomaly estimated from SSH','fontsize',16);
axis([min_year max_year -7.0e22 7.0e22])
set(gca,'fontsize',11)


p2=plot(tgrid,tsub_1955*scale,'r-*')
set(p2,'linewidth',3)

p3=plot(tgrid,tsub_2005*scale,'b-*')
set(p3,'linewidth',3)



txt={[' All']; ...
    ['2005'];[num2str(junk_year)]};

space=1.1e22;
off_set=1.1e22;

 txth=text(1999.15,-3.9e22,txt,'fontsize',16);
pp=plot([2000.5 2001.5],[-3.9e22 -3.9e22]+off_set,'k-*')
pp1=plot([2000.5 2001.5],[-3.9e22 -3.9e22]-space+off_set,'b-*')
pp2=plot([2000.5 2001.5],[-3.9e22 -3.9e22]-2.*space+off_set,'r-*')
set(pp1,'linewidth',3)
set(pp2,'linewidth',3)
set(pp,'linewidth',3)



hold off

pause
end



%eval(['print -dpng -f2 /home/shoko/C/','''IDL ps''','/heat/oco/mean_change_wunsch'])

% % df_a=df_a/dof;
% % 
% % %this part adds the 
% % err=sqrt((.6e7)^2+(sqrt(var_t)/sqrt(dof)).^2)+1.1e7;
% % figure
% % e=errorbar(tgrid,tp,err);
% % figure
% % plot(tgrid,err);

