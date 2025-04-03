function [model_all]=make_trees_mean_nosst_nossh_sal_paige_noeqbox_test(use,ht_use,...
    temp_use,layer_offset,coords,yr,nbasins_use,good_yr,good_prof,large_scale,...
    scale_box_deg_lat,scale_box_eq,lat_change)
        
if ~exist("large_scale",'var')
    large_scale='none';
end

model_all=[];

global_basins=find_basin_paige(coords(:,1),coords(:,2));

ntree_fact=(max(layer_offset(:))-min(layer_offset)+1)/2;


paroptions = statset('UseParallel',true);

nbasins=length(global_basins);
if ~exist('nbasins_use','var')
    nbasins_use=[1:nbasins];
end
for ibasin=nbasins_use
       junk_pos=global_basins(ibasin).pos;
       
       good=good_yr & good_prof & junk_pos & use;

       ht_mat=ht_use(good)';
       
       if ~isempty(ht_mat)
           input_mat=nans(length(ht_mat),6);
           input_mat(:,1)=yr(good);
           
           input_mat=smooth_lat_lon_eqbox_model(input_mat,coords,good,ibasin,...
               large_scale,scale_box_deg_lat,scale_box_eq,lat_change);

           month_angle=(yr(good)-floor(yr(good))).*2*pi;
           
           input_mat(:,4)=temp_use(good);
           input_mat(:,5)=cos(month_angle);
           input_mat(:,6)=sin(month_angle);

           ntrees=30;

    
           if ~ismember(ibasin,[1 2 5])
               ntrees=100;
           end


           m=TreeBagger(ntrees,input_mat,ht_mat','Method','regression','MinLeafSize',10*ntree_fact,...
                'OOBPrediction','on','PredictorSelection','curvature','OOBPredictorImportance','on',...
                 'Options',paroptions);
%            cmod=compact(m);
           model_all(ibasin).name=global_basins(ibasin).name;
           model_all(ibasin).model=m;

%            compact_model_all(ibasin).name=global_basins(ibasin).name;
%            compact_model_all(ibasin).model=cmod;
%            clear m cmod
           
       end
   
       



end
% clear input_mat


%     view(m.Trees{1},'mode','graph');