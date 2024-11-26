function []=bagged_tree_ohca_curve_7_day_with_cycle_combined_orca(TreeSetUp)
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

min_layer=0;
max_layer=2000;



% 
% tree_model_file_name_old='tree_sst_tpx_yearly_overlap_seasonal';
% 
% tree_model_file_name=['tree_sst_tpx_combined_seasonal_anom'];

tree_model_file_name_old=tree_model_file_name_season;
tree_model_file_name=tree_model_file_name_combined;
% path_OHCA_data_out='C:\data\OHCA\'
% path_OHCA_data_in='C:\OHCA\'
% 
%  layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
% 
% path_tree=[path_OHCA_data_out,'OHCA_trees\'];
% 
% file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
% path_ssh=[path_OHCA_data_in,'Mtpers\'];
nlayers=length(layer_bounds);
endlayer=find(layer_bounds==max_layer);
startlayer=find(layer_bounds==min_layer)+1;



load('D:\data\topo_tpx_new.mat','topo_tpx_new')
 topo_tpx_new=-1.*topo_tpx_new;

ilayer=2;
layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
tree_file_name=[tree_model_file_name,'_',layer_name];
load([path_tree,tree_file_name,'_split_7day.mat'], 'lon_tpx' ,'lat_tpx','time_aviso')
nlon_tpx=length(lon_tpx);
nlat_tpx=length(lat_tpx);
ntime_tpx=length(time_aviso);

tgrid=time_aviso;

ht_out_total=nans(nlon_tpx,nlat_tpx,ntime_tpx);
arw=areavec(lon_tpx,lat_tpx);
layer_curve=nans(endlayer-startlayer+1,ntime_tpx);
%compute basin curves
[LON,LAT]=ndgrid(lon_tpx,lat_tpx);
[global_basins_aviso]=find_basin_paige(LON,LAT);
nbasin=length(global_basins_aviso);


parfor ilayer=startlayer:endlayer
    tic
    basin_layer_curve_junk=nans(ntime_tpx,nbasin);

    
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
    arwj=arw;
    depth_min=layer_bounds(ilayer-1);
    depth_max=layer_bounds(ilayer);
    
    shallow=topo_tpx_new < depth_min;
    mid=topo_tpx_new>=depth_min & topo_tpx_new<depth_max;
    

    arwj(mid)=arwj(mid).*(topo_tpx_new(mid)-depth_min)./(depth_max-depth_min);
    arwj(shallow)=NaN;

    arwj=repmat(arwj,1,1,ntime_tpx);
    arwj=double(arwj);


    tree_file_name=[tree_model_file_name,'_',layer_name];
    tree_file_name_old=[tree_model_file_name_old,'_',layer_name];
%     load([path_tree,tree_file_name,'_split_7day.mat'], 'ht_estimate','time_aviso')
%     load([path_tree,tree_file_name_old,'_seasonal_cycle_expand_split.mat'],'ht_cycle','ht_mean')
    [ht_estimate,~]=...
        parload_ht_estimate([path_tree,tree_file_name,'_split_7day.mat']);
%     [ht_cycle]=...
%         parload_ht_cycle([path_tree,tree_file_name_old,'_seasonal_cycle_expand_split.mat']);

%     ht_estimate=ht_estimate+ht_cycle;
%     clear ht_cycle ht_mean
    
%     for itime=1:nyears
%         jyear=tgrid(itime);
%         ht_out(:,:,itime)=mean(ht_estimate(:,:,time_aviso<jyear+.5&time_aviso>=jyear-.5),3,'omitnan').*arwj;
%     end
    
   ht_out=ht_estimate.*arwj;
   test_curve=nansum(ht_out,1);
   test_curve=squeeze(nansum(test_curve,2));
%    ht_out_total=nansum(cat(4,ht_out_total,ht_out),4);
%    layer_curve(ilayer-startlayer+1,:)=test_curve;

  

    for ibasin=1:nbasin
    
        pos_basin=global_basins_aviso(ibasin).pos;
        pos_basin=repmat(pos_basin,1,1,ntime_tpx);
        jcurve=ht_out;
        jcurve(~pos_basin)=0;
        jcurve=nansum(jcurve,1);
        jcurve=squeeze(nansum(jcurve,2));
        basin_layer_curve_junk(:,ibasin)=jcurve;
    
    
    end
junk_file_name=[path_tree_junk,'junk_curve_',layer_name,'.mat'];
   
parsave_test_curve(junk_file_name,test_curve)

end

toc./60


tic
for ilayer=startlayer:endlayer
        layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
        junk_file_name=[path_tree_junk,'junk_curve_',layer_name,'.mat'];
        [test_curve]=parload_test_curve(junk_file_name);
%         ht_out_total=nansum(cat(4,ht_out_total,ht_out),4);
        layer_curve(ilayer-startlayer+1,:)=test_curve;
        ht_curve=ht_curve;



end
toc./60

basin_curve=nans(nbasin,ntime_tpx);

for ibasin=1:nbasin

    pos_basin=global_basins_aviso(ibasin).pos;
    pos_basin=repmat(pos_basin,1,1,ntime_tpx);
    jcurve=ht_out_total;
    jcurve(~pos_basin)=0;
    jcurve=nansum(jcurve,1);
    jcurve=squeeze(nansum(jcurve,2));
    basin_curve(ibasin,:)=jcurve;


end





ht_curve=nansum(ht_out_total,1);
ht_curve=squeeze(nansum(ht_curve,2));

figure(4)
plot(tgrid,ht_curve./1e21)


save ([path_tree,'test_tree_curve_yearly_7day_2000_yearly_new_cycle_combined_2_split.mat'], 'tgrid', 'ht_curve', 'basin_curve', 'layer_curve');
end

function parsave_test_curve(filename,test_curve)
         

         save (filename,'test_curve')

end
function [ht_estimate,time_aviso]=...
        parload_ht_estimate(filename)
         

         load(filename,'ht_estimate','time_aviso')

end
function [ht_cycle]=...
        parload_ht_cycle(filename)
         

         load(filename,'ht_cycle')

end
