function [lon_out,lat_out,time,sla,adt]=read_ssh_nc_125deg(file_name)

    lat=ncread(file_name,'latitude');
    lon=ncread(file_name,'longitude');
    time=ncread(file_name,'time');
    sla=ncread(file_name,'sla');
    adt=ncread(file_name,'adt');

    nlon=length(lon);
    nlat=length(lat);
    
    nscale=2;
    nlat_new=nlat./nscale;
    nlon_new=nlon./nscale;
    n_Ln=ones(nscale,nlon_new,nscale,nlat_new);


    sla= reshape(sla,nscale,nlon_new,nscale,nlat_new);
    n_var=n_Ln;
    n_var(~isfinite(sla))=0;
    sla=sum(sum(sla,1,'omitnan'),3,'omitnan');
    n_var=sum(sum(n_var,1,'omitnan'),3,'omitnan');
    sla=reshape(sla./n_var,nlon_new,nlat_new);

    adt= reshape(adt,nscale,nlon_new,nscale,nlat_new);
    n_var=n_Ln;
    n_var(~isfinite(adt))=0;
    adt=sum(sum(adt,1,'omitnan'),3,'omitnan');
    n_var=sum(sum(n_var,1,'omitnan'),3,'omitnan');
    adt=reshape(adt./n_var,nlon_new,nlat_new);

    lon_out=reshape(lon,nscale,nlon_new);
    lon_out=sum(lon_out,1,'omitnan')./2;

    lat_out=reshape(lat,nscale,nlat_new);
    lat_out=sum(lat_out,1,'omitnan')./2;








end
