% makef6.m - matlab script to make figure 6 in global HC paper
% maps of heat storage

load hcseries tgrid
d=sdir('hc*.mat');d=d(1:end-1);

inds=9+4*3:4:length(d);
tgrid=tgrid(inds);
load(d(1).name,'corrhc','lon','lat')
ll=1:3:length(lon);nn=1:3:length(lat);
lon=[lon(end/2+1:end);lon(1:end/2)+360];
lon=lon(ll);lat=lat(nn);
corrhc=[corrhc(end/2+1:end,:);corrhc(1:end/2,:)];

close all
f=figure(1);clf
orient tall 
set(gcf,'paperposition',[.25 .9 8 9.20 ])
pdel=8/8;
nx=2;ny=5;
delx=.90/nx*pdel;dx=(.90/nx-delx)/(nx-1);
dely=.87/ny*pdel;dy=(.87/ny-dely)/(ny-1);

cx=[-75 75];
for i=1:length(tgrid)-1
  load(d(inds(i)).name,'corrhc');
  corrhc=[corrhc(end/2+1:end,:);corrhc(1:end/2,:)];
  hs=corrhc(ll,nn);
  load(d(inds(i)+4).name,'corrhc');
  corrhc=[corrhc(end/2+1:end,:);corrhc(1:end/2,:)];
  hs=(corrhc(ll,nn)-hs)/86400/365.25;
  
  [ii,jj]=ind2sub([nx ny],i); % across rows
  %[jj,ii]=ind2sub([ny nx],i); % down columns
  axes('position',[dx+2*dx*(ii-1)+(ii-1)*delx+.055, ...
	.09+dy+2*dy*(ny-jj)+(ny-jj)*dely,delx,dely])
  pcolor(lon,lat,hs');caxis(cx),shading flat
  axis([0 360 -80 80])
  set(gca,'box','on'),set(gca,'fontsize',16),
  set(gca,'tickdir','out'),set(gca,'ticklength',[.02 .02])
  set(gca,'xaxislocation','top')
  if jj==1&ii==1,set(gca,'xtick',[0 90 180 270 360]'),end
  if jj==1&ii>1,set(gca,'xtick',[90 180 270 360]'),end
  if jj>1,set(gca,'xticklabel',''),end
  if ii>1,set(gca,'yticklabel',''),end
  t=text(60,60,num2str(fix(tgrid(i))));set(t,'fontsize',16)
end

aa=axes('position',[0.055 0.04 .90 .02]);
cc=interp1([0 1],cx,[0:(1/63):1]);
cc=[cc;cc];yy=[0 1];xx=([0:1/63:1]-.5)*diff(mm(cx));
pcolor(xx,yy,cc),shading flat,caxis(cx),set(aa,'xtick',[-60:20:60])
set(aa,'ytick',[]),set(aa,'fontsize',16)

print -depsc2 -painters -r300 -f1  /home/shoko/C/'IDL ps/'heat/f6c.eps
%print -djpeg90 -f1 /moala2/josh/Globalhc/paper/f6.jpg
