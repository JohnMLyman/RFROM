function [ht_out_annual,lon_tpx,lat_tpx,tgrid_annual]=load_annual_ohca_maps(TreeSetUp,min_depth,max_depth)

OUTOUT_type=TreeSetUp.OUTOUT_type;
path_Fig_data=TreeSetUp.path_Fig_data;
tree_prefix=TreeSetUp.tree_prefix;

depth_range_name=[num2str(min_depth),'_',num2str(max_depth)];


 map_name=['map_',tree_prefix,'_',depth_range_name,'_ohca_nomean_',OUTOUT_type,'.mat'];

load ([path_Fig_data,map_name], 'tgrid', 'ht_out','lat_tpx','lon_tpx')


tgrid_annual=(floor(min(tgrid)):floor(max(tgrid)))+.5;
s_ht=size(ht_out);
ht_out_annual=nans(s_ht(1),s_ht(2),length(tgrid_annual));
ipos=0;
for itgrid=tgrid_annual
    ipos=ipos+1;
    good=floor(tgrid)==floor(itgrid);
    ht_junk=ht_out(:,:,good);
    
    ht_out_annual(:,:,ipos)=mean(ht_junk,3,'omitnan');

end


end