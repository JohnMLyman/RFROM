source_dir='H:\erddap_filt_anomt\sal_vertnetcdf_loess_stable\tree_sal_vert_nosshsst_newcycle\yearly_withcycle';

all_files=dir([source_dir,'/*.nc']);

nfiles=length(all_files);

for ifile=1:nfiles
    
    file=[all_files(ifile).folder,'/',all_files(ifile).name];
    ncwriteatt(file,"/","title","RFROM V2.0")
    ncwriteatt(file,"/","history",'11/01/2023 v2.0')
end