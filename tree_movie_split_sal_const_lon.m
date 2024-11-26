function   tree_movie_split_sal_const_lon
%%

%%
path_ERDDAP='H:\erddap\sal_3_n_mean_half\';

path_mat_erddap=[path_ERDDAP,'matlab\mean\'];
path_nc_erddap=[path_ERDDAP,'netcdf\mean\'];

path_figs='H:\Figs\'

% this is the time range of the maps that are to be saved and outputted

cold_to_hot_colormap=diverging_map([0:1/200:1],[20 43 140]/255,[204 0 51]/255);

fresh_to_salty_colormap=diverging_map([0:1/100:1],[20 43 140]/255,[204 85 0]/255); 

 

%%





%%

 % put into the proper coordinates
    
    min_val=34;
    max_val=37.5;
v=VideoWriter([path_figs,'tree_sal.avi']);
v.FrameRate = 10;
open(v)
% nframe=length(time_aviso);
iframe=0;

iyear=2010;
imonth=10;
filename_nc= [path_nc_erddap,'RFROM_SAL_',num2str(iyear),'_',num2str(imonth),'.nc'];
[~,lon_tpx,lat_tpx,pres,~]=load_sal_nc(filename_nc);
depth=pres;

for imonth=1:12
     if imonth>=10
              filename_nc= [path_nc_erddap,'RFROM_SAL_',num2str(iyear),'_',num2str(imonth),'.nc'];
           else
              filename_nc= [path_nc_erddap,'RFROM_SAL_',num2str(iyear),'_0',num2str(imonth),'.nc'];
      end
    
    [sal,~,~,~,time_1950]=load_sal_nc(filename_nc);
    s_sal=size(sal);
    for iiframe=1:s_sal(4)
        iframe=iframe+1;
%         [yframe,mframe,dframe]=datevec(double(time_1950(iiframe)+datenum(1950,1,1)));
        date_frame=datestr(double(time_1950(iiframe)+datenum(1950,1,1)));


%%     
b=figure(1);
set(b, 'Position', [100 100 1200 400])
clf

    set(gcf,'color','white');
   
    
    
    
    
%     corrhc=ht_estimate(:,:,iframe)./1e9;
%    corrhc=ht_out_mean;
%    corrhc=ht_estimate_mean(:,:,iframe);
    corrhc=squeeze(sal(1340,:,:,iiframe));
    
    
    
    % put into the proper coordinates
    
    cont_level=[min_val:.2:max_val];
    val_level=[min_val:1:max_val];
    del_cont=abs(cont_level(end)-cont_level(end-1));
    
    
    colormap(fresh_to_salty_colormap) 
    
    
   
    %colormap(fresh_to_salty_colormap) 
    [cs1,h1]=contourf(lat_tpx,-1.*depth,corrhc',...
        [-1000,min_val:del_cont:max_val]);
    a=gca;
    set(a,'xtick',[],'ytick',[])
        set(a,'tickdir','out','xtick',[0:10:360],'ytick',[-2000:0:0],...
            'XAxisLocation','bottom');
    yticklabels(([2000:-50:0]))
    axis(a,[-62 70 -2000 0])
    apos=get(a,'pos');
   title(date_frame)
    set(a,'pos',apos-[0 -.1 0 .1])

 
%     save 'OHCA_2019_tpx.mat' lon lat corrhc
    hold on
%     set(h1,'linecolor','none')
    hold on
%     m_grid('tickdir','out','xtick',[30:60:390],'ytick',[-90:30:90],'linestyle','none');
    
    
    %[cs12,h12]=m_contour(lon_cont,lat_cont,sal_cont',[32 32],'k');
    a=gca;
    hold on
   
%     t1=m_text(30,100,[' ', num2str(time_aviso(iframe))],'fontsize',12);
%     %t3=m_text(50,45,[num2str(depth_top_plot),'-',num2str(depth_bot_plot)],'fontsize',12);
%      t2=m_text(170,-150,'(10^9 J m ^{-2})','fontsize',10);
    
    caxis([min_val max_val-del_cont])
% %     
    hold off
    
    ja=axes('pos',[.262 .90-.0475 .51 .01]);
    %colormap jet(256)
    
    colormap(fresh_to_salty_colormap) 
    
    [cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],cont_level);
    set(h,'edgecolor','none')
    set(ja,'tickdir','out','xaxisl','top','xtick',val_level,'ytick',[])
    caxis([min_val max_val-del_cont])
    japos=get(ja,'pos');
    set(ja,'XAxisLocation','bottom','pos',japos-[.075 .77 -.15 -.015])
%% 
    frame=getframe(gcf);
    writeVideo(v,frame)



    end
end

close(v)


end


function [sal,lon,lat,pres,time_1950]=load_sal_nc(filename)

sal=ncread(filename,'ocean_salinity');
lon=ncread(filename,'longitude');
lat=ncread(filename,'latitude');
time_1950=ncread(filename,'time');
pres=ncread(filename,'mean_pressure');


end


