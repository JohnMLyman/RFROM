function []=write_netcdf_ssh(longitude,latitude,time,sla,adt,file_name)

nlon=length(longitude);
nlat=length(latitude);
time=double(time);


globalat(1).Name='title';
globalat(1).Value='.125 deg to .25 deg SSH orginal file on https://data.marine.copernicus.eu/';
globalat(2).Name='method';
globalat(2).Value='simple mean';


mySchema.Name   = '/';
mySchema.Attributes=globalat;
mySchema.Dimensions(1).Name   = 'longitude';
mySchema.Dimensions(1).Length = nlon;
mySchema.Dimensions(2).Name   = 'latitude';
mySchema.Dimensions(2).Length = nlat;
mySchema.Dimensions(3).Name   = 'time';
mySchema.Dimensions(3).Length = 1;

map_dimen(1).Name='longitude';
map_dimen(2).Name='latitude';

map_dimen(1).Length=nlon;
map_dimen(2).Length=nlat;

time_dim.Name='time';
time_dim.Length=1;

% Longitude
lon_att(1).Name='units';
lon_att(1).Value='degrees_east';
lon_att(2).Name='Description';
lon_att(2).Value='Longitude (positive east)';

mySchema.Variables(1).Name='longitude';
mySchema.Variables(1).Dimensions=map_dimen(1);
mySchema.Variables(1).Attributes=lon_att;
mySchema.Variables(1).Datatype='double';
mySchema.Variables(1).FillValue='disable';

% Latitude
lat_att(1).Name='units';
lat_att(1).Value='degrees_north';
lat_att(2).Name='Description';
lat_att(2).Value='Latitude (positive north)';

mySchema.Variables(2).Name='latitude';
mySchema.Variables(2).Dimensions=map_dimen(2);
mySchema.Variables(2).Attributes=lat_att;
mySchema.Variables(2).Datatype='double';
mySchema.Variables(2).FillValue='disable';

 % time
time_att(1).Name='units';
time_att(1).Value='days since 1950-1-1 0:0:0';
time_att(2).Name='Description';
time_att(2).Value='Time in days since January 1st 1950';

mySchema.Variables(3).Name='time';
mySchema.Variables(3).Dimensions=time_dim;
mySchema.Variables(3).Attributes=time_att;
mySchema.Variables(3).Datatype='double';
mySchema.Variables(3).FillValue='disable';
    

% sla
ohca_att(1).Name='units';
ohca_att(1).Value='m';


mySchema.Variables(4).Name='sla';
mySchema.Variables(4).Dimensions=map_dimen;
mySchema.Variables(4).Attributes=ohca_att;
mySchema.Variables(4).Datatype='double';
mySchema.Variables(4).FillValue='disable';

% adt
ohca_att(1).Name='units';
ohca_att(1).Value='m';


mySchema.Variables(5).Name='adt';
mySchema.Variables(5).Dimensions=map_dimen;
mySchema.Variables(5).Attributes=ohca_att;
mySchema.Variables(5).Datatype='double';
mySchema.Variables(5).FillValue='disable';

 % write the file format
 ncwriteschema(file_name, mySchema);




 ncwrite(file_name,'latitude',latitude,[1]);
 ncwrite(file_name,'longitude',longitude,[1]);
ncwrite(file_name,'time',time,[1]);
 ncwrite(file_name,'sla',sla,[1,1]); 
 ncwrite(file_name,'adt',adt,[1,1]); 
