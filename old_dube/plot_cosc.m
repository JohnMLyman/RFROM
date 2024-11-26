





figure(1);wysiwyg

% top figure




start_year=2008;
[corrhc_one_total,lon,lat]=map_ones_cosc(start_year);
min_val=0
max_val=1
del_val=.2 

ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
corrhc=[corrhc_one_total(jj,:);corrhc_one_total(ii,:)];
junk_map=colormap(jet(256));
junk_map=junk_map([256:-1:1],:);
colormap(junk_map)

pcolor(lon,lat,corrhc');
plot_coasts_black
caxis([min_val max_val])
shading flat

t1=text(60,50,[num2str(start_year)],'fontsize',16,'fontweight','bold');
axis([30 390 -90 90])
axis equal
axis([30 390 -90 90])
p1=gca;
set(gca,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90],'fontsize',16)
hold on
j=axes('pos',[.13 .85 .775 .02]);
colormap(junk_map)

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:(max_val-min_val)/254:max_val]);

set(h,'edgecolor','none')
set(j,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val])
xlabel('area fraction')

clear corrhc_one_total lon lat time_hc

% % 
eval(['print -dpng -f1 /Users/johnlyman/figs/oco/white/one_cosc'])
