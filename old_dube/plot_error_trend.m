



figure(3); clf; orient tall;wysiwyg


subplot(2,1,1)



[std_error,std_error_one,time]=twin_error_trend;

hold on 
p_map=plot(time,std_error./1e21,'--*k')
p_rep=plot(time,std_error_one./1e21,'--*k')


ylabel('95% Confidence Interval  [zeta joules]','fontsize',16);
xlabel('Time [years]','fontsize',16);
%title(['Estimate of the OHCA sampling error '],'fontsize',16)

set(p_map,'linewidth',2);set(p_rep,'linewidth',4);
axis([1955 2007 0 70])
set(gca,'fontsize',11,'tickdir','out','box','on')










hold off
eval(['print -dtiff -f3 /home/shoko2/wills/globalhc_dirs/Globalhc/figs/trend_paper/sampling_error_trend'])

