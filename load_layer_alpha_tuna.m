
function [alat,alon,alpha]=load_layer_alpha_tuna(file_name,layer_bounds,depth_top,depth_bot)
%  NOTE:  depth_top and depth_bot MUST BE A MEMBER OF layer bounds
% lat_junk=[];
% lon_junk=[];
% htdiff_junk=[];
% ht_junk=[];
% one_junk=[];
% time_junk=[];
% tpx_junk=[];
ilayer_junk=2;
junk_name_hregress=['hregress_',file_name,'_',...
     num2str(layer_bounds(ilayer_junk-1)),'_',...
     num2str(layer_bounds(ilayer_junk))];
junk_alpha_name=['alpha_',num2str(layer_bounds(ilayer_junk-1)),'_',...
     num2str(layer_bounds(ilayer_junk))];
     


    eval(['load /Volumes/ThunderBay/Data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/',junk_name_hregress,...
        ' alon alat ',junk_alpha_name]);
alat_junk=alat*0;
alon_junk=alon*0;
eval(['alpha_junk=0*',junk_alpha_name,';']);

 

if ismember(depth_top,layer_bounds) && ismember(depth_bot,layer_bounds)
    
    
for ilayer=2:length(layer_bounds)
 
     junk_name_hregress=['hregress_',file_name,'_',...
         num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer))];
    
     junk_alpha_name=['alpha_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer))];
     


    eval(['load /Volumes/ThunderBay/Data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/',junk_name_hregress,...
        ' alon alat ',junk_alpha_name]);
    
     if (layer_bounds(ilayer)<= depth_bot && layer_bounds(ilayer-1)>= depth_top)
         
         
         [num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
            alat_junk=alat;
            alon_junk=alon;
            eval(['alpha_junk=alpha_junk+',junk_alpha_name,';']);

            
     end
     
end
end
alpha=alpha_junk;
alat=alat_junk;
alon=alon_junk;
