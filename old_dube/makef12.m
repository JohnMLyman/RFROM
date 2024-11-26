% makef12.m - matlab script to make figure 12 in globalhc paper:
% 9-year difference of heat content from levitus and this paper
% 12/11/03

load levhc
load hcseries hc tgrid

figure(1),clf
n=round(10/mean(diff(levyr)));
levy=levyr(n+1:end)/2+levyr(1:end-n)/2;
levhs=(levhc(n+1:end)-levhc(1:end-n))/86400/365.25/10;
p=plot(levy,levhs/1e15,'k',tgrid(4)/2+tgrid(end)/2, ...
	(hc(end)-hc(4))/365.25/86400/(tgrid(end)-tgrid(4))*3.4e14/1e15,'k*');
set(p,'linewidth',3),set(p(2),'markersize',10)
axis([1955 2005 -.3 .5])
set(gca,'fontsize',16),set(gca,'xtick',[1955:5:2000]')
xlabel('year'),ylabel('Heat Storage (pW)')
legend('Levitus','difference estimate',3)
ax=axis;
hold on,pp=plot([ax(1),ax(2)],[0 0],'k--');
poo=get(gca,'xticklabel');poo(1,:)='    ';set(gca,'xticklabel',poo)

%print -deps2 -f1 /moala2/josh/Globalhc/paper/f12.eps


