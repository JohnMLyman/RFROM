function nc_idl_save_hdata_argo_oco(filename)
% for some reason I can only get the 64-bit version of the mex file to work
% using these methods.

%load /home/shoko2/wills/globalhc_dirs/Globalhc/SAL/Floats/total_den_grid_april_19.mat
eval(['load '  filename]);
nc_file=[filename,'.nc']

nc_create_empty(nc_file)
% Define dimensions.

[n_prof_out,n_coords]=size(coords);


nc_add_dimension(nc_file,'n3',n_coords);

nc_add_dimension(nc_file,'nnn',0);
  % Define variables.

  
coords_out=coords;
tpx_out=tpx;
yr_out=yr;

ht_300_out=ht_300';
ht_700_out=ht_700';
ht_900_out=ht_900';
ht_1800_out=ht_1800';

htdiff_300_out=htdiff_300';
htdiff_700_out=htdiff_700';
htdiff_900_out=htdiff_900';
htdiff_1800_out=htdiff_1800';
  
clear coords tpx ht_300 ht_700 ht_900 ht_1800 yr htdiff_1800 htdiff_900 htdiff_700 htdiff_300 var_coords var_nprof var_tpx var_yr var_htdiff var_htanom nnn
  
var_nprof.Name='nnn';
var_nprof.Dimension={'nnn'};
nc_addvar(nc_file, var_nprof)

var_coords.Name='coords';
var_coords.Dimension={'nnn','n3'};
%var_coords.Nctype=nc_float;

var_ht_300.Name='ht_300';
var_ht_300.Dimension={'nnn'};

var_ht_700.Name='ht_700';
var_ht_700.Dimension={'nnn'};
  
var_ht_900.Name='ht_900';
var_ht_900.Dimension={'nnn'};
%var_htanom.Nctype=nc_float;

var_ht_1800.Name='ht_1800';
var_ht_1800.Dimension={'nnn'};
%var_htanom.Nctype=nc_float;
  
var_tpx.Name='tpx';
var_tpx.Dimension={'nnn'};
%var_tpx.Nctype=nc_float;

var_yr.Name='yr';
var_yr.Dimension={'nnn'};
%var_yr.Nctype=nc_float;

var_htdiff_300.Name='htdiff_300';
var_htdiff_300.Dimension={'nnn'};


var_htdiff_700.Name='htdiff_700';
var_htdiff_700.Dimension={'nnn'};

var_htdiff_900.Name='htdiff_900';
var_htdiff_900.Dimension={'nnn'};
%var_htdiff.Nctype=nc_float;

var_htdiff_1800.Name='htdiff_1800';
var_htdiff_1800.Dimension={'nnn'};
%var_htdiff.Nctype=nc_float;


%nc{'latitude'}.units = 'degrees';                    % Attributes.%
%nc{'longitude'}.units = 'degrees';
%nc{'depth'}.units = 'meters';


                                                    % Put all the data.
nc_addvar(nc_file, var_coords)
nc_addvar(nc_file, var_ht_300)
nc_addvar(nc_file, var_ht_700)
nc_addvar(nc_file, var_ht_900)
nc_addvar(nc_file, var_ht_1800)
nc_addvar(nc_file, var_tpx)
nc_addvar(nc_file, var_yr)
nc_addvar(nc_file, var_htdiff_300)
nc_addvar(nc_file, var_htdiff_700)
nc_addvar(nc_file, var_htdiff_900)
nc_addvar(nc_file, var_htdiff_1800)

% add data

clear vardata

vardata.nnn=[1:n_prof_out]';
vardata.coords=coords_out;
vardata.ht_300=ht_300_out';
vardata.ht_700=ht_700_out';
vardata.ht_1800=ht_1800_out';
vardata.ht_900=ht_900_out';
vardata.tpx=tpx_out;
vardata.yr=yr_out;
vardata.htdiff_1800=htdiff_1800_out';
vardata.htdiff_900=htdiff_900_out';
vardata.htdiff_700=htdiff_700_out';
vardata.htdiff_300=htdiff_300_out';


nc_addnewrecs(nc_file,vardata,'nnn');

nc_dump(nc_file)

