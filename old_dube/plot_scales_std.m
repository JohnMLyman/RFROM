

scales=[1:11];% in years


figure(4); clf; orient tall;wysiwyg


subplot(2,1,1)

mean_start=1967;
mean_end=2003;
 [mean_map,std_map,std_error_map,mean_rep,std_rep,std_error_rep]=...
     scale_type(1993,2004,mean_start,mean_end,'std',scales);




hold on 
plot(scales,mean_map)
plot(scales,mean_rep,'r')
plot([0,max(scales)],[0,0],'k')


%e1=errorbar(scales,mean_rep,std_rep,'.r');
%e2=errorbar(scales,mean_map,std_map,'.');
e4=errorbar(scales,mean_rep,std_error_rep,'.r');
e5=errorbar(scales,mean_map,std_error_map,'.');
ylabel('mean STD (zeta joules)');
xlabel('scale (years)');
title(['mean STD of OHCA: ',num2str(mean_start),' to ',num2str(mean_end),' sampling'],'fontsize',12)

hold off


subplot(2,1,2)

mean_start=1955;
mean_end=1967;
 [mean_map,std_map,std_error_map,mean_rep,std_rep,std_error_rep]=...
     scale_type(1993,2004,mean_start,mean_end,'std',scales);




hold on 
plot(scales,mean_map)
plot(scales,mean_rep,'r')
plot([0,max(scales)],[0,0],'k')


%e1=errorbar(scales,mean_rep,std_rep,'.r');
%e2=errorbar(scales,mean_map,std_map,'.');
e4=errorbar(scales,mean_rep,std_error_rep,'.r');
e5=errorbar(scales,mean_map,std_error_map,'.');
ylabel('mean STD  (zeta joules)');
xlabel('scale (years)');
title(['mean STD of OHCA: ',num2str(mean_start),' to ',num2str(mean_end),' sampling'],'fontsize',12)

hold off
eval(['print -dpng -f3 /home/shoko2/wills/globalhc_dirs/Globalhc/figs/trend_paper/scale_plot_std'])
