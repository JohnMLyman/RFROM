function [std_error,time,f2]=twin_error_realtime_2012_end_2016(jdepth)

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
max_year=2010;

tgrid=[min_year:max_year]+.5;
% 'compute the real heat curve'
depth_name=cell(1,4);
depth_name{5}='1800';
depth_name{4}='900';
depth_name{2}='100_300';
depth_name{3}='300_700';
depth_name{1}='100';

    depth=depth_name{jdepth};

 [hctpx,tpave]=heat_curv_gen_twin_real_realtime_2012_2016(tgrid,depth);
% eval(['save junk_tpave_',num2str(depth),' hctpx tpave'])
%eval(['load junk_tpave_',num2str(depth)])



% time is the number of years of Argo data
%time=[1950.5:1:2011.5];
time=[1992.5:1:2015.5];
for i=1:length(time)
   
    iyear=time(i);  
    path_twin='/Users/lyman/data/Globalhc/HC/twin/EN3'
    
    if iyear >=2010 
        switch jdepth
       
           case 1
               path_twin='/Users/lyman/data/Globalhc/HC/twin/EN3_2014';
           case 2
               path_twin='/Users/lyman/data/Globalhc/HC/twin/EN3_2014';
           case 3
               path_twin='/Users/lyman/data/Globalhc/HC/twin/EN3_2014';

           case 4
               iyear=2010.5;
           case 5
               iyear=2010.5;
     
        end
    end
    
   
   [tsub,hc2,time_twin]=heat_curv_gen_twin_realtime_2012_2016( ['allheat_twin_',depth,'_',num2str(iyear),'.mat_tpx_map.mat'],depth,path_twin);
    
   
   
   
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
end

