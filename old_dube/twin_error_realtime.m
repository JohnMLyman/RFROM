function [std_error,time,f2]=twin_error_realtime(depth)

% this code compute an error which is one standard error on the mean.


%file_name='hdata_twin_correction_nofsi';
% this code computes and plots the ten year trend in heat content.

% tsub in the maped topex var
% tpave is the unmaped variabilty 

cd /Volumes/Data/Globalhc/HC/
%alpha is in J/m^2 /(cm)
alpha=(.6e7)/(.04);

% year over wich the proxy is computed
min_year=1993;
max_year=2009;

tgrid=[min_year:max_year]+.5;
% 'compute the real heat curve'

if depth~= 1800; depth_maps=300; else depth_maps=1800; end
 [hctpx,tpave]=heat_curv_gen_twin_real_realtime(tgrid,depth);
% eval(['save junk_tpave_',num2str(depth),' hctpx tpave'])
%eval(['load junk_tpave_',num2str(depth)])


% time is the number of years of Argo data
time=[2004.5:1:2010.5];
for i=1:length(time)
   
    iyear=time(i);    
    ['allheat_twin_',num2str(depth_maps),'_',num2str(iyear),'.mat_tpx_map.mat']
   [tsub,hc2,time_twin]=heat_curv_gen_twin_realtime( ['allheat_twin_',num2str(depth_maps),'_',num2str(iyear),'.mat_tpx_map.mat'],depth);
    
   
   
   
   %tsub=tsub-mean(tsub); 
   %tpave=tpave-mean(tpave);
   %std_map=sqrt(sum(alpha.*alpha.*(tsub-tpave).^2)./Nl);
   good=find(time_twin<= max_year+.5& time_twin >= min_year+.5);
   Nl=length(tsub(good));
   
   hc2=hc2(good)-mean(hc2(good)); 
   hctpx=hctpx-mean(hctpx);
   std_map=sqrt(sum((hc2-hctpx).^2)./Nl);
   
   f1=std_map;
% f2 is the standard error due to topex
   f2=(.6e7)*3.4e14;
   f2=0;
    std_error(i)=sqrt(f2.^2+f1.^2);
end    

