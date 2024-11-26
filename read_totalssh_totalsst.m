function [ssh_total,sst_total,time_aviso,nfiles]=read_totalssh_totalsst(s,syr,aviso_day,path_oisst,nlon_tpx,nlat_tpx,min_tpx_year,max_tpx_year) 

tgrid=min_tpx_year+.5:max_tpx_year+.5;
nyears=length(tgrid);
good_tpx_files=find(-.5+tgrid(1)<=(syr) & (syr)<.5+tgrid(end));
syr=syr(good_tpx_files);
s=s(good_tpx_files);
aviso_day=aviso_day(good_tpx_files);
nfiles=length(syr);

ssh_total=nans(nlon_tpx,nlat_tpx,nfiles);
sst_total=ssh_total;
time_aviso=nans(1,nfiles);

for iyear=1:nyears 
    
    yr_name=num2str(floor(tgrid(iyear)));
    sst_anom_year=double(ncread([path_oisst,'sst.day.mean.',yr_name,'.nc'],'sst'));
    sst_anom_year(sst_anom_year<= -9.9692e+36)=nan;
    sst_time=double(ncread([path_oisst,'sst.day.mean.',yr_name,'.nc'],'time'));
    sst_time=sst_time-min(sst_time)+1;
    max_sst_time=max(sst_time);
%             sshave=zeros(length(lon_tpx),length(lat_tpx));
    
    ii=find(-.5<=(syr-tgrid(iyear)) & (syr-tgrid(iyear))<.5);
    for j=1:length(ii)
        ifile=ii(j);
        load([s(ifile).folder,'\',s(ifile).name])
        junk_day=aviso_day(ii(j));

        if ~exist('offset_adt','var') 
            % only take delayed mode ssh for the means fine for the anomly
            ssh_total(:,:,ifile)=adt;
            if junk_day<=max_sst_time
                sst_total(:,:,ifile)=sst_anom_year(:,:,junk_day);
            end
            time_aviso(ifile)=syr(ifile);
        end
        clear offsset_adt
    end
end
           
end        
            
        
        