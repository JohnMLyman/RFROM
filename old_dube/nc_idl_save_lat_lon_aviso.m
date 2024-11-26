function nc_idl_save_lat_lon_aviso

% ncexample.m -- "NetCDF Toolbox for Matlab-5" example.
%  ncexample (no argument) is a short example that lists
%   itself, builds a simple NetCDF file, then displays
%   its variables.
 
% Copyright (C) 1997 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 12-Jun-1997 16:23:04.
'hi'

type(mfilename)

help(mfilename)
 
% ---------------------------- DEFINE THE FILE --------------------------- %

ncquiet                                              % No NetCDF warnings.

nc = netcdf('aviso_grid.nc', 'clobber');              % Create NetCDF file.

nc.description = 'Aviso lat and lon';                   % Global attributes.
nc.author = 'Dr. John M Lyman';
nc.date = 'September 5, 2006';
%load /home/shoko2/wills/globalhc_dirs/Globalhc/SAL/Floats/total_den_grid_april_19.mat
load ../../Mtpers/meanssh lat lon
lon=[lon(542:end)-360;lon(1:541)];
% Define dimensions.

[n_lat]=size(lat);
[n_lon]=size(lon);


nc('n1')=n_lon;
nc('n2')=n_lat;

  % Define variables.



nc{'lat'}={'n2'};
nc{'lon'}={'n1'};


%nc{'latitude'}.units = 'degrees';                    % Attributes.%
%nc{'longitude'}.units = 'degrees';
%nc{'depth'}.units = 'meters';


                                                    % Put all the data.

nc{'lat'}(:) = lat;
nc{'lon'}(:) = lon;

nc = close(nc);                                      % Close the file.

