function []=make_seasonal_cycle_tree_split_orca_vert_SST_ME4OH(TreeSetUp)

% This code makes the synthetic SST anomaly files that are used in the in
% the rest of the code.  They are made each time, so that the seasonal
% cycle is computed so the seasonal cycle removed from these files is the
% same as that removed from ssh and heat


nbasins_use=TreeSetUp.nbasins_use;
file_name=TreeSetUp.file_name;
var_type=TreeSetUp.var_type;



file_name_season=TreeSetUp.file_name_season;
file_name_season_anom=TreeSetUp.file_name_season_anom;
file_WOD_suf=TreeSetUp.file_WOD_suf;
file_path_hdata=TreeSetUp.file_path_hdata;
fname_nc_season=TreeSetUp.fname_nc_season;
fname_nc=TreeSetUp.fname_nc;
file_name_basin_coverage=TreeSetUp.file_name_basin_coverage;

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
percent_good_fit=TreeSetUp.percent_good_fit;


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


    
    
    
'Make SST seasonal'

path_SST=path_oisst;

s_sst=dir([path_SST,'sst.day.mean.*']);
nyears_total=length(s_sst);
nyears_fit=max_year_fit-min_year_fit+1;
lon_tpx=ncread([path_SST,s_sst(1).name],'lon');
lat_tpx=ncread([path_SST,s_sst(1).name],'lat');

nlon_tpx=length(lon_tpx);
nlat_tpx=length(lat_tpx);
sst_total=nan(nlon_tpx,nlat_tpx,nyears_fit*53);
time_sst=nan(1,nyears_fit*53);


start_ind=1;
for iyear=min_year_fit:max_year_fit

    file_name_SST_in=[path_SST,'sst.day.mean.',num2str(iyear),'.nc'];
    if exist(file_name_SST_in,'file')
        sst_junk=ncread(file_name_SST_in,'sst');
        time_junk=ncread(file_name_SST_in,'time');
        end_ind=start_ind+length(time_junk)-1;
        sst_total(:,:,start_ind:end_ind)=sst_junk;
        time_sst(start_ind:end_ind)=time_junk;
        start_ind=end_ind+1;
    else
        disp('SST files out of range of annual FIT!!!')
        break
    end
end

good_sst=isfinite(time_sst);

sst_total=sst_total(:,:,good_sst);
time_sst=time_sst(good_sst);
yr_sst=decyear(datevec(time_sst+datenum(1800,1,1)));


%    
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
nyears_tot=length(yr_sst);
parfor ilat=1:nlat_tpx 
    for ilon=1:nlon_tpx 
         jyin=squeeze(sst_total(ilon,ilat,:));
         jtime=yr_sst;
         good=isfinite(jyin);
         jyin=jyin(good)';
         jtime=jtime(good)';

         if length(jtime)>percent_good_fit*nyears_tot % only fit a seasonal cycle when there is 50% coverage

             [~,amp_annual,phase_annual,amp_semi,phase_semi,amp_third,phase_third,slope_fit,mean_fit,model_err]=...
                 j_fit_annual_tree(jtime,jyin);
             amp_annual_total(ilon,ilat)=amp_annual;
             amp_semi_total(ilon,ilat)=amp_semi;
             amp_third_total(ilon,ilat)=amp_third;
             
             phase_annual_total(ilon,ilat)=phase_annual;
             phase_semi_total(ilon,ilat)=phase_semi;
             phase_third_total(ilon,ilat)=phase_third;

             slope_total(ilon,ilat)=slope_fit;
             mean_total(ilon,ilat)=mean_fit;
         end
%                  model_err_total(ilon,ilat)=model_err;
    end
end


save([path_tree,tree_model_file_name_season,'_seasonal_cycle_sst_split.mat'],...
    'amp_annual_total','phase_annual_total','amp_semi_total','phase_semi_total',...
    'amp_third_total','phase_third_total','slope_total','mean_total',...
    'yr_sst','lon_tpx','lat_tpx')

% now remove the seasional cylce and save the anomily files for sst

period=1;
period2=1/2;
period3=1/3;

parfor iyear=1:nyears_total
    name_file_mean=s_sst(iyear).name;
    name_file_anom=name_file_mean;
    pos_mean=strfind(name_file_mean,'mean');
    name_file_anom(pos_mean:pos_mean+3)='anom';

    file_name_SST_in=[path_SST,name_file_mean];
    file_name_SST_out=[path_SST,name_file_anom];
   
    if exist(file_name_SST_in,'file')
        sst_anom=ncread(file_name_SST_in,'sst');
        time_junk=double(ncread(file_name_SST_in,'time'));
        yr_junk=decyear(datevec(time_junk+datenum(1800,1,1)));
        
        good_t=reshape(yr_junk,[1 1 length(yr_junk)]);
        sst_seasonal_cycle=amp_annual_total.*sin((2*pi.*good_t./period)+phase_annual_total)+amp_semi_total.*sin((2.*good_t*pi./period2)+phase_semi_total)+...
                    amp_third_total.*sin((2*pi.*good_t./period3)+phase_third_total)+mean_total+slope_total.*center_year;
        sst_anom=sst_anom-sst_seasonal_cycle;

        parsave_sstanom(file_name_SST_out,sst_anom,time_junk,lon_tpx,lat_tpx)
         
            
     
   
    end
end


end



function parsave_sstanom(filename,anom,time,lon,lat)

    if exist(filename,'file')
        delete(filename)
    end
    nlon=length(lon);
    nlat=length(lat);
    ntime=length(time);
    mySchema.Name   = '/';
%     mySchema.Format = "classic";
    mySchema.Dimensions(1).Name   = 'lon';
    mySchema.Dimensions(1).Length = nlon;
    mySchema.Dimensions(2).Name   = 'lat';
    mySchema.Dimensions(2).Length = nlat;
    mySchema.Dimensions(3).Name   = 'time';
    mySchema.Dimensions(3).Length = ntime;
    
    map_dimen(1).Name='lon';
    map_dimen(2).Name='lat';
    map_dimen(3).Name='time';
    map_dimen(1).Length=nlon;
    map_dimen(2).Length=nlat;
    map_dimen(3).Length=ntime;
    

     lon_att(1).Name='units';
    lon_att(1).Value='degrees_east';
    lon_att(2).Name='Description';
    lon_att(2).Value='Longitude (positive east)';
    lon_att(3).Name='standard_name';
    lon_att(3).Value='longitude';
    
    mySchema.Variables(1).Name='lon';
    mySchema.Variables(1).Dimensions=map_dimen(1);
    mySchema.Variables(1).Datatype='single';
    mySchema.Variables(1).FillValue='disable';
    
    mySchema.Variables(2).Name='lat';
    mySchema.Variables(2).Dimensions=map_dimen(2);
    mySchema.Variables(2).Datatype='single';
    mySchema.Variables(2).FillValue='disable';

    mySchema.Variables(3).Name='time';
    mySchema.Variables(3).Dimensions=map_dimen(3);
    mySchema.Variables(3).Datatype='single';
    mySchema.Variables(3).FillValue='disable';

    mySchema.Variables(4).Name='anom';
    mySchema.Variables(4).Dimensions=map_dimen;
    mySchema.Variables(4).Datatype='double';
    mySchema.Variables(4).FillValue='disable';

    ncwriteschema(filename, mySchema);
    ncwrite(filename,'lon',lon,[1]);
    ncwrite(filename,'lat',lat,[1]);
    ncwrite(filename,'time',time,[1]);
    ncwrite(filename,'anom',anom,[1 1 1]);


end
