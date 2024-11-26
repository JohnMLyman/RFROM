

function [syear]=sal_map_oco_2012_2013_6deg_2_pannel_multi_label_WOD09_m_map_pos(fyear)

syear=fyear-1;
cd '/Volumes/Data/Globalhc/SAL/Floats/'



file_path='/Volumes/Data/Globalhc/SAL/Floats/argo/'
file_name='surface_sal_jan_2014'
syear=fyear-1;

eval(['load ',file_path,file_name,'.mat surface_sal_surface dt_surface coords_surface '])
good_2013=find(dt_surface(:,1)==fyear);
good_2012=find(dt_surface(:,1)==syear);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the heat content for 2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1);wysiwyg;orient tall
set(gcf,'color','white');

subplot(2,1,1)
m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);

hold on

m_grid('tickdir','out','xtick',[30:30:390],'ytick',[-90:30:90],'linestyle','none');

wysiwyg;orient tall
m_plot(coords_surface(good_2013,1),coords_surface(good_2013,2),'.','MarkerSize',.5)
m_plot(coords_surface(good_2013,1)+360,coords_surface(good_2013,2),'.','MarkerSize',.5)
hold on
m_coast('patch',[0 0 0]);
t1=m_text(60,54,['a) ',num2str(fyear)],'fontsize',11,'fontweight','bold');


hold off


a=gca;


hold on

subplot(2,1,2)


hold on
m_grid('tickdir','out','xtick',[30:30:390],'xticklabel',[],'ytick',[-90:30:90],'linestyle','none');
m_plot(coords_surface(good_2012,1),coords_surface(good_2012,2),'.','MarkerSize',.5)
m_plot(coords_surface(good_2012,1)+360,coords_surface(good_2012,2),'.','MarkerSize',.5)


hold on
m_coast('patch',[0 0 0]);
t1=m_text(55,54,['b) ',num2str(syear)],'fontsize',11,'fontweight','bold');

b=gca;
apos=get(a,'pos')

bpos=get(b,'pos')
set(b,'pos',bpos+[0 .03+.035 0 0],'xticklabel',[])
set(a,'pos',apos+[0 -.05-.03 0 0])



hold on


set(b,'xticklabel',[])


%%%%%%%%%%%%%%%%%%
%%% print plots  %
%%%%%%%%%%%%%%%%%%
wysiwyg;orient tall

 eval(['print -dpng -f1 /Users/johnlyman/figs/oco/Sal/oco_',num2str(fyear),'_jan_2014_pos'])
% eval(['print -depsc2 -r300 -f1 /Users/johnlyman/figs/oco/Sal/oco_',num2str(fyear),'_jan_2014_pos'])


