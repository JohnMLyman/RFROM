





figure(1);wysiwyg

% top figure
font_s=7;
dlon=-27;
dlat=5;
subplot(3,1,3)

start_year=2004;
end_year=2009;
[corrhc_one_total,lon,lat,time_hc]=map_ones_var_mean_oco_white_paper_new(start_year,end_year);
min_val=0
max_val=1
del_val=.2 

ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
corrhc=[corrhc_one_total(jj,:);corrhc_one_total(ii,:)]./length(time_hc);
junk_map=colormap(jet(256));
junk_map=junk_map([256:-1:1],:);
colormap(junk_map)

pcolor(lon,lat,corrhc');
plot_coasts_black
caxis([min_val max_val])
shading flat

t1=text(60+dlon,50+dlat,['(c)',num2str(start_year),'-',num2str(end_year)],'fontsize',font_s,'fontweight','bold','FontName','Cronos-Pro');
axis([30 390 -90 90])
axis equal
axis([30 390 -90 90])
p1=gca;
set(gca,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90],'fontsize',font_s,'FontName','Cronos-Pro')
hold on
j1=axes('pos',[.355 .1 .325 .01]);
colormap(junk_map)

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:(max_val-min_val)/254:max_val]);

set(h,'edgecolor','none')
set(j1,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[],'XAxisLocation','bottom','FontName','Cronos-Pro','fontsize',7)
caxis([min_val max_val])
xlabel('mean area fraction','fontsize',7,'FontName','Cronos-Pro')
clear corrhc_one_total lon lat time_hc
% % % middle figure

subplot(3,1,2)
start_year=1967;
end_year=2003;
[corrhc_one_total,lon,lat,time_hc]=map_ones_var_mean_oco_white_paper(start_year,end_year);
min_val=0
max_val=1
del_val=.2 

ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
corrhc=[corrhc_one_total(jj,:);corrhc_one_total(ii,:)]./length(time_hc);
junk_map=colormap(jet(256));
junk_map=junk_map([256:-1:1],:);
colormap(junk_map)

pcolor(lon,lat,corrhc');
plot_coasts_black
caxis([min_val max_val])
shading flat

t1=text(60+dlon,50+dlat,['(b)',num2str(start_year),'-',num2str(end_year)],'fontsize',font_s,'fontweight','bold','FontName','Cronos-Pro');
axis([30 390 -90 90])
axis equal
axis([30 390 -90 90])
p2=gca;
set(gca,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90],'fontsize',font_s,'FontName','Cronos-Pro')

hold on

clear corrhc_one_total lon lat time_hc
% bottom figure
subplot(3,1,1)
start_year=1955;
end_year=1966;
[corrhc_one_total,lon,lat,time_hc]=map_ones_var_mean_oco_white_paper(start_year,end_year);
min_val=0
max_val=1
del_val=.2 

ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
corrhc=[corrhc_one_total(jj,:);corrhc_one_total(ii,:)]./length(time_hc);
junk_map=colormap(jet(256));
junk_map=junk_map([256:-1:1],:);
colormap(junk_map)

pcolor(lon,lat,corrhc');
plot_coasts_black
caxis([min_val max_val])
shading flat

t1=text(60+dlon,50+dlat,['(a)',num2str(start_year),'-',num2str(end_year)],'fontsize',font_s,'fontweight','bold','FontName','Cronos-Pro');
axis([30 390 -90 90])
axis equal
axis([30 390 -90 90])
p3=gca;
set(gca,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90],'fontsize',font_s,'FontName','Cronos-Pro')
hold on



%Plot the map of the standard devation of the ratio of varibilty in the map
 pos1=get(p3,'pos')
 pos2=get(p2,'pos')
 pos3=get(p1,'pos')
% % 
% % bpos=get(b,'pos')
%%
set(p3,'xticklabel',[])
set(p2,'xticklabel',[],'pos',pos2+[0 .05 0 0])
set(p1,'pos',pos3+[0 .1 0 0])
%% 

eval(['print -dtiff -r600 -f1 /Users/johnlyman/figs/oco/white/mean_one2'])
eval(['print -dpng -f1 /Users/johnlyman/figs/oco/white/mean_one'])
eval(['print -depsc -f1 /Users/johnlyman/figs/oco/white/mean_one'])