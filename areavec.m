% AREAVEC - creates area matrix
%
%      AREAVEC calculates a matrix of gridpoint areas in meters^2, 
%      given latitude and longitude grid vectors.
%
%      Usage:  
%
%               [arw,dx,dy]=areavec(lon,lat);
%      
%               arw   -   length(lon) x length(lat) matrix of
%                         areas in square meters 
%               dx    -   length(lon) x length(lat) matrix of
%                         distances in meters between longitude
%                         grid points
%               dy    -   length(lon) x length(lat) matrix of
%                         distances in meters between latitude
%                         grid points
%
%       Latitude and longitude vectors MUST be give in degrees.

%  created 08/30/04 by Josh Willis

function [arw,dx,dy]=areavec(lon,lat);

% handle incorrect number of inputs
if nargin~=2
  disp('Usage:  [arw,dx,dy]=areavec(lon,lat);'); return;
end

% make grid matricies:
[gy,gx]=meshgrid(lat,lon);

% make distance matricies
dy=gradient(lat);dx=gradient(lon);
if max(dy(:))<0,dy=-dy;end
if max(dx(:))<0,dx=-dx;end
[dy,dx]=meshgrid(dy,dx);
dx=111e3.*dx.*cos(pi/180*gy);
dy=111e3.*dy;

% make area matrix
arw=dx.*dy;

% fix top and bottom circles if lat stretches to + or - 90
if max(lat)==90;
  lt=sort(lat);dtheta=(lat(end)-lat(end-1))/2;
  r=360*111e3/2/pi;
  ar=2*pi*r^2*(1-cos(dtheta*pi/180));
  arw(:,lat==90)=ar/length(lon);
end

if min(lat)==-90;
  lt=sort(lat);dtheta=(lat(2)-lat(1))/2;
  r=360*111e3/2/pi;
  ar=2*pi*r^2*(1-cos(dtheta*pi/180));
  arw(:,lat==-90)=ar/length(lon);
end


