tree_model_file_name_old='tree_sst_tpx_yearly_overlap_seasonal';
tree_model_file_name_var='tree_sst_tpx_all_year_seasonal_anom';
tree_model_file_name=[tree_model_file_name_old,'_anom'];
path_OHCA_data_out='C:\data\OHCA\'
file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
path_tree=[path_OHCA_data_out,'OHCA_trees\'];
path_new_tree=[path_tree,tree_model_file_name,'\'];
file_name='argo_2020_10_14_QC';
file_WOD_suf='_cheng_EN4_2014';
file_path_hdata=[path_OHCA_data_out,'OHCA_maps\'];


start_year=1993;
end_year=2021;




 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
 nlayer=length(layer_bounds);
file_hold_out_estimate=[path_new_tree,tree_model_file_name,'_hold_out_estiamte.mat'];


 load(file_hold_out_estimate)
 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
 nlayer=length(layer_bounds);



for ilayer=2:nlayer
    
    fig_num=(ilayer-2)*10;
   layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
   ht_var_estimate_name=[path_tree,tree_model_file_name_var,'_',layer_name,'_7day_var.mat'];
   eval(['hold_out_mat=hold_out_mat_',layer_name,';'])
   eval(['ht_estimate=ht_estimate_',layer_name,';'])
   eval(['ht=ht_',layer_name,';'])
   var_holdout=nans(length(ht),1);




   yr=hold_out_mat(:,1);
    lon=hold_out_mat(:,2);
    lat=hold_out_mat(:,3);
    ssh=hold_out_mat(:,4);
    sst=hold_out_mat(:,5);
    
    pos_360=lon<0;
    lon_180=lon;
    lon(pos_360)=lon_180(pos_360)+360 ;
    good_180=lon_180>-90 & lon_180<90;

    %% load in the variance estimate and than interptert it to the loaction of 
    % the hold out estimates
    load(ht_var_estimate_name,'var_ht_yearly','lon_tpx','lat_tpx')

    pos_aviso_180=lon_tpx>180;
    lon_tpx_180=[lon_tpx(pos_aviso_180)-360 ; lon_tpx(~pos_aviso_180)];

    [LON,LAT]=ndgrid(lon_tpx,lat_tpx);
    [LON_180,~]=ndgrid(lon_tpx_180,lat_tpx);
  
    var_ht_yearly_180=[var_ht_yearly(pos_aviso_180,:);var_ht_yearly(~pos_aviso_180,:)];
    F=griddedInterpolant(LON,LAT,var_ht_yearly);
      F_180=griddedInterpolant(LON_180,LAT,var_ht_yearly_180);
      jlon=lon(~good_180);
      jlat=lat(~good_180);
      jlon_180=lon_180(good_180);
      jlat_180=lat(good_180);
    
      var_holdout(~good_180,1)=F(jlon,jlat);
      var_holdout(good_180,1)=F_180(jlon_180,jlat_180);

      %%%

    ht_diff=ht-ht_estimate;
    

    ht_per_var=ht_diff.^2./var_holdout;
   
    layer_name
    good=abs(lat)<10;
    mean_diff=nanmean(ht_diff(good))

    mean_frac=mean_diff./sqrt(nanmean(var_holdout(good)))

    lonplot=lon;
    lonplot(lon<30)=lonplot(lon<30)+360;

    
    figure(1+fig_num)
    histogram(ht_diff(good))
     title([layer_name,'    ', num2str(mean_diff)],'Interpreter', 'none')
    figure(2+fig_num)
    histogram(ht_per_var(good),[0:.1:5])
    title([layer_name,'    ', num2str(mean_frac)],'Interpreter', 'none')
     xlim([0 5])
% %     figure(3+fig_num)
% % %     scatter(lon(good),lat(good),3,ht_per_var(good),'filled')
% %      scatter(lonplot,lat,3,sqrt(ht_diff.^2),'filled')
% %     title(layer_name,'Interpreter', 'none')
% %     figure(4+fig_num)
% %    scatter(lonplot,lat,3,sqrt(var_holdout),'filled')
% %     figure(5+fig_num)
% %    scatter(lonplot,lat,3,(ht_per_var),'filled')
% %     title(layer_name,'Interpreter', 'none')
% %    caxis([0 5])

    
'cat'
  




end