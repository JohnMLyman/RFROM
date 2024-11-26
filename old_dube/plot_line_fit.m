function plot_line_fit(tgrid,tsub_1955_map,tsub_1955_one,tpave,scale,junk_year)





min_year=min(tgrid);
max_year=max(tgrid);

hold on
p=plot(tgrid,tpave*scale./1e21,'k-*');
ylabel('0-750m Heat Content Anomaly [zeta-joules] ','fontsize',10 );
set(p,'linewidth',3)
set(gca,'XTick',[min_year:1:max_year],'tickdir','out')

xlabel('years','fontsize',16);

title(['0-750m Heat Content Anomaly estimated from SSH ',num2str(junk_year)],'fontsize',10);
%axis([min_year max_year -50 50])
set(gca,'fontsize',11)


p2=plot(tgrid,tsub_1955_one*scale./1e21,'r-*')
set(p2,'linewidth',3)

p3=plot(tgrid,tsub_1955_map*scale./1e21,'b-*')
set(p3,'linewidth',3)






hold off

