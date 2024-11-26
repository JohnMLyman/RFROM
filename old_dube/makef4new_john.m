% make figure 4 it maps the heat content



clf

load slope_heat2
slope=slope/86400/365.25;
nan_pos=find(isnan(slope)==1);
error(nan_pos)=nan;
error=error/86400/365.25;
%figure  
%subplot(2,1,1)
%p=plot(ll(:,2),ll(:,1),'k');set(p,'linewidth',1);hold on
% % subplot(2,1,1)
% % m_ungrid m_proj;
% % m_proj('Equidistant Cylindrical','long',[30 390],'lat',[-90 90]);
% %  m_coast;
% %  m_grid;
% %  hold on
% %  bad=find(lon < 30);
% %  good=find(lon > 30);
% %  lon1=lon(good);
% %  lon2=lon(bad)+360;
% %  
% %  lon_new=[lon1',lon2']';
% %  corrhc=slope;
% %  hc1=corrhc(good,:);
% %  hc2=corrhc(bad,:);
% %  
% % hc=[hc1',hc2']';
% %  
 cmin=0
 cmax=10
delta=2.5
% % m_contour(lon_new,lat,hc',[cmin:delta:cmax])
% % title([' estimate of change in heat content'])
% % 
% % hold off
subplot(2,1,1)
corrhc=abs(error./slope);
m_ungrid m_proj;
m_proj('Equidistant Cylindrical','long',[30 390],'lat',[-90 90]);
 m_coast;
 m_grid;
 hold on
 bad=find(lon < 30);
 good=find(lon > 30);
 lon1=lon(good);
 lon2=lon(bad)+360;
 
 lon_new=[lon1',lon2']';
 
 hc1=corrhc(good,:);
 hc2=corrhc(bad,:);
 
hc=[hc1',hc2']';
 

[cs,h]=m_contour(lon_new,lat,hc',[cmin:delta:cmax])
%set(h,'edgecolor','none')
title([' error 95%/slope'])

hold off


colorbar_thin_slope


%%orient tall

%%% print plot

print -dpng -f1 ratio_slope_error.png
%print -dpng -f1 ratio_slope_error.png
%%%print -djpeg90 -f1 /moala2/josh/Globalhc/paper/f1.jpg

