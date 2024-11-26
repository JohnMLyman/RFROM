% make figure 6 it maps the heat content



for start_year=1993:2:2001
clf
end_year=start_year+1
for iyear=start_year:end_year
    
load (['hc',num2str(iyear),'c.mat']) 
%figure  
%subplot(2,1,1)
%p=plot(ll(:,2),ll(:,1),'k');set(p,'linewidth',1);hold on
subplot(2,1,iyear-start_year+1)
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
 
m_contour(lon_new,lat,hc'/86400/365.25,[-80:10:80])
title([num2str(iyear),' heat content'])

hold off
end
colorbar_thin


%%orient tall

%%% print plot

eval(['print -dpng -f1 heat',num2str(start_year)])
%%%print -djpeg90 -f1 /moala2/josh/Globalhc/paper/f1.jpg
end
