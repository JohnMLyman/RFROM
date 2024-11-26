% makef8.m - matlab script to make figure 8 for globalhc paper.  
% interannual variability in global and tropical heat content


clear
close all

load hovs

% make tropical integral
ii=find(abs(lat)<=20);
%ii=find(lat>=-10&lat<=20);
trop=nansum(hovhc(:,ii)'.*repmat(dy(1,ii),[length(tgrid) 1])');

% make global integral
ii=1:length(lat);
glob=nansum(hovhc(:,ii)'.*repmat(dy(1,ii),[length(tgrid) 1])');


% make plot
clf
p=plot(tgrid,trop,'k',tgrid,glob,'k--'),set(p,'linewidth',3)
set(gca,'fontsize',16)
axis([1992 2004 -5e22 8e22]);

l=legend('Tropics','Globe',4);

% make bars for time axis
ax=axis; dy=diff(ax(3:4));dx=diff(ax(1:2));h=dy*.015;
hold on,pp1=plot(ax(1:2),[1 1]*(ax(3)+h),'k');
pp2=plot(ax(1:2),[1 1]*(ax(4)-h),'k');
pp3=plot(ax(1:2),[1 1]*(ax(4)),'k');

for i=1:(dx)
  patch(ax(1)+[0 1 1 0 0]+(i-1)*2,ax(3)+[0 0 h h 0],'k');
  patch(ax(1)+[0 1 1 0 0]+(i-1)*2,ax(4)-[0 0 h h 0],'k');
end
tt=get(gca,'xticklabel');
set(gca,'xticklabel',tt);set(gca,'xtick',[ax(1):2:ax(2)+1]'+.5);
xlabel('year'),ylabel('J')

% print plot
%print -deps2 -f1 /moala2/josh/Globalhc/paper/f8.eps
%print -djpeg90 -r300 -f1 /moala2/josh/Globalhc/paper/f8.jpg


