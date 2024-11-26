function nc_idl

%Matlab-5" example.
%  ncexample (no argument) is a short example that lists
%   itself, builds a simple NetCDF file, then displays
%   its variables.
 
% Copyright (C) 1997 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 12-Jun-1997 16:23:04.

type(mfilename)

help(mfilename)
 
% ---------------------------- DEFINE THE FILE --------------------------- %
%load /home/shoko2/wills/globalhc_dirs/Globalhc/SAL/Floats/total_den_grid_april_19.mat
load junk
%press_gam=[1:16]
ncquiet                                              % No NetCDF warnings.

nc = netcdf('total_den4_grid.nc', 'clobber');              % Create NetCDF file.

nc.description = 'NetCDF Argo data';                   % Global attributes.
nc.author = 'Dr. John M. Lyman';
nc.date = 'April 21, 2006';

press_gam=rand(10,10)

nc('n1')=10;
%nc('n2')=10;
 nc('press_gam') = {'n1','n2'};                                 % Define dimensions.

 nc{'press_gam'}.units = 'dbar';

% ---------------------------- STORE THE DATA ---------------------------- %

%           % Matlab data.
 %longitude = [0 20 40 60 80 100 120 140 160 180];
% depth = rand(length(latitude), length(longitude));

nc{'press_gam'}(:) = press_gam;                        % Put all the data.

%nc{'longitude'}(:) = longitude;
nc = close(nc);                                      % Close the file.

% % ---------------------------- RECALL THE DATA --------------------------- %
% 
% nc = netcdf('ncexample.nc', 'nowrite');              % Open NetCDF file.
% description = nc.description(:)                      % Global attribute.
% variables = var(nc);                                 % Get variable data.
% for i = 1:length(variables)
%    disp([name(variables{i}) ' =']), disp(' ')
%    disp(variables{i}(:))
% end
% nc = close(nc);                                      % Close the file.

% --------------------------------- DONE --------------------------------- %
	