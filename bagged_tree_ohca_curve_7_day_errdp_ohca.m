function bagged_tree_ohca_curve_7_day_errdp_ohca(TreeSetUp,min_depth,max_depth)


% min_depth and max_depth must be a layer bounds

nbasins_use=TreeSetUp.nbasins_use;
file_name=TreeSetUp.file_name;
var_type=TreeSetUp.var_type;

file_name_season=TreeSetUp.file_name_season;
file_name_season_anom=TreeSetUp.file_name_season_anom;
file_WOD_suf=TreeSetUp.file_WOD_suf;
file_path_hdata=TreeSetUp.file_path_hdata;
fname_nc_season=TreeSetUp.fname_nc_season;
fname_nc=TreeSetUp.fname_nc;

path_ERDDAP=TreeSetUp.path_ERDDAP;

path_Fig_data=TreeSetUp.path_Fig_data;

tree_prefix=TreeSetUp.tree_prefix;
tree_model_file_name_season=TreeSetUp.tree_model_file_name_season;
tree_model_file_name_yearly=TreeSetUp.tree_model_file_name_yearly;
tree_model_file_name_all_year=TreeSetUp.tree_model_file_name_all_year;
tree_model_file_name_combined=TreeSetUp.tree_model_file_name_combined;
tree_model_file_name_combined_withcycle=TreeSetUp.tree_model_file_name_combined_withcycle;

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
path_new_tree_combined=TreeSetUp.path_new_tree_combined;
path_new_tree_combined_withcycle=TreeSetUp.path_new_tree_combined_withcycle;


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

OUTOUT_type=TreeSetUp.OUTOUT_type;

%%

%%
subdir='yearly_withcycle_no_mean';
start_year_file=start_year;
end_year_file=end_year;
path_new_tree=path_new_tree_combined_withcycle;
tree_model=tree_model_file_name_combined_withcycle;
% tree_file_name=tree_file_name_in;
%%

path_nc_erddap=[path_ERDDAP,'netcdf\',tree_prefix,'\',subdir,'\'];
if var_type=='s'
     file_prefix='RFROMV22_SAL_';
elseif var_type=='t'
     file_prefix='RFROMV22_TEMP_';
else
    file_prefix='RFROMV22_OHC_';
end
%%

% endlayer=length(layer_bounds)-1;
% startlayer=1;

time_load=floor(start_year):floor(end_year);
% load('D:\data\old_mask_tree.mat','nan_mask')
% load('D:\data\topo_tpx_new.mat','topo_tpx_new')
%  topo_tpx_new=-1.*topo_tpx_new;

file_name_nc= [path_nc_erddap,file_prefix,num2str(2010),'_',num2str(10),'.nc'];
lat_tpx=double(ncread(file_name_nc,'latitude'));
lon_tpx=double(ncread(file_name_nc,'longitude'));
depth_bounds=double(ncread(file_name_nc,'mean_depth_bnds'));
pos_min=find(depth_bounds(1,:)==min_depth);
pos_max=find(depth_bounds(2,:)==max_depth);

if isempty(pos_max)|isempty(pos_min)
    'DEPTH MUST BE LAYERS!'
    return
end
    
    
good_area=fixed_area_mask(TreeSetUp,min_depth,max_depth); 
s_good_area=size(good_area);
arw=areavec(lon_tpx,lat_tpx);

arw=repmat(arw,[1 1 s_good_area(3)]);
arw(~good_area)=nan;
time_aviso=[];
ht_out=[];
ht_curve_layer=[];
tic
for year_load=time_load
     display(year_load)
     for imonth=1:12
        ht_out_total=[];
        
        if imonth>=10
              file_name_nc= [path_nc_erddap,file_prefix,num2str(year_load),'_',num2str(imonth),'.nc'];
           else
              file_name_nc= [path_nc_erddap,file_prefix,num2str(year_load),'_0',num2str(imonth),'.nc'];
        end
        
        if exist(file_name_nc,'file')
            ht_estimate=double(ncread(file_name_nc,'ocean_heat_content_anomaly')).*1e9;
            ht_estimate=ht_estimate(:,:,pos_min:pos_max,:);
            time_1950=ncread(file_name_nc,'time');
            time_matlab=double(time_1950)+datenum(1950,1,1);
            [time_year,~]=datevec(time_matlab);
            time_aviso_junk=time_year+(time_matlab-datenum(time_year,1,1))./yeardays(time_year);

               ht_out_junk=ht_estimate.*arw;

             ht_curve_layer_junk=jnansum(ht_out_junk,1);
             ht_curve_layer_junk=squeeze(jnansum(ht_curve_layer_junk,2));
          
               ht_out_total=squeeze(jnansum(ht_out_junk,3));
               
              
            
                
            
            
            
            
            time_aviso=cat(1,time_aviso,time_aviso_junk);
            ht_out=cat(3,ht_out,ht_out_total);
            ht_curve_layer=cat(2,ht_curve_layer,ht_curve_layer_junk);
        end
     end

toc./60./60
end


tgrid=time_aviso';


% mask_nan=sum(ht_out,3);
% 
% mask_nan=repmat(~isfinite(mask_nan),[1 1 length(tgrid)]);

ht_out_mask=ht_out;
% ht_out_mask(mask_nan)=nan;




ht_curve=jnansum(ht_out_mask,1);
ht_curve=squeeze(jnansum(ht_curve,2));
figure(14)
plot(tgrid,ht_curve./1e21)
depth_range_name=[num2str(min_depth),'_',num2str(max_depth)];

curve_name=['curve_',tree_prefix,'_',depth_range_name,'_ohca_nomean_',OUTOUT_type,'.mat'];
map_name=['map_',tree_prefix,'_',depth_range_name,'_ohca_nomean_',OUTOUT_type,'.mat'];

save ([path_Fig_data,curve_name], 'tgrid', 'ht_curve','ht_curve_layer');
save ([path_Fig_data,map_name], 'tgrid', 'ht_out','lat_tpx','lon_tpx','-v7.3');
