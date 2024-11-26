function []=make_seasonal_cycle_tree_split_orca(TreeSetUp)

tic


nbasins_use=TreeSetUp.nbasins_use;
file_name=TreeSetUp.file_name;

file_name_season=TreeSetUp.file_name_season;
file_name_season_anom=TreeSetUp.file_name_season_anom;
file_WOD_suf=TreeSetUp.file_WOD_suf;
file_path_hdata=TreeSetUp.file_path_hdata;
fname_nc_season=TreeSetUp.fname_nc_season;
fname_nc=TreeSetUp.fname_nc;

tree_prefix=TreeSetUp.tree_prefix;
tree_model_file_name_season=TreeSetUp.tree_model_file_name_season;
tree_model_file_name_yearly=TreeSetUp.tree_model_file_name_yearly;
tree_model_file_name_all_year=TreeSetUp.tree_model_file_name_all_year;
tree_model_file_name_combined=TreeSetUp.tree_model_file_name_combined;
% 
% file_name_season=[file_name,'_seasonal'];
% file_name_season_anom=[file_name_season,'_anom'];

path_oisst=TreeSetUp.path_oisst;
path_OHCA_data_out=TreeSetUp.path_OHCA_data_out;
path_OHCA_data_in=TreeSetUp.path_OHCA_data_in;
path_ssh=TreeSetUp.path_ssh;

path_tree=TreeSetUp.path_tree;
path_new_tree_season=TreeSetUp.path_new_tree_season;
path_new_tree_yearly=TreeSetUp.path_new_tree_yearly;
path_new_tree_all_year=TreeSetUp.path_new_tree_all_year;

path_tree_junk=TreeSetUp.path_tree_junk;
path_curve=TreeSetUp.path_curve;

layer_bounds=TreeSetUp.layer_bounds;

start_year=TreeSetUp.start_year;
end_year=TreeSetUp.end_year;

start_year_mean=TreeSetUp.start_year_mean;
end_year_mean=TreeSetUp.end_year_mean;
max_year_fit=TreeSetUp.max_year_fit;
min_year_fit=TreeSetUp.min_year_fit;
center_year=TreeSetUp.center_year;

start_yearly_maps=TreeSetUp.start_yearly_maps;
end_yearly_maps=TreeSetUp.end_yearly_maps;

start_all_year=TreeSetUp.start_all_year;
end_all_year=TreeSetUp.end_all_year;

start_year_trans=TreeSetUp.start_year_trans;
end_year_trans=TreeSetUp.end_year_trans;
%%



% tree_model_file_name='tree_sst_tpx_yearly_overlap_seasonal';
% path_oisst='C:\data\oisst\';
% file_name_argo='pfloat_sal_greg_oct_2021_QC'
% path_OHCA_data_out='C:\data\OHCA\'
% path_OHCA_data_in='C:\OHCA\'
% 
%  layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
 nlayer=length(layer_bounds);
% file_name='argo_2020_10_14_QC';
% file_name_season=[file_name,'_seasonal'];
% path_tree=[path_OHCA_data_out,'OHCA_trees\'];
% path_new_tree=[path_tree,tree_model_file_name,'\'];
% 
% file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
% path_ssh=[path_OHCA_data_in,'Mtpers\'];

%  get this year basied on when there is delayed mode Aviso SSH and where
%  there is good coverage of Argo floats
% 
% max_year=max_year_fit;
% min_year=min_year_fit;










% % % 

parfor ilayer=2:nlayer

    

    
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
    tree_file_name=[tree_model_file_name_season,'_',layer_name];
    [ht_estimate,lon_tpx,lat_tpx,time_aviso]=parload_tree([path_new_tree_season,tree_file_name,'_split_7day.mat']);
%     load([path_new_tree_season,tree_file_name,'_split_7day.mat'], 'ht_estimate','lon_tpx','lat_tpx', 'time_aviso')
    nlon=length(lon_tpx);
    nlat=length(lat_tpx);
    use_years=floor(time_aviso)>=min_year_fit & floor(time_aviso)<=max_year_fit;
    nyears_tot=length(find(use_years));

    amp_annual_total=nans(nlon,nlat);
    amp_semi_total=amp_annual_total;
    amp_third_total=amp_annual_total;

    phase_annual_total=amp_annual_total;
    phase_semi_total=amp_annual_total;
    phase_third_total=amp_annual_total;

    slope_total=amp_annual_total;
    mean_total=amp_annual_total;
    model_err_total=amp_annual_total;
    for ilon=1:nlon 
        for ilat=1:nlat 
             jyin=squeeze(ht_estimate(ilon,ilat,:));
             jtime=time_aviso;
             good=isfinite(jyin)&use_years';
             jyin=jyin(good)';
             jtime=jtime(good);

             if length(jtime)>.9*nyears_tot % only fit a seasonal cycle when there is 90% coverage
    
                 [~,amp_annual,phase_annual,amp_semi,phase_semi,amp_third,phase_third,slope,mean,model_err]=...
                     j_fit_annual_tree(jtime,jyin);
                 amp_annual_total(ilon,ilat)=amp_annual;
                 amp_semi_total(ilon,ilat)=amp_semi;
                 amp_third_total(ilon,ilat)=amp_third;
                 
                 phase_annual_total(ilon,ilat)=phase_annual;
                 phase_semi_total(ilon,ilat)=phase_semi;
                 phase_third_total(ilon,ilat)=phase_third;
    
                 slope_total(ilon,ilat)=slope;
                 mean_total(ilon,ilat)=mean;
%                  model_err_total(ilon,ilat)=model_err;
             end
        end
    end
%     save([path_tree,tree_file_name,'_seasonal_cycle_split.mat'],...
%         'amp_annual_total','phase_annual_total','amp_semi_total','phase_semi_total',...
%         'amp_third_total','phase_third_total','slope_total','mean_total',...
%         'time_aviso','lon_tpx','lat_tpx')
    parsave_cycle([path_tree,tree_file_name,'_seasonal_cycle_split.mat'],...
        amp_annual_total,phase_annual_total,amp_semi_total,phase_semi_total,...
        amp_third_total,phase_third_total,slope_total,mean_total,...
        time_aviso,lon_tpx,lat_tpx)
    
end
toc./60
clear ht_estimate 
% now make an annual cycyle for just the Aviso data over the same time
% period

% load the aviso ssh

'Make Aviso seasonal'

s_allfiles=dir([path_ssh,'matlab_files\new_ssh*.mat']);
s=s_allfiles(1:7:length(s_allfiles));
nfiles=length(s);
sday=strjust(strvcat(s(:).name),'right');
sday=str2num(sday(:,end-8:end-4));


sday=sday+datenum(1950,1,1);
datevec_sday=datevec(sday);
aviso_day=sday-datenum(datevec_sday(:,1),1,1)+1;
syr=datevec_sday(:,1)+(aviso_day-1)./yeardays(datevec_sday(:,1));
aviso_mon=datevec_sday(:,2);
clear sday
% only load the good files
good_tpx=floor(syr)>=min_year_fit & floor(syr)<=max_year_fit;

s=s(good_tpx);
syr=syr(good_tpx);

nfiles=length(s);








load([s(1).folder,'\',s(1).name],'lat','lon')
lat_tpx=lat;
lon_tpx=lon;
nlat_tpx=length(lat_tpx);
nlon_tpx=length(lon_tpx);



ssh_total=nans(nlon_tpx,nlat_tpx,nfiles);

time_aviso=nans(1,nfiles);

for ifile=1:nfiles
    
    load([s(ifile).folder,'\',s(ifile).name])
    

%     if ~exist('offset_adt','var') 
        % only take delayed mode ssh for the means fine for the anomly
        ssh_total(:,:,ifile)=sshanom;
        
        time_aviso(ifile)=syr(ifile);
%     end
    clear offsset_adt
end
   
% now fit a seasonal cycle and save it


    
amp_annual_total=nans(nlon_tpx,nlat_tpx);
amp_semi_total=amp_annual_total;
amp_third_total=amp_annual_total;

phase_annual_total=amp_annual_total;
phase_semi_total=amp_annual_total;
phase_third_total=amp_annual_total;

slope_total=amp_annual_total;
mean_total=amp_annual_total;
model_err_total=amp_annual_total;
nyears_tot=length(time_aviso);
for ilon=1:nlon_tpx 
    for ilat=1:nlat_tpx 
         jyin=squeeze(ssh_total(ilon,ilat,:));
         jtime=time_aviso;
         good=isfinite(jyin);
         jyin=jyin(good)';
         jtime=jtime(good);

         if length(jtime)>.9*nyears_tot % only fit a seasonal cycle when there is 90% coverage

             [~,amp_annual,phase_annual,amp_semi,phase_semi,amp_third,phase_third,slope,mean,model_err]=...
                 j_fit_annual_tree(jtime,jyin);
             amp_annual_total(ilon,ilat)=amp_annual;
             amp_semi_total(ilon,ilat)=amp_semi;
             amp_third_total(ilon,ilat)=amp_third;
             
             phase_annual_total(ilon,ilat)=phase_annual;
             phase_semi_total(ilon,ilat)=phase_semi;
             phase_third_total(ilon,ilat)=phase_third;

             slope_total(ilon,ilat)=slope;
             mean_total(ilon,ilat)=mean;
%                  model_err_total(ilon,ilat)=model_err;
         end
    end
end

save([path_tree,tree_model_file_name_season,'_seasonal_cycle_tpx_split.mat'],...
    'amp_annual_total','phase_annual_total','amp_semi_total','phase_semi_total',...
    'amp_third_total','phase_third_total','slope_total','mean_total',...
    'time_aviso','lon_tpx','lat_tpx')

end

function parsave_cycle(filename,amp_annual_total,phase_annual_total,amp_semi_total,phase_semi_total,...
        amp_third_total,phase_third_total,slope_total,mean_total,...
        time_aviso,lon_tpx,lat_tpx)
         

         save (filename,'amp_annual_total','phase_annual_total','amp_semi_total',...
             'phase_semi_total','amp_third_total','phase_third_total','slope_total','mean_total',...
        'time_aviso','lon_tpx','lat_tpx','-v7.3')

end

function [ht_estimate,lon_tpx,lat_tpx,time_aviso]=parload_tree(filename)
    
    load(filename, 'ht_estimate','lon_tpx','lat_tpx', 'time_aviso')     
end


