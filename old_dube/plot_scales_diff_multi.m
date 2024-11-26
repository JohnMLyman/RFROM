

scales=[1:11];% in years

end_years=[2003 2002 2001 2000 1999 2004 2004 2004 2004 2004 2004 2005];
begin_years=  [1993 1993 1993 1993 1993 1994 1995 1996 1997 1998 1993 1993];


figure(2); clf; orient tall;wysiwyg
for i=1:length(end_years)

    begin_year=begin_years(i)
    end_year=end_years(i)




subplot(2,1,1)

mean_start=1967;
mean_end=2003;
 [mean_map,std_map,std_error_map,mean_rep,std_rep,std_error_rep]=...
     scale_type(begin_year,end_year,mean_start,mean_end,'diff',scales);




 
plot(scales,mean_map)
hold on
plot(scales,mean_rep,'r')
plot([0,max(scales)],[0,0],'k')



axis([0 12 -0.25 0.25])

%e1=errorbar(scales,mean_rep,std_rep,'.r');
%e2=errorbar(scales,mean_map,std_map,'.');
e4=errorbar(scales,mean_rep,std_error_rep,'-.r');
e5=errorbar(scales,mean_map,std_error_map,'-.');
ylabel('storage difference  (W m^{-2})');
xlabel('scale (years)');
title(['mean difference in OHCA storage: ',num2str(mean_start),' to ',num2str(mean_end),' sampling'],'fontsize',12)

if i ==11 
    plot(scales,mean_map)
    hold on
    plot(scales,mean_rep,'g')
    plot([0,max(scales)],[0,0],'g')
    e4=errorbar(scales,mean_rep,std_error_rep,'-.g');
    e5=errorbar(scales,mean_map,std_error_map,'-.g');
end

if i ==12
    plot(scales,mean_map,'.k')
    hold on
    plot(scales,mean_rep,'.k')
    plot([0,max(scales)],[0,0])
    e4=errorbar(scales,mean_rep,std_error_rep,'-.k');
    e5=errorbar(scales,mean_map,std_error_map,'-.k');
end


end
hold off



for i=1:length(end_years)
    
    begin_year=begin_years(i)
    end_year=end_years(i)
subplot(2,1,2)

mean_start=1955;
mean_end=1967;
 [mean_map,std_map,std_error_map,mean_rep,std_rep,std_error_rep]=...
     scale_type(begin_year,end_year,mean_start,mean_end,'diff',scales);





plot(scales,mean_map)
hold on
plot(scales,mean_rep,'r')
plot([0,max(scales)],[0,0],'k')
axis([0 12 -0.6 0.6])



%e1=errorbar(scales,mean_rep,std_rep,'.r');
%e2=errorbar(scales,mean_map,std_map,'.');
e4=errorbar(scales,mean_rep,std_error_rep,'.r');
e5=errorbar(scales,mean_map,std_error_map,'.');
ylabel('storage difference  (W m^{-2})');
xlabel('scale (years)');
title(['mean difference in OHCA storage: ',num2str(mean_start),' to ',num2str(mean_end),' sampling'],'fontsize',12)
if i ==11 
    plot(scales,mean_map)
    hold on
    plot(scales,mean_rep,'g')
    plot([0,max(scales)],[0,0],'g')
    e4=errorbar(scales,mean_rep,std_error_rep,'-.g');
    e5=errorbar(scales,mean_map,std_error_map,'-.g');
end

if i ==12
    plot(scales,mean_map,'.k')
    hold on
    plot(scales,mean_rep,'.k')
    plot([0,max(scales)],[0,0])
    e4=errorbar(scales,mean_rep,std_error_rep,'-.k');
    e5=errorbar(scales,mean_map,std_error_map,'-.k');
end

end
hold off

eval(['print -dpng -f2 /home/shoko2/wills/globalhc_dirs/Globalhc/figs/trend_paper/scale_plot_diff_test'])



