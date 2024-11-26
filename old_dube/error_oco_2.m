figure(1); clf;orient landscape; wysiwyg
heat_content_var2
good=find(tgrid_err >= 1955 & tgrid_err<=2006);

p=plot(tgrid_err(good),std_error(good),'*-k')
set(p,'linewidth',3)
ylabel('Global 0-750m Ocean Heat Content Anomaly [J]','fontsize',14);
title('95% Confidence Interval','fontsize',16);
xlabel('Time [years]','fontsize',12)
set(gca,'fontsize',12, 'tickdir','out')
axis(gca,[1954 2006 0 7e22])
hold on 
%eval(['print -dpng -f1 /home/shoko/C/','''IDL ps''','/heat/science/error_plot2'])
axes('position',[.5  .35 .35  .5])
set(gca,'fontsize',12, 'tickdir','out')
axis(gca,[1993 2006 0 1.5e22])
good=find(tgrid_err >= 1993 & tgrid_err<=2006);

p=plot(tgrid_err(good),std_error(good),'*-k')
axis(gca,[1993 2006 0 1.5e22])
set(p,'linewidth',3)

eval(['print -dpng -f1 /home/shoko/C/','''IDL ps''','/heat/oco/error_plot_oco2'])