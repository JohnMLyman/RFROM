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

max_ind=length(tgrid);
min_ind=find(tgrid == 1993.5);
max_ind=find(tgrid == 2005.5);

%sdfga




dof_alpha=300*.2;
dof=13;
max_year=2006;
min_year=1992;

tgrid=tgrid(min_ind:max_ind);
hc=hc(min_ind:max_ind);
hc2=hc2(min_ind:max_ind);

tp=tp(min_ind:max_ind);
df=df(min_ind:max_ind);

new=find(tgrid > 2004.5);



per_var2=interp1(tgrid_err,per_var_t,tgrid);
alpha_error2=interp1(tgrid_alpha,alpha_error,tgrid);
tp_alone_error2=interp1(tgrid_alpha,tp_alone_error,tgrid);
slope_error2=interp1(tgrid_slope_error,slope_error,tgrid);

% now compute the amount of varience in the difference field and mulitiply
% it by the amount of varience in the diference field
% .6e7 is a random error expressed as the standard deviation of the mean and 
%   is computed from a TOPEX estimate of SSH computed in Wills 2004 
% 13 dof for student-t with the samp error because there were 13 estimates
%   that determined the std, but it is not divided by sqrt(13) becuase only
%   one estimate was used (ie only one world)

mean_df=sum(df)/length(df);
samp_error=sqrt((per_var2*(sum((df-mean_df).^2)/length(hc))));

error=sqrt((student(36)*.6e7)^2+(samp_error*student(13)).^2+(alpha_error2*student(dof_alpha)./(sqrt(dof_alpha/300))).^2);


mean_hc2=sum(hc2)/length(hc2);
error_xbt_samp=student(13)*sqrt(per_var2*(sum((hc2-mean_hc2).^2)/length(hc2)));
error_xbt=sqrt((student(36)*.6e7)^2+error_xbt_samp.^2);



error_xbt_tp_samp=samp_error*student(13);
error_alpha=(alpha_error2*student(dof_alpha)./(sqrt(dof_alpha/300)));

error_tp_alpha=tp_alone_error2*student(dof_alpha)./(sqrt(dof_alpha/300));
error_tp=sqrt((student(36)*.6e7)^2+(error_tp_alpha).^2);

std_error=sqrt((.6e7)^2+(samp_error).^2+(alpha_error2).^2);
std_error_tp=sqrt((.6e7)^2+(error_tp_alpha./student(dof_alpha)).^2);
std_error_hc2=sqrt((.6e7)^2+(error_xbt_samp./student(13)).^2);




samp_error=error;

close all
figure(2),clf



%p=plot(tgrid,hc,'k',tgrid,tp,'k--',tgrid,df,'k:');hold on
p=plot(tgrid,hc,'k');hold on
pp4=plot(tgrid,hc2,'k:');
pp7=plot(tgrid,tp,'k--');
set(p,'linewidth',3)



axis([min_year max_year -3.0e8 3.0e8])
set(gca,'fontsize',16)


e1=errorbar(tgrid,hc2,error_xbt,'g');set(e1,'linewidth',1)
e2=errorbar(tgrid,tp,error_tp,'b');set(e2,'linewidth',1)
e=errorbar(tgrid,hc,error,'k');set(e,'linewidth',1)

ax=axis; dy=diff(ax(3:4));dx=diff(ax(1:2));h=dy*.015;
hold on,pp1=plot(ax(1:2),[1 1]*(ax(3)+h),'k');
pp2=plot(ax(1:2),[1 1]*(ax(4)-h),'k');
pp3=plot(ax(1:2),[1 1]*(ax(4)),'k');
pp3a=plot(ax(1:2),[1 1]*(ax(3)),'k');


% plot the new estimates that uses the realtime ssh from Aviso

p_new=plot(tgrid(new),hc(new),'r');
set(p_new,'linewidth',3)
e_new=errorbar(tgrid(new),hc(new),error(new),'r');set(e_new,'linewidth',1)


%[y_model,y_model_err_95,slope_error_tp,sl_tp]=j_fit(tgrid,tp)
%[y_model,y_model_err_95,slope_error_df,sl_df]=j_fit(tgrid,df)
% [y_model,y_model_err_95,slope_error_hc,sl_hc]=j_fit(tgrid,hc)

scale_fit_hc=std(hc)./std(tgrid);
scale_fit_hc2=std(hc2)./std(tgrid);
scale_fit_tp=std(tp)./std(tgrid);

hc_2=hc./scale_fit_hc;
tp_2=tp./scale_fit_tp;
hc2_2=hc2./scale_fit_hc2;

std_error=std_error./scale_fit_hc;
std_error_hc2=std_error_hc2./scale_fit_hc2;
std_error_tp=std_error_tp./scale_fit_tp;

w_hc=1./(std_error.^2);
w_hc2=1./(std_error_hc2.^2);
w_tp=1./(std_error_tp.^2);

 [y_model,y_model_err_95,slope_error_tp,sl_tp]=j_fit_weighted(tgrid,tp_2,w_tp)
 [y_model,y_model_err_95,slope_error_hc2,sl_hc2]=j_fit_weighted(tgrid,hc2_2,w_hc2)
 [y_model,y_model_err_95,slope_error_hc,sl_hc]=j_fit_weighted(tgrid,hc_2,w_hc)

 slope_error_hc=slope_error_hc*scale_fit_hc;
 sl_hc=sl_hc*scale_fit_hc;
 
 
slope_error_hc2=slope_error_hc2*scale_fit_hc2;
sl_hc2=sl_hc2*scale_fit_hc2;
 
slope_error_tp=slope_error_tp*scale_fit_tp;
sl_tp=sl_tp*scale_fit_tp;
 


w1=num2str(sl_tp/86400/365.25,'%4.2f');
w2=num2str(sl_hc2/86400/365.25,'%4.2f');
w3=num2str(sl_hc/86400/365.25,'%4.2f');

w1_err=num2str(slope_error_tp/86400/365.25,'%4.2f');
w2_err=num2str(slope_error_hc2/86400/365.25,'%4.2f');
w3_err=num2str(slope_error_hc/86400/365.25,'%4.2f');
% w1=num2str((tp(50)-tp(4))/86400/365.25/(tgrid(50)-tgrid(4)),'%4.2f');
% w2=num2str((df(50)-df(4))/86400/365.25/(tgrid(50)-tgrid(4)),'%4.2f');
% w3=num2str((hc(50)-hc(4))/86400/365.25/(tgrid(50)-tgrid(4)),'%4.2f');

% txt={'warming rates:';['            ',w1,'\pm',w1_err,' W/m^2']; ...
% ['          ',w2,'\pm',w2_err,' W/m^2'];['            ',w3,'\pm',w3_err,' W/m^2']};
% txth=text(1997.15,-1.9e8,txt,'fontsize',16);
% pp4=plot([1996 1997]+1, ...
% [-1.3e8 -1.3e8;-1.67e8 -1.67e8;-2.07e8 -2.07e8]-.44e8,'k');
% set(pp4,'linewidth',3),set(pp4(1),'linestyle','--'),set(pp4(2),'linestyle',':')


txt={'warming rates:'; ...
['            ',w3,'\pm',w3_err,' W/m^2']};
txth=text(1997.15,-1.9e8,txt,'fontsize',16);
pp4=plot([1996 1997]+1, ...
[-1.67e8 -1.67e8]-.44e8,'k');
set(pp4,'linewidth',3)

for i=1:(dx)
  patch(ax(1)+[0 1 1 0 0]+(i-1)*2,ax(3)+[0 0 h h 0],'k');
  patch(ax(1)+[0 1 1 0 0]+(i-1)*2,ax(4)-[0 0 h h 0],'k');
end
tt=get(gca,'xticklabel');
set(gca,'xticklabel',tt);set(gca,'xtick',[ax(1):2:ax(2)+1]'+.5);
xlabel('year'),ylabel('J/m^2')
%l=legend('difference estimate','synthetic estimate','difference field',2);
a1=gca;a=axes('position',get(a1,'position'));

set(a1,'YAxisLocation','left','ygrid','off', ...
'xgrid','off','box','off')

set(a,'YAxisLocation','right','color','none','ygrid','off', ...
'xgrid','off','box','off','xtick',[])
fac=2.2e8*3.4e14; axis(a,[min_year max_year -fac fac])
set(a,'fontsize',16),ylabel('J','rotation',270)

% print plot
% print -deps2 -f1 /home/shoko/C/'IDL ps/'heat/f3_john2.eps
print -dpng -f2 /home/shoko/C/'IDL ps/'heat/f3_john_new.png


%figure 5
% % 
% % max_ind=length(tg);
% % min_ind=find(tg == 1993.25);
% % 
% % 
% % 
% % tg=tg(min_ind:max_ind);
% % hs=hs(min_ind:max_ind);
% % ts=ts(min_ind:max_ind);
% % ds=ds(min_ind:max_ind);
% % 
% % 
% % 
% % 
% % 
% % 
% % figure(2),clf
% % 
% % err2=interp1(tgrid_err,err,tg);
% % 
% % p-2.07e8 -2.07e8=plot(tg,hs,'k',tg,ts,'k--',tg,ds,'k:');hold on
% % e=errorbar(tg,hs,err2*2.5e-8,'k');
% % set(p,'linewidth',3),set(e,'linewidth',1)
% % axis([min_year max_year -5 5])
% % set(gca,'fontsize',16,'ytick',[-5:5])
% % 
% % ax=axis; dy=diff(ax(3:4));dx=diff(ax(1:2));h=dy*.015;
% % hold on,pp1=plot(ax(1:2),[1 1]*(ax(3)+h),'k');
% % pp2=plot(ax(1:2),[1 1]*(ax(4)-h),'k');
% % pp3=plot(ax(1:2),[1 1]*(ax(4)),'k');
% % 
% % % plot zero line
% % plot(ax(1:2),[0 0],'k--','linewidth',.5)
% % 
% % for i=1:(dx)
% %  -2.07e8 -2.07e8 patch(ax(1)+[0 1 1 0 0]+(i-1)*2,ax(3)+[0 0 h h 0],'k');
% %   patch(ax(1)+[0 1 1 0 0]+(i-1)*2,ax(4)-[0 0 h h 0],'k');
% % end
% % tt=get(gca,'xticklabel');
% % %set(gca,'xticklabel',tt);set(gca,'xtick',[ax(1):2:ax(2)+1]'+.5);
% % xlabel('year'),ylabel('W/m^2')
% % l=legend('difference estimate','synthetic estimate','difference field',3);
% % a1=gca;a=axes('position',get(a1,'position'));
% % 
% % set(a1,'YAxisLocation','left','ygrid','off', ...
% % 'xgrid','off','box','off')
% % 
% % set(a,'YAxisLocation','right','color','none','ygrid','off', ...
% % 'xgrid','off','box','off','xtick',[])
% % fac=5*3.4e14/1e15; axis(a,[min_year max_year -fac fac])
% % set(a,'fontsize',16),ylabel('pW','rotation',270)
% % 
% % % print plot
% % print -deps2 -f2 /home/shoko/C/'IDL ps/'heat/f5_john.eps
% % print -dpng -f2 /home/shoko/C/'IDL ps/'heat/f5_john.png
% % 
% % 
% % 


%%%%%%%%%%%%%%%%%%%
%%%%figure new!%%%%
% % % %%%%%%%%%%%%%%%%%%%
% % % figure(4),clf
% % % 
% % % 
% % % 
% % % p=plot(tgrid,samp_error,'k');
% % % figure(4),clf
% % % 
% % % 
% % % 
% % % p=plot(tgrid,samp_error,'k');hold on
% % % 
% % % %error bar baised on chisqr distribution and a 95% confidence interval
% % % 
% % % e=errorbar(tgrid,samp_error,samp_error-samp_error*.71,samp_error*1.65-samp_error,'k');
% % % 
% % % %e=errorbar(tgrid,samp_error,samp_error*.71,samp_error*1.65,'k');
% % % % plot(tgrid,samp_error*.71,'r')
% % % % plot(tgrid,samp_error*1.65,'r')
% % % set(p,'linewidth',3)
% % % 
% % % 
% % % 
% % % axis([min_year max_year .0e8 1.3e8])
% % % set(gca,'fontsize',16)
% % % 
% % % ax=axis; dy=diff(ax(3:4));dx=diff(ax(1:2));h=dy*.015;
% % % hold on,pp1=plot(ax(1:2),[1 1]*(ax(3)+h),'k');
% % % pp2=plot(ax(1:2),[1 1]*(ax(4)-h),'k');
% % % pp3=plot(ax(1:2),[1 1]*(ax(4)),'k');
% % % pp3a=plot(ax(1:2),[1 1]*(ax(3)),'k');
% % % 
% % % 
% % % 
% % % % w1=num2str((tp(50)-tp(4))/86400/365.25/(tgrid(50)-tgrid(4)),'%4.2f');
% % % % w2=num2str((df(50)-df(4))/86400/365.25/(tgrid(50)-tgrid(4)),'%4.2f');
% % % % w3=num2str((hc(50)-hc(4))/86400/365.25/(tgrid(50)-tgrid(4)),'%4.2f');
% % % 
% % % 
% % % pp4=plot([1996 1997]+1, ...
% % % [-1.3e8 -1.3e8;-1.67e8 -1.67e8;-2.07e8 -2.07e8]-.44e8,'k');
% % % set(pp4,'linewidth',3),set(pp4(1),'linestyle','--'),set(pp4(2),'linestyle',':')
% % % 
% % % for i=1:(dx)
% % %   patch(ax(1)+[0 1 1 0 0]+(i-1)*2,ax(3)+[0 0 h h 0],'k');
% % %   patch(ax(1)+[0 1 1 0 0]+(i-1)*2,ax(4)-[0 0 h h 0],'k');
% % % end
% % % tt=get(gca,'xticklabel');
% % % set(gca,'xticklabel',tt);set(gca,'xtick',[ax(1):2:ax(2)+1]'+.5);
% % % xlabel('year'),ylabel('J/m^2')
% % % a1=gca;a=axes('position',get(a1,'position'));
% % % 
% % % %set(a1,'YAxisLocation','left','ygrid','off', ...
% % % %'xgrid','off','box','off')
% % % 
% % % set(a,'YAxisLocation','right','color','none','ygrid','off', ...
% % % 'xgrid','off','box','off','xtick',[])
% % %  axis(a,[min_year max_year 0e8 1.3e8])
% % % set(a,'fontsize',16)
% % % title('sampling error')
% print plot
% print -deps2 -f3 /home/shoko/C/'IDL ps/'heat/ferror_john2.eps
% print -dpng -f3 /home/shoko/C/'IDL ps/'heat/ferror_john2.png

