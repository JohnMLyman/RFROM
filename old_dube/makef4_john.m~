% makef4.m - matlab script to make 'figure 4' in the global heat content
% paper:  9-year trend in HC from difference estimate and in situ data

 load hovs

lon=[lon(end/2+1:end);lon(1:end/2)+360];
[yyy,xxx]=meshgrid(lat,lon);
dy=gradient(lat)*111e3;
dx=(xxx(2:end,:)-xxx(1:end-1,:));
dx(end+1,:)=dx(1,:);dx=dx.*cos(pi/180*yyy)*111e3;
clear xxx yyy
ii=1:3:length(lon);jj=1:3:length(lat);
load hc2004c corrhc hmap2
hmap2(isnan(corrhc))=NaN;
c2=corrhc;cc2=hmap2;
load hc1994c corrhc hmap2
hmap2(isnan(corrhc))=NaN;
c1=corrhc;cc1=hmap2;
hcslope=(c2-c1)/10/365.25/86400;
hcslope2=(cc2-cc1)/10/365.25/86400;
hcslope=[hcslope(end/2+1:end,:);hcslope(1:end/2,:)];
hcslope2=[hcslope2(end/2+1:end,:);hcslope2(1:end/2,:)];
poo1=nansum(dx.*hcslope)*40/16e7+370;
poo2=nansum(dx.*hcslope2)*40/16e7+370;

% make data availability variable
load allheat cds ht topex dt
goo
nn=find(~isnan(ht+topex(:,1)+topex(:,2)));
cds=cds(nn,:);clear nn ht topex
nn=find(cds(:,1)<=0);cds(nn,1)=cds(nn,1)+360;
x=[5:10:360];y=[-85:10:85];[yy,xx]=meshgrid(y,x);
n=xx*0;
tic,for i=1:length(xx(:))
  n(i)=length(find(abs(cds(:,1)-xx(i))<=5&abs(cds(:,2)-yy(i))<=5));
  if mod(i,10)==0,disp(num2str([i toc])),end
end

f=figure(1);clf;set(f,'position',[372 30 668 724])
subplot(3,1,1)
pcolor(lon(ii),lat(jj),hcslope(ii,jj)'),shading flat,caxis([-12 12])
axis([0 400 -80 80]),hold on,set(gca,'fontsize',16)
p=plot(poo1,lat);set(p,'linewidth',3)
pp=plot([370 370],[-80 80],'k');
h=[0:100:300,370,400];hh='';
set(gca,'xtick',h);set(gca,'xticklabel',hh,'tickdir','out')
%  c=narrow_colorbar;set([c],'fontsize',16)
t1=text(445,20,'W/m^2');set(t1,'fontsize',16,'rotation',270)
t2=text(5,97,'a).');set(t2,'fontsize',16,'fontweight','bold')
t13=text(373,104,'W/m');set(t13,'fontsize',14)
t14=text(366,89,'0');set(t14,'fontsize',14)
t15=text(386,89,'12e7');set(t15,'fontsize',14)

subplot(3,1,2)
pcolor(lon(ii),lat(jj),hcslope2(ii,jj)'),shading flat,caxis([-12 12])
axis([0 400 -80 80]),hold on,set(gca,'fontsize',16)
p=plot(poo2,lat);set(p,'linewidth',3)
pp=plot([370 370],[-80 80],'k');
h=[0:100:300,370,400];hh='';
set(gca,'xtick',h);set(gca,'xticklabel',hh,'tickdir','out')
% c=narrow_colorbar;set([c],'fontsize',16)
t1=text(445,20,'W/m^2');set(t1,'fontsize',16,'rotation',270)
t2=text(5,97,'b).');set(t2,'fontsize',16,'fontweight','bold')
t23=text(373,104,'W/m');set(t23,'fontsize',14)
t24=text(366,89,'0');set(t24,'fontsize',14)
t25=text(386,89,'12e7');set(t25,'fontsize',14)

subplot(3,1,3)
% cc=coast;cc2=cc;cc2(:,2)=cc2(:,2)+360;cc=[cc;cc2];cc(cc(:,2)<0,:)=NaN;
% cc(cc(:,2)>360,:)=NaN;
% plot(cc(:,2),cc(:,1),'k')
axis([0 400 -80 80]),hold on,set(gca,'fontsize',16)
n(n<=20)=NaN;
ll=find(~isnan(n));[yy,xx]=meshgrid(y,x);
scatter(xx(ll),yy(ll),15,log10(n(ll)),'filled')
set(gca,'xtick',[0:100:300])
% c=narrow_colorbar;set(c,'fontsize',16,'ytick',[2 3 4])
% set(c,'yticklabel',['100   ';'1000  ';'10,000'])
t2=text(5,97,'c).');set(t2,'fontsize',16,'fontweight','bold')

orient tall

%print -depsc2 -f1 -painters -r300 /moala2/josh/Globalhc/paper/f4.eps
%print -djpeg90 -f1 -zbuffer -r0 /moala2/josh/Globalhc/paper/f4.jpg


