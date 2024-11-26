% makef2.m - matlab script to make 'figure 2' in the global heat content
% paper:  regression coefficient of heat content onto altimetric height

% load regression coeff. data
load hregress2
crl=c;alon=alon(2:end-2);alat=alat(2:end-2);alpha=alpha(2:end-2,2:end-2);
crl=crl(2:end-2,2:end-2);
alon=[alon(end/2+1:end),alon(1:end/2)+360];
alpha=[alpha(end/2+1:end,:);alpha(1:end/2,:)];
crl=[crl(end/2+1:end,:);crl(1:end/2,:)];

% subsample these so they're not so huge
%ii=1:2:length(alon);jj=1:2:length(alat);
%alon=alon(ii);alat=alat(jj);alpha=alpha(ii,jj);crl=crl(ii,jj);

% get land values
load hc2002a corrhc lat lon
lon=[lon(end/2+1:end);lon(1:end/2)+360];
corrhc=corrhc*0+1;corrhc=[corrhc(end/2+1:end,:);corrhc(1:end/2,:)];
msk=interp2(lat,lon,corrhc,alat,alon','nearest');
clear lat lon corrhc ii jj

f=figure(1);clf;
subplot(2,1,1),ctrs=[0:.25e8:2.5e8];alpha=alpha.*msk;
[c,h]=contourf(alon,alat,alpha'/1e8,ctrs/1e8);
clabel(c,h,'manual');
caxis(mm(ctrs)/1e8),colormap gray
axis([0 360 -80 80]),hold on,set(gca,'fontsize',16)
set(gca,'xaxislocation','top'),set(gca,'tickdir','out')
%c=narrow_colorbar('horiz');set([c],'fontsize',16)
%set(c,'xtick',ctrs(1:2:end)'/1e8);
t2=text(-30,100,'a).');set(t2,'fontsize',16,'fontweight','bold')

subplot(2,1,2),ctrs=[0:.1:1];crl=crl.*msk;
[c,h]=contourf(alon,alat,crl',ctrs);caxis(mm(ctrs)),colormap gray
clabel(c,h,'manual');
axis([0 360 -80 80]),hold on,set(gca,'fontsize',16)
set(gca,'xaxislocation','top'),set(gca,'tickdir','out')
c=narrow_colorbar('horiz');set([c],'fontsize',16)
set(c,'xtick',ctrs');
t2=text(-30,100,'b).');set(t2,'fontsize',16,'fontweight','bold')


orient tall

%print -deps2 -f1 -painters /moala2/josh/Globalhc/paper/f2.eps
%print -djpeg90 -f1 -zbuffer -r0 /moala2/josh/Globalhc/paper/f2.jpg


