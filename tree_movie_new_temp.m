% min_layer=0;
% max_layer=2000;
% syear=2021;
% fyear=syear-1;
% 
% 
% path_figs='C:\data\OHCA\figs\tree_paper\'
% year_of_oco_pub=2022;
% slope_min_year=1993;
% file_name='argo_2021_01_01_QC'
% % this is the time range of the maps that are to be saved and outputted
% max_year_maps_out=2021;
% min_year_maps_out=1993;
cold_to_hot_colormap=diverging_map([0:1/200:1],[20 43 140]/255,[204 0 51]/255);
% 
%  tree_model_file_name='baggedtree_sst_tpx_all2';
% tree_model_file_name='tree_sst_tpx_year_1993'
% tree_model_file_name='tree_sst_tpx_yearly';
% tree_model_file_name=['tree_sst_tpx_all_year_seasonal_anom'];
% tree_model_file_name=['tree_sst_tpx_combined_seasonal_anom'];
% tree_model_file_name_old='tree_sst_tpx_yearly_overlap_seasonal';
% % tree_model_file_name=[tree_model_file_name_old,'_anom'];
% path_OHCA_data_out='C:\data\OHCA\'
% path_OHCA_data_in='C:\OHCA\'
% 
% 
%  layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
% file_name='argo_2021_02_02_QC'
% path_tree=[path_OHCA_data_out,'OHCA_trees\'];
% 
% file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
% path_ssh=[path_OHCA_data_in,'Mtpers\'];
% nlayers=length(layer_bounds);
% endlayer=find(layer_bounds==max_layer);
% startlayer=find(layer_bounds==min_layer)+1;
% file_sum_name=[path_tree,tree_model_file_name,'_',num2str(min_layer),'_',num2str(max_layer),'_7day.mat'];
% 
% if ~exist(file_sum_name,'file')
%     bagged_tree_ohca_maps_7_day
% else
%     load(file_sum_name,'ht_estimate','lon_tpx','lat_tpx','time_aviso')
% end
% 
% mean_ht=nanmean(ht_estimate,3);
% ht_estimate=ht_estimate-mean_ht;
%%


v=VideoWriter([path_Figs,'ohca_0_2000_2023_all.avi']);
v.FrameRate=2;
open(v)
% nframe=length(time_aviso);
% 
% 
% year_aviso=floor(time_aviso);
% aviso_day=1+(time_aviso-year_aviso).*yeardays(year_aviso);
% sday=round(aviso_day+datenum(year_aviso,1,1)-1);
% 
% days_since_1950=sday-datenum(1950,1,1);%NEED TO CHECK THIS

subdir='yearly_withcycle';
start_year_file=start_year;
end_year_file=end_year;
path_new_tree=path_new_tree_combined_withcycle;
tree_model=tree_model_file_name_combined_withcycle;
% tree_file_name=tree_file_name_in;
%%

path_nc_erddap=[path_ERDDAP,'netcdf\',tree_prefix,'\',subdir,'\'];
if var_type=='s'
     file_prefix='RFROMv21_SAL_';
elseif var_type=='t'
     file_prefix='RFROMV_TEMP_';
elseif var_type=='h'
     file_prefix='RFROMV21_OHC_';
end
%%


start_year_movie=1993;
start_month_movie=1;
end_year_movie=2023;
end_month_movie=12;

nyears_movie=end_year_movie-start_year_movie+1;

years_movie=repelem(start_year_movie:end_year_movie,12);
months_movie=repmat(1:12,[1 nyears_movie]);

months_movie=months_movie(start_month_movie:end-12+end_month_movie);
years_movie=years_movie(start_month_movie:end-12+end_month_movie);

nfiles=length(months_movie);





for ifile=1:nfiles

    %load in data
    year_load=years_movie(ifile);
    month_load=months_movie(ifile);

     if month_load>=10
          file_name_nc= [path_nc_erddap,file_prefix,num2str(year_load),'_',num2str(month_load),'.nc'];
       else
          file_name_nc= [path_nc_erddap,file_prefix,num2str(year_load),'_0',num2str(month_load),'.nc'];
     end

     lon_tpx=double(ncread(file_name_nc,'longitude'));
     lat_tpx=double(ncread(file_name_nc,'latitude'));

     time=double(ncread(file_name_nc,'time'));

     ohca_total=ncread(file_name_nc,'ocean_heat_content_anomaly');

     ntime=length(time);





    for itime=1:ntime


        figure(1)
        clf
            set(gcf,'color','white');
            m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
            
            
            
            
            corrhc=double(squeeze(jnansum(ohca_total(:,:,:,itime),3)));
            date_name=datestr(time(itime)+datenum(1950,1,1));

           
            
            
            lon=lon_tpx';
            lat=lat_tpx';
            scale_fac=1;
            
            % put into the proper coordinates




            del_val=2/scale_fac;
            del_cont=.5/scale_fac;
            min_val=-3./scale_fac;
            max_val=3./scale_fac;
            del_val=.5./scale_fac;
            del_cont=.25./scale_fac;
            ii=find(lon<30);
            jj=find(lon>=30);
            lon=[lon(jj),lon(ii)+360];
            corrhc=[corrhc(jj,:);corrhc(ii,:)];
            %colormap jet(256)
            
            colormap(cold_to_hot_colormap) 
            
            
            m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
            %colormap(fresh_to_salty_colormap) 
            [cs1,h1]=m_contourf(lon,lat,corrhc',[-1000,min_val:del_cont:max_val]);
            % % 'cat'
        %     save 'OHCA_2019_tpx.mat' lon lat corrhc
            hold on
            set(h1,'linecolor','none')
            hold on
            m_grid('tickdir','out','xtick',[30:60:390],'ytick',[-90:30:90],'linestyle','none');
            
            
            %[cs12,h12]=m_contour(lon_cont,lat_cont,sal_cont',[32 32],'k');
            a=gca;
            hold on
            m_coast('patch',[1 1 1]);
            t1=m_text(30,100,[' ', date_name],'fontsize',12);
            %t3=m_text(50,45,[num2str(depth_top_plot),'-',num2str(depth_bot_plot)],'fontsize',12);
             t2=m_text(170,-150,'(10^9 J m ^{-2})','fontsize',10);
            
            caxis([min_val max_val-del_cont])
            
            hold off
            
            ja=axes('pos',[.262 .90-.0475 .51 .01]);
            %colormap jet(256)
            
            colormap(cold_to_hot_colormap) 
            
            [cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:del_cont:max_val]);
            set(h,'edgecolor','none')
            set(ja,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
            caxis([min_val max_val-del_cont])
            japos=get(ja,'pos');
            set(ja,'XAxisLocation','bottom','pos',japos-[.075 .7 -.15 -.015])
        
            frame=getframe(gcf);
            writeVideo(v,frame)
    end


end
close(v)
