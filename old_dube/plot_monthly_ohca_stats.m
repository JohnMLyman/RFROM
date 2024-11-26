
path='/Volumes/Data/Globalhc/HC/';
close all
old_path=cd(path);
%for idepth=[300,700,900,1800];
for idepth=[300,700,900,1800];
    
    file_name=['monthly_sats_',num2str(idepth),'_']
    % load data and compute the combined estimate
    
    [lon,lat,lon_tpx,lat_tpx,time,ht,ht_com,ht_prox,one]=load_mon_ht_take2(idepth);
    s=size(one);

% maps of the slope
'make slopes'
%     
%     if idepth == 300
%         [slope_ht,time_ht,error_ht,lat_ht,lon_ht]=load_heat_slope_300_700_900_1800([file_name,'slope_ht']);
%         [slope_ht_com,time_ht_com,error_ht_com,lat_ht_com,lon_ht_com]=load_heat_slope_300_700_900_1800([file_name,'slope_com']);
%         [slope_ht_tpx,time_ht_tpx,error_ht_tpx,lat_ht_tpx,lon_ht_tpx]=load_heat_slope_300_700_900_1800([file_name,'slope_tpx']);
%     else
        [slope_ht,time_ht,error_ht,lat_ht,lon_ht]=heat_slope_300_700_900_1800(lat,lon,time',ht,[file_name,'slope_ht']);
        [slope_ht_com,time_ht_com,error_ht_com,lat_ht_com,lon_ht_com]=heat_slope_300_700_900_1800(lat_tpx,lon_tpx,time',ht_com,[file_name,'slope_com']);
         [slope_ht_tpx,time_ht_tpx,error_ht_tpx,lat_ht_tpx,lon_ht_tpx]=heat_slope_300_700_900_1800(lat_tpx,lon_tpx,time',ht_prox,[file_name,'slope_tpx']);
%     end
% area covered
    mean_one=nanmean(one,3);
    var_one=nanmean((one-repmat(mean_one,[1,1,s(3)]).^2),3);

% global integral of ohca
'make curves'
    [hc_ht,time_hc_ht,hc_one_ht]=heat_curv_gen_input(lat,lon,time,ht,one);
    eval(['save ',file_name,'_ht_curve hc_ht time_hc_ht hc_one_ht'])
    [hc_com,time_com]=heat_curv_gen_input_tpx(lat_tpx,lon_tpx,time,ht_com);
     eval(['save ',file_name,'_ht_com_curve hc_com time_com'])
     [hc_tpx,time_tpx]=heat_curv_gen_input_tpx(lat_tpx,lon_tpx,time,ht_prox);
     eval(['save ',file_name,'_ht_tpx_curve hc_tpx time_tpx'])
% mean map for 2009

    pos_2009=find(floor(time) == 2009);
    
    mean_ht=nanmean(ht(:,:,pos_2009),3);
    mean_com=nanmean(ht_com(:,:,pos_2009),3);
    mean_tpx=nanmean(ht_prox(:,:,pos_2009),3);
     
    %% plot figures
    figure(1)

    pcolor(lon,lat,mean_one')
    shading flat
    plot_coasts_black
    colorbar
    caxis([0 1])
    title([file_name,' mean_one'])
    
    
    figure(2)
    pcolor(lon,lat,var_one')
    shading flat
    plot_coasts_black
    colorbar
    title([file_name,' var_one'])
    
    
    [~]=plot_slope_map(lat,lon,slope_ht,error_ht,3,[file_name,' insitu 2004-2010']) ; 
    [~]=plot_slope_map(lat_tpx,lon_tpx,slope_ht_com,error_ht_com,4,[file_name,' combined 2004-2010'])  ;
    [~]=plot_slope_map(lat_tpx,lon_tpx,slope_ht_tpx,error_ht_tpx,5,[file_name,' proxy 2004-2010'])  ;
    
    figure(6)
    
    plot(time_hc_ht,hc_ht)
    hold on 
    plot(time_com,hc_com,'r')
    plot(time_tpx,hc_tpx,'k')
    
    
    [~]=map_ht_map(lat,lon,mean_ht,7,'Upper Ocean Heat Content Anomaly [J m ^{-2} x 10^9] 2009');
    [~]=map_ht_map(lat_tpx,lon_tpx,mean_com,8,'Upper Ocean Combined Heat Content Anomaly [J m ^{-2} x 10^9] 2009');
    [~]=map_ht_map(lat_tpx,lon_tpx,mean_tpx,9,'Upper Ocean Proxy Heat Content Anomaly [J m ^{-2} x 10^9] 2009');
    
    
    
    
    eval(['print -dpng -f1 /Users/johnlyman/figs/oco/mon_ohca/',file_name,'mean_one'])
    eval(['print -dpng -f2 /Users/johnlyman/figs/oco/mon_ohca/',file_name,'var_one'])
    eval(['print -dpng -f3 /Users/johnlyman/figs/oco/mon_ohca/',file_name,'slope_ht'])
    eval(['print -dpng -f4 /Users/johnlyman/figs/oco/mon_ohca/',file_name,'slope_com'])
    eval(['print -dpng -f5 /Users/johnlyman/figs/oco/mon_ohca/',file_name,'slope_tpx'])
    eval(['print -dpng -f6 /Users/johnlyman/figs/oco/mon_ohca/',file_name,'ohca_curves'])
    eval(['print -dpng -f7 /Users/johnlyman/figs/oco/mon_ohca/',file_name,'ht_2009'])
    eval(['print -dpng -f8 /Users/johnlyman/figs/oco/mon_ohca/',file_name,'com_2009'])
    eval(['print -dpng -f9 /Users/johnlyman/figs/oco/mon_ohca/',file_name,'tpx_2009'])
    close all
end


cd(oldpath)