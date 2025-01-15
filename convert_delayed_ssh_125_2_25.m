function convert_delayed_ssh_125_2_25(OcoSetUp)


path_out=[OcoSetUp.file_path_in,'Mtpers\delayed_oco\'];
path_in=OcoSetUp.path_in_125_ssh;



files=dir([path_in,'dt*.nc']);
nfiles=length(files);
tic
parfor ifile=1:nfiles
     file_name=files(ifile).name;
     convert_ssh_125_2_25(file_name,path_in,path_out)
end
toc./60