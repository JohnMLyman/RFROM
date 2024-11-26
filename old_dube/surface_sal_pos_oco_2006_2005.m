%plot the oco surface salinity pos for 2005 and 2006


ncload('surface_sal_jan_2007.nc')

cds=coords;
clear coords surface_sal time

ii=find(cds(:,1)<30);


cds(ii,1)=cds(ii,1)+360;

figure(1);wysiwyg



pos_2005=find(dt(:,1) == 2005);
pos_2006=find(dt(:,1) == 2006);


plot(cds(pos_2005,1),cds(pos_2005,2),'.','MarkerSize',4)
hold on 

plot(cds(pos_2006,1),cds(pos_2006,2),'.r','MarkerSize',4)
plot_coasts_black
axis([30 390 -90 90])
axis equal
axis([30 390 -90 90])
set(gca,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90]);
title('Argo float positions during 2006 (red) plotted over 2005 (blue)')


hold off




eval(['print -dpng -f1 /home/shoko/C/','''IDL ps''','/heat/oco/2006/oco_sal_pso_2005_2006'])

eval(['print -dtiff -f1 /home/shoko/C/','''IDL ps''','/heat/oco/2006/oco_sal_pos_2005_2006'])

