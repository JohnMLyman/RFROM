function [dohc,depth,dz,lon,lat,dt]=read_profiles_ME4OH(file)
% L1: 0-286.6 m layer
% L2: 286.6-685.9 m layer 
% L3: 685.9-1985.3 m layer

cp0 = 3989.244 ;%J/kg/K is heat capacity
rho0= 1030 ;%kg/m3
T0	= 273.15;% Celcius -> Kelvin
tera  = 10^12;


depth=ncread(file,'ts_z')';
dz=ncread(file,'ts_dz')';

lon=ncread(file,'ts_lon');
lat=ncread(file,'ts_lat')';
dt=ncread(file,'en4_ymd')';
temp=ncread(file,'temp')';


ohc=temp.*cp0.*rho0./tera;

dohc  = ((ohc) .* dz); % Km(kg/m^3)(J/kg C)/10^12 = TJ/m^2



end

