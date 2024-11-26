function [m,b]=find_line(lon1,lat1,lon2,lat2)

b=(lat2*lon1-lat1*lon2)./(lon1-lon2);
m=(lat2-b)./lon2;
