function bagged_tree_ohca_curve_7_day_error_weight_split(TreeSetUp)
load_TreeSetUp


min_layer=0;
max_layer=2000;


tree_model_file_name=tree_model_file_name_combined;

endlayer=find(layer_bounds==max_layer);
startlayer=find(layer_bounds==min_layer)+1;



load('C:\Users\jlyma\OneDrive - University of Hawaii\data\topo_tpx_new.mat','topo_tpx_new')
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
layer_curve_error=nans(endlayer-startlayer+1,ntime_tpx);
nbasin=10;
scale_curve=nans(endlayer-startlayer+1,nbasin,ntime_tpx);


for ilayer=startlayer:endlayer
    tic
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
    tree_file_name_yearly_error=[tree_model_file_name,'_error_',layer_name];

    load([path_tree,tree_file_name_yearly_error,'_2xweight_7day_split.mat'],...
        'scale_total_median','ht_error','time_aviso')

%     for itime=1:nyears
%         jyear=tgrid(itime);
%         ht_out(:,:,itime)=mean(ht_estimate(:,:,time_aviso<jyear+.5&time_aviso>=jyear-.5),3,'omitnan').*arwj;
%     end
    
   ht_out=ht_error.*arwj;
   test_curve=jnansum(ht_out.^2,1);
   % the 4 times accounts for 100 km scale to errors.
   test_curve=4.*sqrt(squeeze(jnansum(test_curve,2)));
%    ht_out_total=nansum(cat(4,ht_out_total,ht_out.^2),4);
   layer_curve_error(ilayer-startlayer+1,:)=test_curve;
   s_scale=size(scale_total_median);
   scale_curve(ilayer-startlayer+1,1:s_scale(1),:)=scale_total_median;

  

   

   toc./60

end








figure(10)

plot(tgrid(2:end-25),4.*jnansum(layer_curve_error(:,2:end-25),1)./1e21)

 sb=size(scale_curve);


for ibasin=1:sb(2)
    figure(ibasin)
  
   pcolor(tgrid(26:end-72),-1.*layer_bounds(2:end),squeeze(scale_curve(:,ibasin,26:end-72)))
  title(ibasin)
   caxis([0 10])
   shading flat
   
end
figure(23)
plot(tgrid(2:end-25),smooth(4.*jnansum(layer_curve_error(:,2:end-25),1)./1e21,52)./sqrt(12))

curve_name=['curve_error_',tree_prefix,'_0_2000_2xweights_split.mat'];
save([path_curve,curve_name], 'tgrid', ...
    'layer_curve_error' ,'scale_curve')



