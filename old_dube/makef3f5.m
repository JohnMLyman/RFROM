% makef3f5.m - matlab script to make figures 3 and 5 for the globahc paper
% global integrals of heat content and storage

load hcseries

max_ind=length(tgrid);
min_ind=find(tgrid == 1992.75);


max_year=max(tgrid);
min_year=1992;

tgrid=tgrid(min_ind:max_ind);
hc=hc(min_ind:max_ind);
tp=tp(min_ind:max_ind);
df=df(min_ind:max_ind);







close all
figure(1),clf
p=plot(tgrid,hc,'k',tgrid,tp,'k--',tgrid,df,'k:');hold on
set(p,'linewidth',3)



axis([min_year max_year -3.0e8 3.0e8])
set(gca,'fontsize',16)
e=errorbar(tgrid,hc,ones(size(hc))*2.4e7,'k');set(e,'linewidth',1)

ax=axis; dy=diff(ax(3:4));dx=diff(ax(1:2));h=dy*.015;
hold on,pp1=plot(ax(1:2),[1 1]*(ax(3)+h),'k');
pp2=plot(ax(1:2),[1 1]*(ax(4)-h),'k');
pp3=plot(ax(1:2),[1 1]*(ax(4)),'k');
pp3a=plot(ax(1:2),[1 1]*(ax(3)),'k');



w1=num2str((tp(end)-tp(1))/86400/365.25/(tgrid(end)-tgrid(1)),'%4.2f');
w2=num2str((df(end)-df(1))/86400/365.25/(tgrid(end)-tgrid(1)),'%4.2f');
w3=num2str((hc(end)-hc(1))/86400/365.25/(tgrid(end)-tgrid(1)),'%4.2f');

% w1=num2str((tp(50)-tp(4))/86400/365.25/(tgrid(50)-tgrid(4)),'%4.2f');
% w2=num2str((df(50)-df(4))/86400/365.25/(tgrid(50)-tgrid(4)),'%4.2f');
% w3=num2str((hc(50)-hc(4))/86400/365.25/(tgrid(50)-tgrid(4)),'%4.2f');

txt={'warming rates:';['            ',w1,' W/m^2']; ...
['          ',w2,' W/m^2'];['            ',w3,' W/m^2']};
txth=text(1997.15,-1.9e8,txt,'fontsize',16);
pp4=plot([1996 1997]+1, ...
[-1.3e8 -1.3e8;-1.67e8 -1.67e8;-2.07e8 -2.07e8]-.44e8,'k');
set(pp4,'linewidth',3),set(pp4(1),'linestyle','--'),set(pp4(2),'linestyle',':')

for i=1:(dx)
  patch(ax(1)+[0 1 1 0 0]+(i-1)*2,ax(3)+[0 0 h h 0],'k');
  patch(ax(1)+[0 1 1 0 0]+(i-1)*2,ax(4)-[0 0 h h 0],'k');
end
tt=get(gca,'xticklabel');
set(gca,'xticklabel',tt);set(gca,'xtick',[ax(1):2:ax(2)+1]'+.5);
xlabel('year'),ylabel('J/m^2')
l=legend('difference estimate','synthetic estimate','difference field',2);
a1=gca;a=axes('position',get(a1,'position'));

set(a1,'YAxisLocation','left','ygrid','off', ...
'xgrid','off','box','off')

set(a,'YAxisLocation','right','color','none','ygrid','off', ...
'xgrid','off','box','off','xtick',[])
fac=2.2e8*3.4e14; axis(a,[min_year max_year -fac fac])
set(a,'fontsize',16),ylabel('J','rotation',270)

% print plot
print -deps2 -f1 /home/shoko/C/'IDL ps/'heat/f3.eps
print -dpng -f1 /home/shoko/C/'IDL ps/'heat/f3.png




%figure 5

max_ind=length(tg);
min_ind=find(tg == 1993.25);


tg=tg(min_ind:max_ind);
hs=hs(min_ind:max_ind);
ts=ts(min_ind:max_ind);
ds=ds(min_ind:max_ind);






figure(2),clf
p=plot(tg,hs,'k',tg,ts,'k--',tg,ds,'k:');hold on
e=errorbar(tg,hs,hs*0+.6,'k');
set(p,'linewidth',3),set(e,'linewidth',1)
axis([min_year max_year -5 5])
set(gca,'fontsize',16,'ytick',[-5:5])

ax=axis; dy=diff(ax(3:4));dx=diff(ax(1:2));h=dy*.015;
hold on,pp1=plot(ax(1:2),[1 1]*(ax(3)+h),'k');
pp2=plot(ax(1:2),[1 1]*(ax(4)-h),'k');
pp3=plot(ax(1:2),[1 1]*(ax(4)),'k');

% plot zero line
plot(ax(1:2),[0 0],'k--','linewidth',.5)

for i=1:(dx)
  patch(ax(1)+[0 1 1 0 0]+(i-1)*2,ax(3)+[0 0 h h 0],'k');
  patch(ax(1)+[0 1 1 0 0]+(i-1)*2,ax(4)-[0 0 h h 0],'k');
end
tt=get(gca,'xticklabel');
set(gca,'xticklabel',tt);set(gca,'xtick',[ax(1):2:ax(2)+1]'+.5);
xlabel('year'),ylabel('W/m^2')
l=legend('difference estimate','synthetic estimate','difference field',3);
a1=gca;a=axes('position',get(a1,'position'));

set(a1,'YAxisLocation','left','ygrid','off', ...
'xgrid','off','box','off')

set(a,'YAxisLocation','right','color','none','ygrid','off', ...
'xgrid','off','box','off','xtick',[])
fac=5*3.4e14/1e15; axis(a,[min_year max_year -fac fac])
set(a,'fontsize',16),ylabel('pW','rotation',270)

% print plot
print -deps2 -f2 /home/shoko/C/'IDL ps/'heat/f5.eps
print -dpng -f2 /home/shoko/C/'IDL ps/'heat/f5.png


