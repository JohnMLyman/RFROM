

scales=[1:11];% in years

gray=[.7 .7 .7];

figure(3); clf; orient tall;wysiwyg


subplot(2,1,1)

mean_start=1967;
mean_end=2003;

mean_start=1955;
mean_end=1967;

 [mean_map,std_map,std_error_map,mean_rep,std_rep,std_error_rep,... 
	mean_slope_error_map,mean_slope_error_rep,mean_slope_error_ave,...
    	stde_slope_error_map,stde_slope_error_rep]=...
        scale_type(1993,2004,mean_start,mean_end,'slope',scales);




hold on 
p_map=plot(scales,mean_map,'--*k')
p_rep=plot(scales,mean_rep,'--*k')
p_aviso=plot([0,max(scales)],[0,0])


%e1=errorbar(scales,mean_rep,std_rep,'.r');
%e2=errorbar(scales,mean_map,std_map,'.');
e_rep=errorbar(scales,mean_rep,std_error_rep,'--k');
e_map=errorbar(scales,mean_map,std_error_map,'--k');
ylabel('slope difference  (W m^{-2})','fontsize',16);
xlabel('scale (years)','fontsize',16);
title(['mean difference in OHCA slope: ',num2str(mean_start),' to ',num2str(mean_end),' sampling'],'fontsize',16)

hold off
set(p_map,'linewidth',2);set(p_rep,'linewidth',4);set(p_aviso,'linewidth',4,'color',gray);
set(e_map,'linewidth',2);set(e_rep,'linewidth',4);
set(gca,'fontsize',11)
subplot(2,1,2)




hold on 

p_map=plot(scales,mean_slope_error_map,'--*k')
p_rep=plot(scales,mean_slope_error_rep,'--*k')
p_aviso=plot([0,max(scales)],[0,0])


%e1=errorbar(scales,mean_rep,std_rep,'.r');
%e2=errorbar(scales,mean_map,std_map,'.');
e_rep=errorbar(scales,mean_slope_error_rep,stde_slope_error_rep,'--k');
e_map=errorbar(scales,mean_slope_error_map,stde_slope_error_map,'--k');


ylabel('slope difference  (W m^{-2})','fontsize',16);
xlabel('scale (years)','fontsize',16);
title(['95% confidence interval in OHCA slope: ',num2str(mean_start),' to ',num2str(mean_end),' sampling'],'fontsize',16)
set(p_map,'linewidth',2);set(p_rep,'linewidth',4);set(p_aviso,'linewidth',4,'color',gray);
set(e_map,'linewidth',2);set(e_rep,'linewidth',4);

set(gca,'fontsize',11)

hold off
eval(['print -dpng -f3 /home/shoko2/wills/globalhc_dirs/Globalhc/figs/trend_paper/scale_plot_slope22_',num2str(mean_start),'_',num2str(mean_end)])

