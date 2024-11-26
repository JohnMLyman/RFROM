function [dohc,depth,dz,lon,lat,dt]=read_profiles_ME4OH_extra(file)
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

dohc_mask_by_en4_maxdepth=ncread(file,'dohc_mask_by_en4_maxdepth')';
% en4_maxdepth=ncread(file,'en4_maxdepth');
L1=depth<=290;
L2=depth<=700 & depth>290;
L3=depth>700;


ohc=temp.*cp0.*rho0./tera;

dohc  = ((ohc) .* dz); % Km(kg/m^3)(J/kg C)/10^12 = TJ/m^2
dohc(~dohc_mask_by_en4_maxdepth(:,1),L1)=nan;
dohc(~dohc_mask_by_en4_maxdepth(:,2),L2)=nan;
dohc(~dohc_mask_by_en4_maxdepth(:,3),L3)=nan;

end

