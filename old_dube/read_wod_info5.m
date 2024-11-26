function [lat,lon,time,cast,file_number]=read_wod_info5(wod_index_file1,wod_index_file2,...
    wod_index_file3,wod_index_file4,wod_index_file5)


% %   path_argo_files='/Volumes/pc/mirror/';
% %      argo_index_file='/Volumes/JOHN_USB/ARGO2015/ar_index_global_prof_fast_OSX.mat';
% %      path_wod_files ='/Users/johnlyman/Desktop/wod_all_ctd/';
% %      wod_index_file1 ='/Users/johnlyman/Desktop/wod_all_ctd/ocldb1463707684.27905.CTD.nc';
% %      
% %      % if there is only one wod_index_file set wod_index_file2=[];
% %      wod_index_file2 ='/Users/johnlyman/Desktop/wod_all_ctd/ocldb1464001245.7104.CTD.nc';
     


    cast1=ncread(wod_index_file1,'cast');
    cast2=ncread(wod_index_file2,'cast');
    cast3=ncread(wod_index_file3,'cast');
    cast4=ncread(wod_index_file4,'cast');
    cast5=ncread(wod_index_file5,'cast');
    
    cast=[cast1 ; cast2;cast3;cast4;cast5];
    file_number=[ones(length(cast1),1);ones(length(cast2),1)*2;ones(length(cast3),1)*3 ...
        ;ones(length(cast4),1)*4;ones(length(cast5),1)*5];
    time1=ncread(wod_index_file1,'time');
    time2=ncread(wod_index_file2,'time');
    time3=ncread(wod_index_file3,'time');
    time4=ncread(wod_index_file4,'time');
    time5=ncread(wod_index_file5,'time');
    
    time=[time1 ; time2;time3;time4;time5];


    lat1=ncread(wod_index_file1,'lat');
    lat2=ncread(wod_index_file2,'lat');
    lat3=ncread(wod_index_file3,'lat');
    lat4=ncread(wod_index_file4,'lat');
    lat5=ncread(wod_index_file5,'lat');
    
    lat=[lat1 ; lat2; lat3;lat4;lat5];

    lon1=ncread(wod_index_file1,'lon');
    lon2=ncread(wod_index_file2,'lon');
    lon3=ncread(wod_index_file3,'lon');
    lon4=ncread(wod_index_file4,'lon');
    lon5=ncread(wod_index_file5,'lon');
    
    lon=[lon1 ; lon2;lon3;lon4;lon5];

    base=datenum(1770,1,1,0,0,0);

time=time+base;
dt_wod=datevec(time);

dyear=decyear(dt_wod(:,1),dt_wod(:,2),dt_wod(:,3));
dyear(dyear<1770)=NaN;
time=dyear;
%% read in max depth
% % % 
% % % max_depth=nan(1,length(cast));
% % % for i=1:length(cast)
% % %     
% % %     good_casti=cast(i);
% % % switch 1
% % %         case good_casti < 1000000
% % % 
% % %             good_name=['wod_000',num2str(good_casti),'O.nc'];
% % %         case good_casti >= 1000000 &  good_casti <   10000000
% % %             good_name=['wod_00',num2str(good_casti),'O.nc'];
% % %         case good_casti >= 10000000 &  good_casti <  100000000
% % %             good_name=['wod_0',num2str(good_casti),'O.nc'];
% % %         case good_casti >= 100000000 &  good_casti < 1000000000
% % %             good_name=['wod_',num2str(good_casti),'O.nc'];
% % % end
% % % 
% % %  Depth=ncread([path_wod_files, good_name],'z');
% % % max_depth(i)=max(Depth);   
% % % end


clear dyear clear dt_wod



 