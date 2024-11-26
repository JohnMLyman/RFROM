load('C:\Users\jlyma\OneDrive - University of Hawaii\data\topo_tpx_new.mat')

load('C:\Users\jlyma\OneDrive - University of Hawaii\data\GOSML\max_max_de.mat')
lon_g=x(1,1:end);
lat_g=y(1:end,1)';
max_de=max_max_de;
x2=[x(:,lon_g>350)-360 x]';
y2=[y(:,lon_g>350)-360 y]';
max_de=[max_de(:,lon_g>350) max_de]';
lon_g=x2(1:end,1);
% clearvars x y x2
good=isfinite(max_de);
maxd=griddata( x2(good),y2(good),max_de(good), x2, y2 ) ;
max_de2=interp2(lat_g',lon_g,maxd,lat_topo',lon_topo);

% some ice covered regions are missing set to 80
max_de2(~isfinite(max_de2))=80;
v=cat(3,max_de2,-1.*topo_tpx_new);
topo_tpx_new_max=-1.*min(v,[],3);
save('C:\Users\jlyma\OneDrive - University of Hawaii\data\topo_tpx_new_max.mat',...
    'topo_tpx_new_max','lat_topo','lon_topo')
