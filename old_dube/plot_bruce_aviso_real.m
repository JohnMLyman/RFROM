function plot_bruce_aviso_real(tsub_one,tsub_map,scale,tgrid,tpave)



min_year=1993;
max_year=2007;

;hold on
p=plot(tgrid,tpave*scale./1e21,'k-*');
ylabel('0-750m OHCA from SSH proxy [zeta-joules] ','fontsize',16);

set(p,'linewidth',4)
set(gca,'XTick',[min_year:1:max_year],'tickdir','out','box','on')

xlabel('Time [years]','fontsize',16);

%title('0-750m OHCA estimated from SSH ','fontsize',16);
axis([min_year max_year -110 110])
set(gca,'fontsize',11)


p2=plot(tgrid,tsub_one*scale./1e21,'--*k')
set(p2,'linewidth',4)

p3=plot(tgrid,tsub_map*scale./1e21,'--*k')
set(p3,'linewidth',2)



% txt={[' All']; ...
%     ['Map'];['Rep' ]};
% 
% space=11;
% off_set=11;
% 
%  txth=text(2002.15,-39,txt,'fontsize',16);
% pp=plot([2000.5 2001.5],[-39 -39]+off_set,'k-*')
% pp1=plot([2000.5 2001.5],[-39 -39]-space+off_set,'b-*')
% pp2=plot([2000.5 2001.5],[-39 -39]-2.*space+off_set,'r-*')
% set(pp1,'linewidth',3)
% set(pp2,'linewidth',3)
% set(pp,'linewidth',3)

gray=[.7 .7 .7];
set(p,'color',gray);

hold off
