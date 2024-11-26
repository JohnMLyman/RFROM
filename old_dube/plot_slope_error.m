function plot_slope_error(tgrid_err,error_map_t,error_rep_t,error_ave_t,...
	slope_map_t,slope_rep_t,slope_ave_t)



hold on

p1=plot(tgrid_err,slope_ave_t,'k')
e1=errorbar(tgrid_err,slope_ave_t,error_ave_t,'k');%set(e1,'linewidth',2)

p2=plot(tgrid_err,slope_map_t,'.-b')
e2=errorbar(tgrid_err,slope_map_t,error_map_t);%set(e2,'linewidth',2)

p3=plot(tgrid_err,slope_rep_t,'.-r')
e3=errorbar(tgrid_err,slope_rep_t,error_rep_t,'r');%set(e3,'linewidth',2)

%axis([1955 2010 0 1.5])
ylabel('slope [watts m^{-2}] ','fontsize',16);
set(p1,'linewidth',3)
set(gca,'tickdir','out')

xlabel('years','fontsize',16);

title('Slope of Linear Fit to Heat Content Anomaly','fontsize',12);
set(gca,'fontsize',11)

set(p2,'linewidth',3)
set(p1,'linewidth',3)
set(p3,'linewidth',3)

hold off


