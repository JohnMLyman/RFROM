% makehovs.m - matlab script to make hov-diagrams of lat vs. time
% for several relavent quantities.

d=sdir('hc*.mat');
d=d(10:end-1);

load(d(1).name,'corrhc','lon','lat')
corrhc1=corrhc;

load gridinfo tgrid

% calculate weights for oceans

[gy,gx]=meshgrid(lat,lon); [tmp,fx]=gradient(gx); [fy,tmp]=gradient(gy);
dx=111e3*fx.*cos(pi/180*gy);
dy=111e3*fy;corrhc1(:,abs(lat)>66)=NaN;
arw=dx.*dy;
clear gy gx fy fx tmp
% % bah=nans(size(corrhc1));bah(indind)=1;bah(atlind)=1;bah(pacind)=1;
% % poo=nans(size(corrhc1));poo(atlind)=1;atlwt=poo.*dx;
% % poo=nans(size(corrhc1));poo(pacind)=1;pacwt=poo.*dx;
% % poo=nans(size(corrhc1));poo(indind)=1;indwt=poo.*dx;
clear poo bah

% make hov diagrams
hovhc=zeros(length(tgrid),length(lat));
hovhc2=zeros(length(tgrid),length(lat));
% hovpachc=hovhc;hovindhc=hovhc;hovatlhc=hovhc;
warning off
% while we're at it, do the slopes too
ahc=zeros(size(arw));bhc=ahc;amap=ahc;bmap=ahc;n=length(tgrid);
tic,for i=1:length(d)
  load(d(i).name,'corrhc','hmap2')  
  ahc=ahc+corrhc*tgrid(i)*n;bhc=bhc+corrhc*sum(tgrid);
  amap=amap+hmap2*tgrid(i)*n;bmap=bmap+hmap2*sum(tgrid);
  corrhc(:,lat>66)=NaN;

  % heat content
  poo=corrhc;
  hovhc(i,:)=nansum(poo.*dx);
  hovhc2(i,:)=nansum(hmap2.*dx);
% %   poo=corrhc;poo(indind)=NaN;poo(pacind)=NaN;
% %   hovatlhc(i,:)=nansum(poo.*atlwt);
% %   poo=corrhc;poo(indind)=NaN;poo(atlind)=NaN;
% %   hovpachc(i,:)=nansum(poo.*pacwt);
% %   poo=corrhc;poo(atlind)=NaN;poo(pacind)=NaN;
% %   hovindhc(i,:)=nansum(poo.*indwt);

  disp([d(i).name,'  ',num2str(toc)])
end
warning on

hcslope=(ahc-bhc)/(sum(tgrid.^2)*n-sum(tgrid).^2);
hcslope2=(amap-bmap)/(sum(tgrid.^2)*n-sum(tgrid).^2);
save slopehc hcslope2 hcslope lat lon
clear hcslope mapslope ahc bhc amap bmap

hovindhc(:,lat>30)=NaN;

clear i ans hcint tm yr dt hfluxanom elon elat hs hf1 eln corrhc hc corrhc1

save hovs

% % % figure(1)
% % % cx=[-2e16 2e16];ctrs=[-2e16:.5e16:2e16];
% % % ii=find(abs(lat)<66);
% % % subplot(1,3,1),contourf(tgrid,lat(ii),hovpachc(:,ii)'/1e16,ctrs/1e16)
% % % caxis(cx/1e16),colorbar,ylabel('latitude'),title('Pacific')
% % % subplot(1,3,2),contourf(tgrid,lat(ii),hovatlhc(:,ii)'/1e16,ctrs/1e16)
% % % caxis(cx/1e16),colorbar,title('Atlantic')
% % % subplot(1,3,3),contourf(tgrid,lat(ii),hovindhc(:,ii)'/1e16,ctrs/1e16)
% % % caxis(cx/1e16),colorbar,title('Indian')
% % % suptitle('zonally integrated heat content ( x 10^{16} J/meter)')
% % % 
% % % figure(2),clf
% % % cx=[-2e16 2e16];ctrs=[-2e16:.5e16:2e16];
% % % contourf(tgrid,lat(ii),hovhc(:,ii)'/1e16,ctrs/1e16),caxis(cx/1e16),
% % % c=narrow_colorbar;set(gca,'tickdir','out')
% % % set([gca;c],'fontsize',16);
% % % ylabel('latitude'),xlabel('year')
% % % orient tall
% % % set(gca,'xticklabel',strvcat(num2str([1993:2:2002]')))
% % % set(gca,'xtick',[1993.5:2:2002]');
% % % poo=get(gca,'position');ax=axis;
% % % a=axes('position',[poo(1) poo(2)-.01 poo(3) .01],'xtick',[],'ytick',[]);
% % % axis([ax(1) ax(2) 0 1]);set(a,'box','on')
% % % for i=1:(dx)
% % %   patch(ceil(ax(1))+[0 1 1 0 0]+(i-1)*2,[0 0 1 1 0],'k');
% % % end
% % % a=axes('position',[poo(1) poo(2)+poo(4) poo(3) .01],'xtick',[],'ytick',[]);
% % % axis([ax(1) ax(2) 0 1]);set(a,'box','on')
% % % for i=1:(dx)
% % %   patch(ceil(ax(1))+[0 1 1 0 0]+(i-1)*2,[0 0 1 1 0],'k');
% % % end

% print plot
%print -depsc2 -f2 /moala2/josh/Globalhc/paper/f7.eps
%print -djpeg90 -f2 /moala2/josh/Globalhc/paper/f7.jpg



