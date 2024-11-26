wod_path='/Volumes/ThunderBay/Data/WOD2016/CTD/'
wod_path='/Users/lyman/Downloads/'

wod_index_file1='ocldb1478292529.28884.CTD/ocldb1478292529.28884.CTD.nc'
wod_index_file2='ocldb1478292529.28884.OSD/ocldb1478292529.28884.OSD.nc'
wod_index_file3='ocldb1478292529.28884.OSD2/ocldb1478292529.28884.OSD2.nc'
wod_index_file4='ocldb1478292529.28884.OSD3/ocldb1478292529.28884.OSD3.nc'
wod_index_file5='ocldb1478292529.28884.OSD4/ocldb1478292529.28884.OSD4.nc'

old_path=cd(wod_path);


[lat,lon,time,cast,file_number]=read_wod_info5(wod_index_file1,wod_index_file2,wod_index_file3,wod_index_file4,wod_index_file5);


% load Volumes/ThunderBay/Data/topo.mat lat lon topo


nWOD=length(cast);
missing_name=cell(nWOD,1);
ibad=0;
%press=cell(nWOD,1);
tic
1098813
for k=1098814:nWOD


good_casti=cast(k);
good_file_number=file_number(k);

% if (good_casti>= 15728000 && good_casti<=15729200) || (good_casti>= 15160000 && good_casti<=15169999)
% 
%     ptempj=nan;
%     salj=nan;
%     pressj=nan;
% else
    switch 1
        case good_casti < 1000000

            good_name=['wod_000',num2str(good_casti),'O.nc'];
        case good_casti >= 1000000 &  good_casti <   10000000
            good_name=['wod_00',num2str(good_casti),'O.nc'];
        case good_casti >= 10000000 &  good_casti <  100000000
            good_name=['wod_0',num2str(good_casti),'O.nc'];
        case good_casti >= 100000000 &  good_casti < 1000000000
            good_name=['wod_',num2str(good_casti),'O.nc'];
    end
    
    switch 1
        case good_file_number==1
            good_name=['ocldb1478292529.28884.CTD/',good_name];
        case good_file_number==2
            good_name=['ocldb1478292529.28884.OSD/',good_name];
        case good_file_number==3
            good_name=['ocldb1478292529.28884.OSD2/',good_name];
        case good_file_number==4
            good_name=['ocldb1478292529.28884.OSD3/',good_name];
        case good_file_number==5
            good_name=['ocldb1478292529.28884.OSD4/',good_name];
    end
           
            if(mod(k,10000)==0),disp([num2str([k nWOD k/nWOD toc]),'  ',good_name]),end
 if exist([wod_path,good_name],'file')~=0
    [~,pressj]=load_wod2016_profile_no_sal(good_name,wod_path);
% end

press{k}=pressj;
 else
     ibad=ibad+1;
     missing_name{ibad}=good_name;
 end
end


save '/Volumes/ThunderBay/Data/WODnetcdf_ctd_nov_2016/WOD_pressure_2016_test.mat' press lon lat time missing_name ibad