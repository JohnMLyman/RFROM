function [sal_out]=loess3d_JML_smooth_sal(t,sal,xspni,yspni,zspni)
%
% function [zi]=loess3d(x,y,t,z,xi,yi,ti,xspn,yspn,tspn)
%
% A 3-D "loess" smoother gives a weighted quadratic fit 
% of z versus x, y, and t where sal is the variable to be 
% smoothed, x(lon), y(lat), and t(temperature) are the spatiotemporal coordinates,
% and xspni, yspni, and zspani are the respective halfspans of 
% the loess smoother, in number of grid spaces and must be integers.
%
% loops through the grid point by point
% 
% G. C. Johnson 7/6/00
% J. M. Lyman 8/29/23

%getrid of missing points and format the output in the same format as the
%input
tic
good=isfinite(t+sal);
s_sal=size(sal);
sal_out=nan(s_sal);

% v=repmat(reshape(1:sz(3),[1 1 sz(3)]),[sz(1) sz(2) 1]);
% vi=v;
% 
% z=z(good);
% x=x(good);
% y=y(good);
% t=t(good);
% v=v(good);
% 
% xi=xi(good);
% yi=yi(good);
% ti=ti(good);
% vi=vi(good);


% make sure x, z, and xi are vectors.
% 
% x=x(:);
% y=y(:);
% t=t(:);
% z=z(:);
% v=v(:);

% get various dimensions
% 
% m=size(xi);
% n=length(z);
% ni=length(xi);

% initialize zi
% 
% zi=NaN*xi;
% 
% % make grids into vectors for looping purposes

% xi=xi(:);
% yi=yi(:);
% ti=ti(:);
% vi=vi(:);

% loop through the mapping grid to conserve memory

lat_index=-yspni:yspni;
lon_index=-xspni:xspni;


for ilon=1:s_sal(1)
    pos_lon=ilon-xspni:ilon+xspni;
    pos_lon(pos_lon<1)=pos_lon(pos_lon<1)+s_sal(1);
    pos_lon(pos_lon>s_sal(1))=pos_lon(pos_lon>s_sal(1))-s_sal(1);
    nlon=length(pos_lon);
%    if mod(ilon,100)==0
%       disp(ilon)
%       disp(toc./60./60)
%    end
    

    
    for ilat=1:s_sal(2)

        pos_lat=ilat-yspni:ilat+yspni;
        pos_lat=pos_lat(pos_lat>=1 & pos_lat<=s_sal(1));
        nlat=length(pos_lat);
        if ilat<yspni
            lat_index_sub=lat_index(yspni-ilat+1:end);
        elseif ilat>=s_sal(2)-yspni
            lat_index_sub=lat_index(1:s_sal(2)-ilat+yspni+1);
        else
            lat_index_sub=lat_index;
        end

        for idepth=1:s_sal(3)
            for itime=1:s_sal(4)
                if good(ilon,ilat,idepth,itime)
                    pos_depth=idepth-zspni:idepth+zspni;
                    pos_depth=pos_depth((pos_depth>=1) & (pos_depth<=s_sal(3)));
                   
                    ndepth=length(pos_depth);
    
         
                    
                    xxi=0;
                    yyi=0;
                    tti=double(t(ilon,ilat,idepth,itime));
                  
                    % compute the weights wgt where they are non-zero.
                    
                    t_sub=double(t(pos_lon,pos_lat,pos_depth,itime));
                    sal_sub=double(sal(pos_lon,pos_lat,pos_depth,itime));
                    x_sub=repmat(reshape(lon_index,[nlon 1 1]),[1 nlat ndepth]);
                    y_sub=repmat(reshape(lat_index_sub,[1 nlat 1]),[nlon 1 ndepth]);
    
                    x_sub=x_sub(:);
                    y_sub=y_sub(:);
                    t_sub=t_sub(:);
                    sal_sub=sal_sub(:);
    
                    good_sub=isfinite(sal_sub)&isfinite(t_sub);
    
                    x_sub=x_sub(good_sub);
                    y_sub=y_sub(good_sub);
                    t_sub=t_sub(good_sub);
                    sal_sub=sal_sub(good_sub);
    
    
                    
                    tspn=max(abs(t_sub-tti));
                    
    
    
                    
                    q=sqrt(((x_sub-xxi)/xspni).^2+((y_sub-yyi)/yspni).^2+((t_sub-tti)/tspn).^2);
                    
                    jj=find(q<1);
                    
                    
    
                    wgt=diag((1-q(jj).^3).^3);
                    x_sub=x_sub(jj);
                    y_sub=y_sub(jj);
                    t_sub=t_sub(jj);
                    sal_sub=sal_sub(jj);
                    
                    % make the quadratic model function where weights are 
                    % non-zero
                    
    %                 M=[ones(length(jj),1) x_sub x_sub.^2 y_sub ...
    %                     y_sub.^2 x_sub.*y_sub ...
    %                     t_sub t_sub.^2 x_sub.*t_sub y_sub.*t_sub];
%                     M=[ones(length(jj),1) x_sub x_sub.^2 y_sub ...
%                         y_sub.^2 x_sub.*y_sub ...
%                         t_sub x_sub.*t_sub y_sub.*t_sub];

                     M=[ones(length(jj),1) x_sub y_sub ...
                    t_sub ];
                    
                    % minimize to get the model coefficients
                    
                    % map=(wgt*M)\(wgt*z(jj));
                    map=pinv(wgt*M)*(wgt*sal_sub);
                    
                    % evaluate them at the point
                    
                    if ~isempty(M)
    %                     sal_out(ilon,ilat,idepth)=map(1)+map(2)*xxi+map(3)*xxi^2+map(4)*yyi+map(5)*yyi^2+map(6)*xxi*yyi+map(7)*tti+map(8)*tti^2+map(9)*xxi*tti+map(10)*yyi*tti;
%                         sal_out(ilon,ilat,idepth,itime)=map(1)+map(2)*xxi+map(3)*xxi^2+map(4)*yyi+map(5)*yyi^2+map(6)*xxi*yyi+map(7)*tti+map(8)*xxi*tti+map(9)*yyi*tti;
                         sal_out(ilon,ilat,idepth,itime)=map(1)+map(2)*xxi+map(3)*yyi+map(4)*tti;
                    end % if
                end
            end %time
            
        end % depth
    end % lat
end % lon

% 
% %put back on original grid
% 
% zout(~good)=zi;

toc./60./60
