function [map_out]=nanmedflit2_globe(map,nfilt)


% this function assumes the form map(nlon,nlat) and that nflit is odd

Ns=nfilt-1;



bad=~isfinite(map);

map_out=nanmedfilt2(map,nfilt);

% this section computes median filter at bounderies, takes advatage of the
% fact the longitude wraps

map_bound=circshift(map,Ns,1);

map_bound=map_bound(1:Ns*2,:);
map_bound=nanmedfilt2(map_bound,nfilt);

map_out(1:Ns/2,:)=map_bound(1+Ns:Ns+Ns/2,:);
map_out(end-Ns/2+1:end,:)=map_bound(Ns/2+1:Ns/2+Ns/2,:);


map_out(bad)=nan;


end