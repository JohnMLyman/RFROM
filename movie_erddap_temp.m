function []=movie_erddap_temp(TreeSetUp)



nbasins_use=TreeSetUp.nbasins_use;
file_name=TreeSetUp.file_name;
var_type=TreeSetUp.var_type;

file_name_season=TreeSetUp.file_name_season;
file_name_season_anom=TreeSetUp.file_name_season_anom;
file_WOD_suf=TreeSetUp.file_WOD_suf;
file_path_hdata=TreeSetUp.file_path_hdata;
fname_nc_season=TreeSetUp.fname_nc_season;
fname_nc=TreeSetUp.fname_nc;

path_ERDDAP=TreeSetUp.path_ERDDAP;


tree_prefix=TreeSetUp.tree_prefix;
tree_model_file_name_season=TreeSetUp.tree_model_file_name_season;
tree_model_file_name_yearly=TreeSetUp.tree_model_file_name_yearly;
tree_model_file_name_all_year=TreeSetUp.tree_model_file_name_all_year;
tree_model_file_name_combined=TreeSetUp.tree_model_file_name_combined;
tree_model_file_name_combined_withcycle=TreeSetUp.tree_model_file_name_combined_withcycle;

% 
% file_name_season=[file_name,'_seasonal'];
% file_name_season_anom=[file_name_season,'_anom'];

path_oisst=TreeSetUp.path_oisst;
path_OHCA_data_out=TreeSetUp.path_OHCA_data_out;
path_OHCA_data_in=TreeSetUp.path_OHCA_data_in;
path_ssh=TreeSetUp.path_ssh;

path_tree=TreeSetUp.path_tree;
path_new_tree_season=TreeSetUp.path_new_tree_season;
path_new_tree_yearly=TreeSetUp.path_new_tree_yearly;
path_new_tree_all_year=TreeSetUp.path_new_tree_all_year;
path_new_tree_combined=TreeSetUp.path_new_tree_combined;
path_new_tree_combined_withcycle=TreeSetUp.path_new_tree_combined_withcycle;


path_tree_junk=TreeSetUp.path_tree_junk;
path_curve=TreeSetUp.path_curve;

layer_bounds=TreeSetUp.layer_bounds;

start_year=TreeSetUp.start_year;
end_year=TreeSetUp.end_year;

start_year_mean=TreeSetUp.start_year_mean;
end_year_mean=TreeSetUp.end_year_mean;
max_year_fit=TreeSetUp.max_year_fit;
min_year_fit=TreeSetUp.min_year_fit;
center_year=TreeSetUp.center_year;

start_yearly_maps=TreeSetUp.start_yearly_maps;
end_yearly_maps=TreeSetUp.end_yearly_maps;

start_all_year=TreeSetUp.start_all_year;
end_all_year=TreeSetUp.end_all_year;

start_year_trans=TreeSetUp.start_year_trans;
end_year_trans=TreeSetUp.end_year_trans;



%%
% tree_model=[tree_model_file_name_yearly,'_withcycle'];
% path_new_tree=[path_new_tree_yearly,'withcycle/'];
path_figs='o:\'
ilayer=1
subdir='yearly_withcycle';
start_year_file=start_year;
end_year_file=end_year;
path_new_tree=path_new_tree_combined_withcycle;
tree_model=tree_model_file_name_combined_withcycle;
% tree_file_name=tree_file_name_in;
%%

path_nc_erddap=[path_ERDDAP,'netcdf\',tree_prefix,'\',subdir,'\'];
if var_type=='s'
     file_prefix='RFROM_SAL_';
elseif var_type=='t'
     file_prefix='RFROM_TEMP_';
else
    'need to set this up for heatcontent'
end


% because the data is geroup by year if the start year is a whole number
% then the files will start in the pervious year
start_year_ssh=floor(start_year_file);
if floor(start_year_file)==start_year_file
    start_year_ssh=start_year_file-1;
end
end_year_ssh=floor(end_year_file);
time_ssh_load=start_year_ssh:end_year_ssh;




%%
mean_pressure=(layer_bounds(1:end-1)+layer_bounds(2:end))./2;
mean_pressure=mean_pressure';
mean_pressure_bnds=[layer_bounds(1:end-1); layer_bounds(2:end)];
ht_estimate_mean=[];
time_total=[];

for year_load=time_ssh_load

    display(year_load)
   
%     [ht_estimate,lat_tpx,lon_tpx,time_aviso]=...
%         make_vertical_year(path_new_tree,tree_model,year_load,TreeSetUp);
%     year_aviso=floor(time_aviso);
%     aviso_day=1+(time_aviso-year_aviso).*yeardays(year_aviso);
%     sday=round(aviso_day+datenum(year_aviso,1,1)-1);
%     days_since_1950=sday-datenum(1950,1,1);
%     [~,month_data]=datevec(days_since_1950+datenum(1950,1,1));
    
    for imonth=1:12
       

       
           


            if imonth>=10
                  file_name_nc= [path_nc_erddap,file_prefix,num2str(year_load),'_',num2str(imonth),'.nc'];
               else
                  file_name_nc= [path_nc_erddap,file_prefix,num2str(year_load),'_0',num2str(imonth),'.nc'];
            end
            if exist(file_name_nc,'file')
                if var_type =='t'
             
               
    
                      temp=ncread(file_name_nc,'ocean_temperature');
                      jtime=ncread(file_name_nc,'time');
                      lon_tpx=ncread(file_name_nc,'longitude');
                      lat_tpx=ncread(file_name_nc,'latitude');
                      ht_estimate_mean=cat(3,ht_estimate_mean,squeeze(double(temp(:,:,ilayer,:))));
                      jtime_vec=datevec(double(jtime)+datenum(1950,1,1));
                      time_total=cat(1,time_total,jtime_vec(:,1:3));
                     
                elseif var_type=='s'
    %                  write_netcfd_cf_sal_pressure_mon_single(mon_estimate,time_1950,lon_tpx,...
    %                        lat_tpx,mean_pressure,mean_pressure_bnds,file_name_nc)
                else
                    'need to set this up for heatcontent'
                end
    
              
     
           end

    end
end
save([path_figs,'temp_',num2str(ilayer),'.mat'],'ht_estimate_mean','time_total','lat_tpx','lon_tpx','-v7.3')

v=VideoWriter([path_figs,'movie_temp_',num2str(ilayer),'.avi']);
v.FrameRate = 10;
open(v)
nframe=length(time_total(:,1));
for iframe=1:nframe
%%     
b=figure(1);
% set(b, 'Position', [100 100 1200 400])
clf
    set(gcf,'color','white');
    m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
    
    
    
    

   corrhc=ht_estimate_mean(:,:,iframe);
    
    scale_fac=1;
    lon=lon_tpx';
    lat=lat_tpx;
    % put into the proper coordinates
   
   min_val=0;
    max_val=30;
    del_val=2;
    del_cont=1;
    ii=find(lon<30);
    jj=find(lon>=30);
    lon=[lon(jj),lon(ii)+360];
    corrhc=[corrhc(jj,:);corrhc(ii,:)];
    colormap jet(256)
    
%     colormap(cold_to_hot_colormap) 
    
%     
    m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
%     m_proj('Equidistant cylindrical','long',[260 290],'lat',[5 33]);
    %colormap(fresh_to_salty_colormap) 
    [cs1,h1]=m_contourf(lon,lat,corrhc',[-1000,min_val:del_cont:max_val]);
    % % 'cat'
%     save 'OHCA_2019_tpx.mat' lon lat corrhc
    hold on
    set(h1,'linecolor','none')
    hold on
    m_grid('tickdir','out','xtick',[30:60:390],'ytick',[-90:30:90],'linestyle','none');
    title(['temp ',num2str(time_total(iframe,:))])
    
    %[cs12,h12]=m_contour(lon_cont,lat_cont,sal_cont',[32 32],'k');
    a=gca;
    hold on
    m_coast('patch',[1 1 1]);
%     t1=m_text(30,100,[' ', num2str(time_aviso(iframe))],'fontsize',12);
    %t3=m_text(50,45,[num2str(depth_top_plot),'-',num2str(depth_bot_plot)],'fontsize',12);
     t2=m_text(170,-150,'(10^9 J m ^{-2})','fontsize',10);
    
    caxis([min_val max_val-del_cont])
    
    hold off
    
    ja=axes('pos',[.262 .90-.0475 .51 .01]);
    colormap jet(256)
    
%     colormap(cold_to_hot_colormap) 
    
    [cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:del_cont:max_val]);
    set(h,'edgecolor','none')
    set(ja,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
    caxis([min_val max_val-del_cont])
    japos=get(ja,'pos');
    set(ja,'XAxisLocation','bottom','pos',japos-[.075 .7 -.15 -.015])
    
    
    % put into the proper coordinates
    
   
   
%% 
    frame=getframe(gcf);
    writeVideo(v,frame)

end
close(v)

       
    
end


