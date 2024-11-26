tic
load('D:\GK_clim\GK_abs_sal.mat')
Asal=cat(1,Asal,Asal(1,:,:));
lon(lon<0)=lon(lon<0)+360;
lon=cat(2,lon,360);

load('J:\tree_temp_vert_nosshsst_newcycle\t_trees\tree_temp_vert_nosshsst_newcycle_yearly_overlap_seasonal_anom\tree_temp_vert_nosshsst_newcycle_yearly_overlap_seasonal_anom_5_15_2005_split_7day.mat','lon_tpx' ,'lat_tpx')
[LAT,LON]=meshgrid(lat_tpx,lon_tpx);
[LAT2,LON2]=meshgrid(lat,lon);
layer_bounds=[0, 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125,...
    135, 145, 155, 165, 175, 190, 210, 230, 250, 270, 290, 310, 330 , ...
    350, 370 , 390, 410,  430, 450, 475, 525, 575, 625, 675, 725, 775,...
    825, 875, 925, 975, 1025, 1075, 1125, 1175, 1225, 1275, 1325, 1375,...
    1450, 1550, 1650, 1750, 1850, 1950, 2000];

mean_press=(layer_bounds(1:end-1)+layer_bounds(2:end))./2;

SA_tpx=nan(length(lon_tpx),length(lat_tpx),length(mean_press));
for ipres=1:length(mean_press)

    pos_up=find(pres>=mean_press(ipres),1,'first');
    junk_Asal=squeeze(Asal(:,:,pos_up));

    if pres(pos_up)==mean_press(ipres)
        

       junk_SA=interp2(lon,lat,junk_Asal',LON,LAT);



    else
         dist_layer=pres(pos_up)-pres(pos_up-1);
         junk_Asal_shallow=squeeze(Asal(:,:,pos_up-1));
         fac_deep=(mean_press(ipres)-pres(pos_up-1))./dist_layer;
         fac_shallow=1-fac_deep;
         junk_Asal=fac_deep.*junk_Asal+fac_shallow.*junk_Asal_shallow;
         junk_SA=interp2(lon,lat,junk_Asal',LON,LAT);

    end

    
    bad=find(~isfinite(junk_SA));
    good=find(isfinite(junk_Asal));
    for ibad=1:length(bad)
        dist=abs((LON2(good)-LON(bad(ibad)))+abs(LAT2(good)-LON(bad(ibad))));
        [~,pos]=min(dist,[],'all');
        junk_SA(bad(ibad))=junk_Asal(good(pos));


    end
    
   

    % 
   

    SA_tpx(:,:,ipres)=junk_SA;

end
   
lat_sal=lat_tpx;
lon_sal=lon_tpx;
pres_sal=mean_press;
save('D:\GK_clim\GK_abs_sal_tpx.mat','SA_tpx','lon_sal','lat_sal','pres_sal')

toc./60./60





