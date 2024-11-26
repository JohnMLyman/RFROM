% getalltp.m - matlab script to read in ALL merged T/P data from
% netcdf files and save them in equavilent matlab files.
% also calculate 10-year time mean and annual cycle for removal
% 1/3/3

% get directory info and keep only files from 1993- for mean
% and seasonal cycle 

%modified 1-15-2007 jml

% 11-3-05 new2 and different!  removes old mat files and then recomputes the
%   offset over two months than loads the realtime data to fill in the gap

%move all the new SSH files out of their subdirecories


dnew_real=dir([path_OHCA_data_in,'\Mtpers\realtime_oco\*\*\*.nc']);
for ifile_real=1:length(dnew_real)
    movefile([dnew_real(ifile_real).folder,'\',dnew_real(ifile_real).name],[path_OHCA_data_in,'\Mtpers\realtime_oco'],'f')
end

dnew_dt=dir([path_OHCA_data_in,'\Mtpers\delayed_oco\*\*\*.nc']);
for ifile_dt=1:length(dnew_dt)
    movefile([dnew_dt(ifile_dt).folder,'\',dnew_dt(ifile_dt).name],[path_OHCA_data_in,'\Mtpers\delayed_oco'],'f')
end

cd([path_OHCA_data_in,'\Mtpers\delayed_oco'])
% cd /Volumes/ThunderBay/Data/Globalhc/Mtpers/delayed_oco
d=[sdir('*.nc')];
dy=strjust(strvcat(d(:).name),'right');
year=str2num(dy(:,29-4:32-4));
month=str2num(dy(:,33-4:34-4));
day=str2num(dy(:,35-4:36-4));
dy=datenum(year,month,day)-datenum(1950,1,1);


%THIS SETS THE DATE RANGE OF THE dyelaed mode data with over lap into
%realtime range
tmin=datenum(1993,1,1)-datenum(1950,1,1);
%tmax=datenum(2015,12,31)-datenum(1950,1,1);
% the max date is not 2016,12,31 because no realtime data for before
% 2017,1,7


tmax=datenum(2020,6,8)-datenum(1950,1,1);

%jj=find(dy>=tmin);% only load delyed mode data that it is older that 2 years (so that diferences)
%	can be made

jj=find(dy>=tmin&dy<=tmax);


% initialize variabiles for making variance and mean
sj2=zeros(1440,720);sj=sj2;nj=sj;
cycj=zeros(1440,720,4);ncycj=cycj;
%% Read in the delayed mode files
sind=fix(mod(dy+datenum(1950,1,1)-datenum(1992,1,1),365.25)/365.25*4)+1;

[sla]=read_netcdf_getall_getprofiles_tuna(d(jj(1)).name,'sla');
[lat]=read_netcdf_getall_getprofiles_tuna(d(jj(1)).name,'latitude');
[lon]=read_netcdf_getall_getprofiles_tuna(d(jj(1)).name,'longitude');

%    nc_getall(d(jj(1)).name); 
tic

for i=1:7:length(jj)
  % load netcdf file
% %   [sla]=read_netcdf_getall_getprofiles(d(jj(i)).name,'sla');
    [sla]=read_netcdf_sla_tuna(d(jj(i)).name);

  %nc_getall(d(jj(i)).name);
  gd=double(sla');
  clear sla 

  % count NaNs so we can do nanmean and nanstd
  gd(gd==min(gd(:)))=NaN;
  nj=nj+~isnan(gd);
  ncycj(:,:,sind(jj(i)))=ncycj(:,:,sind(jj(i)))+~isnan(gd);
  gd(isnan(gd))=0;
  
  % tabulate vars. for mean and annual cycle
  sj2=sj2+gd.^2;
  sj=sj+gd;
  cycj(:,:,sind(jj(i)))=cycj(:,:,sind(jj(i)))+gd;
  clear gd
  disp([d(jj(i)).name,'  ',num2str(toc)])
end

ii=find(nj==0); nj(ii)=NaN;
sshmean=sj./nj;
sshvar=sj2./nj-sshmean.^2;

ll=find(ncycj==0);ncycj(ll)=NaN;
sshcyc=cycj./ncycj; sshcyc=sshcyc-repmat(sshmean,[1 1 size(sshcyc,3)]);
gmo=[-1.5:3:13.5];poo=zeros([size(sshmean),length(gmo)]);
poo(:,:,1)=sshcyc(:,:,end);poo(:,:,end)=sshcyc(:,:,1);
poo(:,:,2:end-1)=sshcyc;sshcyc=poo;clear poo


% d_total=d;
% dy_total=dy;
d=d(jj);

dy=dy(jj);
gmo=[-1.5:3:13.5];
% % % clear nj sj sj2 ncycj cycj ii ll jj 

cd ..
% eval(['save meanssh_oco_realtime_',file_name,' sshmean sshvar lat lon gmo sshcyc'])

sshmean2=sshmean;
sshcyc2=sshcyc;



%% 11-3-2005 compute the offset over 2 weeks averaged over the whole globe
%% 11-13-2017 changed to start on the end of the delayed mode for over lap 
%% this assumes that the there is delayed mode data 

last_delayed=dy(end);

prefex_realtime_name='./realtime_oco/nrt_global_allsat_phy_l4_';
prefex_realtime_dir='./realtime_oco/';

prefex_delayed_name='./delayed_oco/dt_global_allsat_phy_l4_';
prefex_delayed_dir='./delayed_oco/';
arw=areavec(lon,lat);
number_overlap=7;
start_time=last_delayed-7*number_overlap;
bad_lat=find(abs(lat)>=66);

%
sshm_real=0;
sshm_delayed=0;


d_realtime=sdir([prefex_realtime_dir,'*.nc']);
dy_realtime=strjust(strvcat(d_realtime(:).name),'right');
year_realtime=str2num(dy_realtime(:,26:29));
month_realtime=str2num(dy_realtime(:,30:31));
day_realtime=str2num(dy_realtime(:,32:33));
dy_realtime=datenum(year_realtime,month_realtime,day_realtime)-datenum(1950,1,1);



for ii= start_time:7:last_delayed
   
    % load the realtime data and compute its mean

	
   
    
       
    % load the delayed time data and compute it's mean
    date_delayed=datevec(ii+datenum(1950,1,1));
    delay_day=num2str(date_delayed(3));
    delay_month=num2str(date_delayed(2));
    delay_year=num2str(date_delayed(1));
    if date_delayed(3) < 10
	delay_day=['0',delay_day];
    end
    if date_delayed(2) < 10
	delay_month=['0',delay_month];
    end
	
    
    %%%%%%
    
     djunk=[sdir([prefex_realtime_name,delay_year,delay_month,delay_day,'*.nc'])];
% %      [sla]=read_netcdf_getall_getprofiles([prefex_realtime_dir,djunk(1).name],'sla');
          [sla]=read_netcdf_sla_tuna([prefex_realtime_dir,djunk(1).name]);

    %nc_getall([prefex_realtime_dir,djunk(1).name])
    [prefex_realtime_dir,djunk(1).name]
    sshanom=double(sla);
     sshanom(sshanom==min(sshanom(:)))=NaN;

    clear sla
    sshanom(:,bad_lat)=nan;
   sshm_real=(nansum(arw(:).*sshanom(:))/nansum(arw(~isnan(sshanom))))+sshm_real
   
   %%%%%
    
    djunk=[sdir([prefex_delayed_name,delay_year,delay_month,delay_day,'*.nc'])];
% %     [sla]=read_netcdf_getall_getprofiles([prefex_delayed_dir,djunk(1).name],'sla');
    [sla]=read_netcdf_sla_tuna([prefex_delayed_dir,djunk(1).name]);
    %nc_getall([prefex_delayed_dir,djunk(1).name])
    [prefex_delayed_dir,djunk(1).name]
    sshanom=double(sla);
    sshanom(sshanom==min(sshanom(:)))=NaN;
    sshanom(:,bad_lat)=nan;
    clear sla
    
    sshm_delayed=(nansum(arw(:).*sshanom(:))/nansum(arw(~isnan(sshanom))))+sshm_delayed

end

offset=(sshm_delayed-sshm_real)/(number_overlap+1)


% 11-3-2005 now change d so that it contains the realtime data
real_dy=dy_realtime;

good_ind=find(real_dy == last_delayed+7);

    % this part takes out real time estimates that were made in between the
    % delayed time time interval
position_factor=real_dy-last_delayed
    
%good_real=find((position_factor >=1) & (mod(position_factor,7)==0));
good_real=find((position_factor >=1));

delay_names=d;
real_names=d_realtime(good_real);

dy=[dy',real_dy(good_real)']';
d=[delay_names',real_names']';

clear ii sshanom

%% this section rewrites the data as a matlab file delayed mode for the first half and then realtime


ii=find(abs(lat)<66);
tic
for i=1:length(d)
    
    if mod(dy(i)-15706,7) == 0
    
        if d(i).name(1)=='n' 
           %  nc_getall(['realtime_oco/',d(i).name]);
% % %              [sla]=read_netcdf_getall_getprofiles(['realtime_oco/',d(i).name],'sla');
             [sla]=read_netcdf_sla_tuna(['realtime_oco/',d(i).name]);
            sla=sla';
             %nc_getall([prefex_realtime_dir,djunk(1).name])
             gmo;
        else
         date_delayed=datevec(dy(i)+datenum(1950,1,1));
         delay_day=num2str(date_delayed(3));
        delay_month=num2str(date_delayed(2));
        delay_year=num2str(date_delayed(1));
        if date_delayed(3) < 10
            delay_day=['0',delay_day];
        end
        
        if date_delayed(2) < 10
            delay_month=['0',delay_month];
        end
	
    
        djunk=[sdir([prefex_delayed_name,delay_year,delay_month,delay_day,'*.nc'])];
        %nc_getall([prefex_delayed_dir,djunk(1).name]);
% %         [sla]=read_netcdf_getall_getprofiles([prefex_delayed_dir,djunk(1).name],'sla');
        [sla]=read_netcdf_sla_tuna([prefex_delayed_dir,djunk(1).name]);
    sla=sla';
        %nc_getall([prefex_realtime_dir,djunk(1).name])
        gmo;
        
        end
        
    sshanom=double(sla);
    clear sla ncyc s s2 cyc 
    sshanom(sshanom==min(sshanom(:)))=NaN;
    sshanom=sshanom-sshmean;
    if d(i).name(1)=='m',sshanom=sshanom+offset;end
    poo=sshanom(:,ii);
    sshm(i)=nanmean(poo(:));clear poo
    sshm2(i)=nanmean(sshanom(:));
    if d(i).name(1)=='d'
        save(['matlab_files/ssh',num2str(dy(i))],'sshanom','lat','lon');
    else
        save(['matlab_files/ssh',num2str(dy(i))],'sshanom','lat','lon','offset');
    end
  disp([d(i).name,'  ',num2str(toc)])
  
    ['matlab_files/ssh',num2str(dy(i))]
 
  
  
  
  
        clear sshanom 
    end
end
%% Compute the mean and seasonal cycle
tgrid=(dy+datenum(1950,1,1))/365.2425;

% save meanssh_oco_realtime_2016 sshmean sshvar lat lon gmo sshcyc sshm* tgrid 


%compute the mean ssh over the time period used in the 
tmin=datenum(min_year_mean,1,1)-datenum(1950,1,1);
tmax=datenum(max_year_mean,12,31)-datenum(1950,1,1);
%jj=find(dy>=tmin);% only load delyed mode data that it is older that 2 years (so that diferences)
%	can be made


s=sdir('./matlab_files/ssh*.mat');
sday=strjust(strvcat(s(:).name),'right');
dy=str2num(sday(:,end-8:end-4));
tgrid=(dy+datenum(1950,1,1))/365.2425;
jj=find(dy>=tmin&dy<=tmax);

s2=zeros(1440,720);s=s2;n=s;
cyc=zeros(1440,720,4);ncyc=cyc;

sind=fix(mod(dy+datenum(1950,1,1)-datenum(1992,1,1),365.25)/365.25*4)+1;

for j=1:length(jj)
    i=jj(j);
    
    if exist(['./matlab_files/ssh',num2str(dy(i)),'.mat'],'file')
      
      load(['./matlab_files/ssh',num2str(dy(i))],'sshanom','lat','lon');


      ['matlab_files/ssh',num2str(dy(i))]


      gd=sshanom;

      n=n+~isnan(gd);

      gd(isnan(gd))=0;

      % tabulate vars. for mean and annual cycle

      s=s+gd;




      ncyc(:,:,sind(i))=ncyc(:,:,sind(i))+~isnan(gd);


      % tabulate vars. for mean and annual cycle

      cyc(:,:,sind(i))=cyc(:,:,sind(i))+gd;
      clear gd
    end
end

sshmean=s./n;

ll=find(ncyc==0);ncyc(ll)=NaN;
sshcyc=cyc./ncyc; sshcyc=sshcyc-repmat(sshmean,[1 1 size(sshcyc,3)]);
gmo=[-1.5:3:13.5];poo=zeros([size(sshmean),length(gmo)]);
poo(:,:,1)=sshcyc(:,:,end);poo(:,:,end)=sshcyc(:,:,1);
poo(:,:,2:end-1)=sshcyc;sshcyc=poo;clear poo


% save meanssh_oco_realtime_2016 sshmean sshvar lat lon gmo sshcyc sshm* tgrid 

eval(['save meanssh_oco_realtime_',file_name,' sshmean sshvar lat lon gmo sshcyc sshm* tgrid '])

