function [pres,lat,lon_out,sal,Asal]=make_read_gk_absal


% test read a netcdf file using new matlab rotines...

path='/Volumes/Data/GK_clim/';
file='wghc_params.nc';

ncid=netcdf.open([path, file],'NC_NOWRITE');
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);


% % read dimensions
% 
% for idims=0:ndims-1
%     
%     [dimname, dimlen] = netcdf.inqDim(ncid,idims);
% end
% 
% % read vars
% 
% for ivars=0:nvars-1
% 
% 
%     [varname, xtype, dimids, numatts] = netcdf.inqVar(ncid,ivars)
%     
%     eval([varname,'= netcdf.getVar(ncid,ivars);']);
%     
% end


% load in SALINITY Depth lat and lon
    [ivar] = netcdf.inqVarID(ncid,'ZAX');
    pres= netcdf.getVar(ncid,ivar)';
    
    [ivar] = netcdf.inqVarID(ncid,'LAT');
    lat= netcdf.getVar(ncid,ivar)';
    
    [ivar] = netcdf.inqVarID(ncid,'LON');
    lon= netcdf.getVar(ncid,ivar)';
    
    [ivar] = netcdf.inqVarID(ncid,'SALINITY');
    sal= double(netcdf.getVar(ncid,ivar));
    sal(sal ==-9)=NaN;
    lon_out=lon;
    lon(lon>180)=lon(lon>180)-360;
    
netcdf.close(ncid)
s=size(sal);
salo=sal(:);

preso=reshape(pres,1,1,s(3));
preso=repmat(preso,s(1),s(2));
preso=preso(:);

lato=reshape(lat,1,1,s(2));
lato=repmat(lato,s(1),s(3));
lato=permute(lato,[1 3 2]);
lato=lato(:);

lono=reshape(lon,1,1,s(1));
lono=repmat(lono,s(2),s(3));
lono=permute(lono,[3 1 2]);
lono=lono(:);


%Asal  = gsw_deltaSA_from_SP(salo,preso,lono,lato);
  Asal  = gsw_SA_from_SP(salo,preso,lono,lato);
     
Asal=reshape(Asal,s(1),s(2),s(3));


save /Volumes/Data/GK_clim/GK_abs_sal Asal sal pres lon lat
