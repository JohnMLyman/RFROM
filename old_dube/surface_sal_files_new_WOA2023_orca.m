% This code computes the quantity of fresh water in a given year and saves
% it in files based on year.

% the maxium depth of the profiles


%filename='surface_sal_jan_2014';

% load Levitus high-res climatology so we can subtract it (mean?)
% load /Volumes/ThunderBay/Data/Globalhc/Levitus/slevhr lon lat dep levsal

%[pres,lat,lon,sal,Asal]=make_read_lev_absal;
%load /Volumes/Data/Globalhc/Levitus/slevhr_abs.mat Asal sal dep lon lat


%levsal=Asal;
% levsal=[levsal(end-40:end,:,:);levsal;levsal(1:41,:,:)];
% lon=[-190.125:.25:190.125];
% levsal(:,end+1,:)=levsal(:,end,:);lat(end+1)=lat(end)+mean(diff(lat));
% 
% load /Volumes/ThunderBay/Data/WOA09/salinity_monthly_1deg.mat lon lat depth sal time

read_woa2023_orca

%[pres,lat,lon,sal,Asal]=make_read_lev_absal_season;
%load /Volumes/Data/Globalhc/Levitus/salinity_monthly_1deg_abs.mat Asal sal depth lon lat time


%sal=Asal;
% shift salinity so that the grid goes from -180 to 180
% ii_lev=find(lon<=180);
% jj_lev=find(lon>180);
% lon=[lon(jj_lev)-360;lon(ii_lev)];
% sal=[sal(jj_lev,:,:,:);sal(ii_lev,:,:,:)];

time=time_woa;


lev_sal=squeeze(sal(:,:,:,:));
lev_lon=[lon(end-40:end)-360; lon; 360+lon(1:41)];
lev_lat=lat;
lev_time=[time(end)-365.25 ;time ;365.25+time(1)];
lev_sal=[lev_sal(end-40:end,:,:,:);lev_sal;lev_sal(1:41,:,:,:)];

lev_sal=cat(4,lev_sal(:,:,:,end),lev_sal);
lev_sal=cat(4,lev_sal,lev_sal(:,:,:,1));

dep=depth;

cd(path_sal);
d=sdir(['den_den*.mat']);

% these are the fields that will be saved in the fresh water file

time_surface=[];coords_surface=[];dt_surface=[];surface_sal_surface=[];

for i=1:length(d)
    i
    d(i).name
   file_name=d(i).name
     wmo_number=str2num(file_name(13:16));
    
    if (exist([d(i).name]) & exist(['ind_den_den_no_f',num2str(wmo_number),'.mat']))
        
    eval(['load ',d(i).name]);
    eval(['load ind_den_den_no_f',num2str(wmo_number),'.mat'])
   
            % subsect the good files.
            coords(bad_total,:)=[];
            mdep(bad_total)=[];
            sal(bad_total,:)=[];
            temp(bad_total,:)=[];
            fpress(bad_total,:)=[];
            time(bad_total)=[];
            dt(bad_total,:)=[];
            
            
            
            if length(mdep) >=1 

                % compute the depth [this is an ad hoc method but it is widely accepted
                %                   and is not a function of time (ie changing salinity
                %                   and temp so that the only variation is the change
                %                   in Salinity)]

                depth=sw_dpth(fpress',coords(:,2)')';


              % interpolate salinity climatology onto temp profiles
              day_of_year_argo=datenum([dt,time,time*0,time*0])-datenum([dt(:,1),dt(:,1)*0,dt(:,1)*0,time,time*0,time*0]);
              ii=find(lev_lon<max(coords(:,1))+10&lev_lon>min(coords(:,1)-10));
              jj=find(lev_lat<max(coords(:,2))+10&lev_lat>min(coords(:,2)-10));
              
              
              mean_sal=zeros(size(temp,1),length(dep));
              mean_sal2=mean_sal;
              [lat1,lon1]=meshgrid(lev_lat(jj),lev_lon(ii));
              n1lat=length(jj);
              n1lon=length(ii);
              for l=1:length(dep)
                    
                    junk_mean_sal=interp3(lev_lat(jj),lev_lon(ii),lev_time,squeeze(lev_sal(ii,jj,l,:)),...
                    coords(:,2),coords(:,1),day_of_year_argo);
                 pos_nan=find(~isfinite(junk_mean_sal));
                 if ~isempty(pos_nan)
                      
                     month_pos=dt(pos_nan,2);
                     s1=squeeze((lev_sal(ii,jj,l,2:13)));
                      
                     n_nan=length(pos_nan);
                     
                     
                     lat_coords=repmat(reshape(coords(pos_nan,2),[1 1 n_nan]),[n1lon n1lat 1]);
                     lon_coords=repmat(reshape(coords(pos_nan,1),[1 1 n_nan]),[n1lon n1lat 1]);
                     
                     lat1_s=lat1;
                     lat1_s(~isfinite(s1(:,:,1)))=NaN;
                     
                     lat1_big=repmat(lat1_s,[1 1 n_nan]);
                     lon1_big=repmat(lon1,[1 1 n_nan]);
                     
                     dist=sqrt((lat_coords-lat1_big).^2+(lon_coords-lon1_big).^2);
                     dist2=reshape(dist,[n1lon*n1lat,n_nan]);
                     
                     [~,pos_min2]=nanmin(dist2);
                     [pos_min_lon,pos_min_lat]=ind2sub([n1lon,n1lat],pos_min2);
                     pos_min3=sub2ind([n1lon,n1lat,12],pos_min_lon,pos_min_lat,month_pos');
                     
%                      junk_mean_sal2=interp2(lev_lat(jj),lev_lon(ii),squeeze(lev_sal(ii,jj,l,1)),...
%                     coords(pos_nan,2),coords(pos_nan,1),'nearest');
%                 
                
                mean_sal2(:,l)=junk_mean_sal;
               
               
                
                junk_mean_sal(pos_nan)=s1(pos_min3);
                 end
                 mean_sal(:,l)=junk_mean_sal;
                 
              end %if

              nprof=length(mdep);
              surface_sal=ones(nprof,1)*NaN;



              for iprof=1:nprof

                junk_depth=depth(iprof,:);
                junk_sal=sal(iprof,:);
                junk_press=fpress(iprof,:);
                junk_press(junk_press<0)=0;
                
         %       junk_temp=temp(iprof,:);
                junk_lon=squeeze(coords(iprof,1));
                if junk_lon>180
                    junk_lon=junk_lon-360;
                end
                junk_lat=squeeze(coords(iprof,2));   
               np=length(junk_sal);
               junk_lon=repmat(junk_lon,1,np);
               junk_lat=repmat(junk_lat,1,np);
                good=find(junk_depth <= 25);
                
                if ~isempty(good) && isfinite(sum(mean_sal(iprof,:)))

        %        [junk_fresh_water]=fresh_water_input(junk_temp,junk_sal,junk_depth,junk_mean_sal,max_depth);
                     junk_mean_sal=interp1(dep,mean_sal(iprof,:)',junk_depth','pchip')';
                     
                     % Jan 28, 2021 switching to practical Salinity from
                     % Absolute Salinity for consitancy in State of the
                     % Climate
% % %                    junk_sal = gsw_SA_from_SP(junk_sal,junk_press,junk_lon,junk_lat);
% % %                    junk_mean_sal=gsw_SA_from_SP(junk_mean_sal,junk_press,junk_lon,junk_lat);
% % %                     %sal  = gsw_SA_from_SP(sal2,fpress,lono,lato);
                    junk_surface_sal=junk_sal-junk_mean_sal;
                    [junk,p_min]=min(junk_depth);
                   if length(p_min) > 1 
                       p_min=p_min(1);
                   end
              
                    surface_sal(iprof)=junk_surface_sal(p_min);
                    clear junk p_min
                end
                clear junk_temp junk_sal junk_depth junk_mean_sal junk_surface_sal
              end %for

          % add the freshwater from the square to our estimate


        time_surface=[time_surface',time']';
        coords_surface=[coords_surface',coords']';
        dt_surface=[dt_surface',dt']';
        surface_sal_surface=[surface_sal_surface',surface_sal']'; 

        clear surface_sal coords mdep sal temp time fpress dt bad_total shallow
        end %if
        
    end %if

end %for


% a QC to remove an obvious outliers that the proximity filter did not find

bad=find(abs(surface_sal_surface) >= 20);

coords_surface(bad,:)=[];
dt_surface(bad,:)=[];
surface_sal_surface(bad)=[];
time_surface(bad)=[];
eval(['save ',filename,'.mat  time_surface coords_surface dt_surface surface_sal_surface']);




% filename='surface_sal_nov_2010_2011';
% nc_idl_surface_sal_new(filename);
