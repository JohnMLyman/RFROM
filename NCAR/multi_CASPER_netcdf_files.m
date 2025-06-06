




min_model_year=158;
max_model_year=183;


file_path_POP='/glade/campaign/cgd/oce/projects/FOSI/HR/g.e20.G.TL319_t13.control.001/ocn/hist/';
path_out='/glade/derecho/scratch/jlyman/';

sdir=dir([file_path_POP,'g.e20.G.TL319_t13.control.001.pop.h*nc']);


nfiles=length(sdir);
good_files=zeros(nfiles,1,'logical');

for ifile=1:nfiles
    file_name=sdir(ifile).name;
    year_file=str2num(file_name(37:3+37));
    if year_file>=min_model_year && year_file<=max_model_year
        good_files(ifile)=1;
    end


end
sdir=sdir(good_files);
nfiles=length(sdir);




for ifiles=1:nfiles

%    file_name='g.e20.G.TL319_t13.control.001.pop.h.0183-12-31.nc';
   file_name=sdir(ifiles).name
   
   CASPER_netcdf_files(file_name,file_path_POP,path_out)


  
end


