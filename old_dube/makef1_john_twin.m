% makef1.m - matlab script to make figure 1 for globalhc paper:
% data coverage and time series of data availability

load allheat_twin_2000 dt cds topex ht
ht=topex(:,1);
%ii=find(~isnan(ht+topex(:,1)+topex(:,2)));
% ii=find(~isnan(ht));
% dt=dt(ii,:);cds=cds(ii,:);
%ll=coast;

clf
for iyear =1993:2004
figure  
subplot(3,1,1)
%p=plot(ll(:,2),ll(:,1),'k');set(p,'linewidth',1);hold on
ii=find(dt(:,1)==iyear);
ii_1994=find(dt(:,1)==2000);
m_ungrid m_proj;
m_proj('Equidistant Cylindrical','long',[30 390],'lat',[-90 90]);
 m_coast;
 m_grid;
 hold on
m_plot(cds(ii,1),cds(ii,2),'.r')

m_plot(cds(ii,1)+360,cds(ii,2),'.r')

m_plot(cds(ii_1994,1),cds(ii_1994,2),'.k')

m_plot(cds(ii_1994,1)+360,cds(ii_1994,2),'.k')
iyear
length(ii)
'1994'
length(ii_1994)

hold off
subplot(3,1,2)
hold on
% m_ungrid m_proj;
% m_proj('Equidistant Cylindrical','long',[30 390],'lat',[-90 90]);
%  m_coast;
%  m_grid;
% 
% m_plot(cds(ii,1),cds(ii,2),'.r')
% 
% m_plot(cds(ii,1)+360,cds(ii,2),'.r')

plot(cds(ii,1),cds(ii,2),'.r')
plot(cds(ii_1994,1),cds(ii_1994,2),'.k')

hold off
% % p2=plot(cds(ii,1),cds(ii,2),'k.','MarkerSize',5);%set(p2,'markersize',10)
% % axis([-180 180 -90 90])
title(num2str(iyear))
% % set(gca,'fontsize',16)
% % t1=text(-210,107,'a).','fontsize',16,'fontweight','bold');
end




subplot(3,1,3)
n=hist(dt(:,1),[1960:2006]);h=bar(1960:2006,n/1e3,'k');
%axis([1992.4 2003.6 0 200])
axis([1992.4 2005.6 0 200])
set(gca,'fontsize',16)
%set(gca,'yticklabelmode','manual')
%set(gca,'ytick',[0:20000:140000]')
%set(gca,'yticklabel',strvcat(num2str([0:20000:140000]')))
xlabel('year'),ylabel('thousands of profiles')
%t=text(1991.5,70000,'profiles','rotation',90);
%set(t,'fontsize',16,'horizontalalignment','center')
%t2=text(1988.6,218,'b).','fontsize',16,'fontweight','bold');

orient tall

% print plot
% print -deps2 -f1 /home/shoko/C/'IDL ps/'heat/f1_1994_2004.eps
% print -dpng -f1 /home/shoko/C/'IDL ps/'heat/f1_1994_2004.png
% %print -djpeg90 -f1 /moala2/josh/Globalhc/paper/f1.jpg

