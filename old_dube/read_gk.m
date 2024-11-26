function [pres,lat,lon,sal]=read_gk


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

netcdf.close(ncid)