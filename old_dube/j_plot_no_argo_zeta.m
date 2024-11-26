function []=j_plot_no_argo_zeta(tgrid_err_no_argo,std_error_no_argo,hc_all,tgrid_all,error_all)
% e1=errorbar(tgrid,hc2,error_insitu,'k--');set(e1,'linewidth',1)


%plot year is the year that you plot from

plot_year=2002;

offset=hc_all(find(tgrid_all == plot_year+.5))

load /home/shoko2/wills/globalhc_dirs/Globalhc/HC/no_season/hcseries_no_argo.mat
load /home/shoko2/wills/globalhc_dirs/Globalhc/HC/hcseries_no_argo2.mat



good=find(tgrid >= 1993);

tgrid=tgrid(good);
hc2=hc2(good);

mean_hc2=mean(hc2);

hc2=hc2-mean_hc2;
'mean no argo'
mean_hc2

hc2=hc2*3.4e14;

hc2=hc2-hc2(find(tgrid == plot_year+.5))+offset

plot_ind=find(tgrid >=plot_year);


hc_new=[hc_all(find(tgrid_all == tgrid(1)):find(tgrid_all == plot_year-.5)),hc2(plot_ind)]';
tgrid_new=[tgrid_all(find(tgrid_all == tgrid(1)):find(tgrid_all == plot_year-.5)),tgrid(plot_ind)]';

hc2=hc2(plot_ind);
tgrid=tgrid(plot_ind);

 p=plot(tgrid,hc2.*1e-21,'k-*')
  set(p,'linewidth',2)
 
 
 
% txt={['                All']; ...
%      ['       No Argo'];...
%      ['No seasonal']};
% 
% space=.9e22;
% off_set=.6e22;
% 
% year_set=1994;
% j_set=4e22;
% 
error_insitu=interp1(tgrid_err_no_argo,std_error_no_argo,tgrid);

error_new=[error_all(1:find(tgrid_all == plot_year-.5)),error_insitu]';

% 
% 
% 
%  txth=text(year_set+.15,j_set,txt,'fontsize',16);

hc_22=hc_new.*1e-21;error_22=error_new.*1e-21;
e1=errorbar(tgrid_new,hc_22,error_22,'k');set(e1,'linewidth',2)
  set(e1,'color',.5*[1 1 1])
  
  save junk_zeta tgrid_new hc_22 error_22
