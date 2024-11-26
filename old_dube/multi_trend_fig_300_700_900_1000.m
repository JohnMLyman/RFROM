%BEFORE YOU RUN THIS MAKE SURE THAT SE AND HC HAVE THE SAME TIMES!!!  
% Run makef3f5_1800_900_700_300 to compute heat content and 

%makef3f5_1800_900_700_300

load hc_300_700_900_1800 hc_one_1800 hc_1800 time_1800 hc_one_900 hc_900 time_900 hc_one_700 hc_700 time_700 hc_one_300 hc_300 time_300 ...
    hc_one hc time

time_oco=time;
hc_oco=hc;
hc_one_oco=hc_one;


load error_300_700_900_1800 se_1800 se_900 se_700 se_300 time





 for idepth=[300,700,900,1800]
     
     if idepth==300; depth_range_str='0-300';end
     if idepth==700; depth_range_str='0-700';end
     if idepth==900; depth_range_str='700-900';end
     if idepth==1800; depth_range_str='900-1800';end
     
     eval(['hc=hc_',num2str(idepth),'./10;'])
     eval(['se_hc=se_',num2str(idepth),'./10;'])
     eval(['time_hc=time_',num2str(idepth),';'])
     first=1;
    last=0;
idepth
     
    for iscale=[4,5,6,7]
        icolor=iscale;
        if iscale==10
            last=1;
            icolor=3;
        end


        [time_slope,slope,se_slope]=plot_interannual_trends_300_700_900_1800(hc,se_hc,time_hc',iscale,first,last,icolor,depth_range_str,1,2,idepth);

        first=0;
        

    end


    eval(['print -dpng  -f1 /Users/johnlyman/figs/oco/Oceans/fig2_noone_',depth_range_str])
    eval(['print -dpng  -f2 /Users/johnlyman/figs/oco/Oceans/fig3_noone_',depth_range_str])
close all
end