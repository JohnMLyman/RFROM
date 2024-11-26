
total_years=[1993,1994,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004];
close all
figure(1),clf
% hold on;

% slope of the linear trend added to the signal in cm/year
 slope_trend=(.24)
 
 % alpha_mean is the value of alpha that Willis 2004 used for global
 % estimates.
 
 alpha_mean=(1.5e8)/2.;
 alpha_mean=1;
 weight_josh=15.*(1.3e7)
slope_change_time=ones(length(total_years),1);
slope_input=slope_change_time;
for iplace=1:length(total_years)
  
iyear=total_years(iplace)    
 

load (['hcseries2_twin_',num2str(iyear)])


tgrid=tgrid(1:12)







% % % 

slope_diff=alpha_mean*(slope_trend*(tgrid-tgrid(1)-.5)-lt)
%p=plot(tgrid,alpha_mean*lt)



%p=plot(tgrid,slope_diff,'r')
%  p=plot(tgrid,df,'r');
 title(num2str(iyear));
%  p=plot(tgrid,tp,'b');2

slope_change_time(iplace)=slope_diff(12);
slope_input(iplace)=alpha_mean*slope_trend*(tgrid(12)-tgrid(1)-.5)

end
hold off
%plot(tgrid,slope_change_time)
figure
%plot(tgrid,weight_josh*slope_change_time./slope_input)

slope_error=weight_josh*slope_change_time./slope_input;
tgrid_slope_error=tgrid;

