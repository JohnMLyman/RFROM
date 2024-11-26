% color bar bottom this code makes a thin color bar at the bottom

delta=10
cmin=-80
cmax=80

j=axes;
[cs,h]=contourf([0 1],[cmin:delta:cmax],[[1 1]'*[cmin:delta:cmax]]',[cmin:delta:cmax]);
set(h,'edgecolor','none');
hold on

set(j,'pos',[0.1 0.05 0.02 0.9],'tickdir','out','xtick',[],'ytick',[cmin:delta:cmax],'ticklen',[0 0])
ylabel('W/m^2')
[cs1,h1]=contour([0 1],[cmin:delta:cmax],[[1 1]'*[cmin:delta:cmax]]',[delta:delta:cmax],'k-');
[cs2,h2]=contour([0 1],[cmin:delta:cmax],[[1 1]'*[cmin:delta:cmax]]',[cmin:delta:0],'k-');
set(h1,'linew',1)
set(h2,'linew',0.5)
caxis([cmin cmax])