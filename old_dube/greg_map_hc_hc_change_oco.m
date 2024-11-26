

% load the data

load slope_heat2_agu

% put into the proper coordinates

ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
slope=[slope(jj,:);slope(ii,:)];
error=[error(jj,:);error(ii,:)];

% get rid of some junk in error

ii=find(finite(slope)==0);
error(ii)=NaN;

% make a ratio of slope to error in slope

r=abs(slope)./error;

% make the figures

figure; orient tall; wysiwyg

subplot(2,1,1)
colormap jet(256)
slope=slope/24/365.25/3600;
too_low=find(slope <= -8);
slope(too_low)=-8.;

pcolor(lon,lat,slope')
offset=-1.*(25/255)

caxis([(-8+offset) 8])
shading flat
axis([30 390 -90 90])
axis equal
axis([30 390 -90 90])
set(gca,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
hold on
[cs,h]=contour(lon,lat,r',[1 1],'k');

j=axes('pos',[.13 .85 .775 .02]);
colormap jet(256)

min_colorbar=-8-offset

[cs,h]=contourf([-8:.01:8],[0 1],[1 1]'*[(-8-(offset)):.01:(8-(offset))],[-8:(8+8)/254:8]);
set(h,'edgecolor','none')
set(j,'tickdir','out','xaxisl','top','xtick',[-12:2:12],'ytick',[])
caxis([-12 12])
xlabel('13-year Heat Content Change [W m^{-2}]')


subplot(2,1,2)
colormap jet(256)
pcolor(lon,lat,r')
shading flat
caxis([1 3])
axis([30 390 -90 90])
axis equal
axis([30 390 -90 90])
set(gca,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])

% fool with the colormap

c=colormap;
c(1,:)=2/3;
colormap(c)

j=axes('pos',[.13 .10 .775 .02]);
colormap(c)
[cs,h]=contourf([1:.01:3],[0 1],[1 1]'*[1:.01:3],[1:(3-1)/255:3]);
set(h,'edgecolor','none')
set(j,'tickdir','out','xaxisl','bot','xtick',[1:.25:3],'ytick',[])
caxis([1 3])
xlabel('Ratio of Heat  Content Change to 95% Uncertainty')

% now shift the plots around on the page

down=.1

q=get(gcf,'children');
a2=get(q(1),'pos');
a4=get(q(2),'pos');
a3=get(q(3),'pos');
a5=get(q(4),'pos');

aa=(1-a2(4)*2)/2;
a2(2)=aa;
a4(2)=aa+a2(4);
set(q(2),'pos',a4-[0 (down+.25) 0 0]);
set(q(1),'pos',a2-[0 (down+.3) 0 0]);

set(q(3),'pos',a3-[0 (down-.1) 0 0]);
set(q(4),'pos',a5-[0 (down) 0 0]);

%eval(['print -depsc -f1 /home/shoko/C/','''IDL ps''','/heat/agu/hc_change_2005_agu'])
eval(['print -dpng -f2 /home/shoko/C/','''IDL ps''','/heat/oco/hc_change_2005_agu'])
