% makef7.m - matlab script to make figure 7 for globalhc paper
% figure 7 is the zonally integrated hov diagram.

load hovs
ii=find(abs(lat)<=66);

figure(2),clf
cx=[-2e16 2e16];ctrs=[-2e16:.5e16:2e16];
contourf(tgrid,lat(ii),hovhc(:,ii)'/1e16,ctrs/1e16),caxis(cx/1e16),
hold on,[c,h]=contour(tgrid,lat(ii),hovhc(:,ii)',[0 0],'k');set(h,'linewidth',2)

c=narrow_colorbar;set(gca,'tickdir','out')
set([gca;c],'fontsize',16);
ylabel('latitude'),xlabel('year')
orient tall
set(gca,'xticklabel',strvcat(num2str([1993:2:2003]')))
set(gca,'xtick',[1993.5:2:2003]');
poo=get(gca,'position');ax=axis;
ax=axis; dy=diff(ax(3:4));dx=diff(ax(1:2));h=dy*.015;
hold on,%pp1=plot(ax(1:2),[1 1]*(ax(3)+h),'k');
%pp2=plot(ax(1:2),[1 1]*(ax(4)-h),'k');
pp3=plot(ax(1:2),[1 1]*(ax(4)),'k');
a=axes('position',[poo(1) poo(2)-.01 poo(3) .01],'xtick',[],'ytick',[]);
axis([ax(1) ax(2) 0 1]);set(a,'box','on')

for i=1:(dx)
  patch(ceil(ax(1))+[0 1 1 0 0]+(i-1)*2,[0 0 1 1 0],'k');
end
a=axes('position',[poo(1) poo(2)+poo(4) poo(3) .01],'xtick',[],'ytick',[]);
axis([ax(1) ax(2) 0 1]);set(a,'box','on')
for i=1:(dx)
  patch(ceil(ax(1))+[0 1 1 0 0]+(i-1)*2,[0 0 1 1 0],'k');
end

% print plot
orient tall
%print -depsc2 -f2 /moala2/josh/Globalhc/paper/f7.eps
%print -djpeg90 -f2 /moala2/josh/Globalhc/paper/f7.jpg

