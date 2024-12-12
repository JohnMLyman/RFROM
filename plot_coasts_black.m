function plot_coasts_black

% load  'C:\Users\jlyma\Documents\OHCA_2020\topo.mat'
load 'C:\Users\jlyma\OneDrive\Documents\OHCA_2020\topo.mat'
hold on
pos_lon=[1:5:length(lon)];
pos_lat=[1:5:length(lat)];
contour(lon(pos_lon),lat(pos_lat),topo(pos_lon,pos_lat)',[0 0],'k')
contour(lon(pos_lon)+360,lat(pos_lat),topo(pos_lon,pos_lat)',[0 0],'k')
 
hold off
