function [model_all]=make_trees_mean_sal_nosstssh(use,ht_use,temp_use,layer_offset,coords,yr,nbasins_use,good_yr,good_prof)
        

model_all=[];

global_basins=find_basin_paige(coords(:,1),coords(:,2));


ntree_fact=(max(layer_offset(:))-min(layer_offset)+1)

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
           input_mat=nans(length(ht_mat),4);
           input_mat(:,1)=yr(good);
           
           if ibasin==2
               % use lon 0 to 360 for the pacific basin
               jj_lon=coords(good,1);
               jj_lon(jj_lon<0)=jj_lon(jj_lon<0)+360;


               input_mat(:,2)=jj_lon;
               input_mat(:,3)=coords(good,2);
          
           else
               input_mat(:,2)=coords(good,1);
               input_mat(:,3)=coords(good,2);
           end

           
%            input_mat(:,4)=tpx(good);
%            input_mat(:,5)=sst(good);
           input_mat(:,4)=temp_use(good);
%             input_mat(:,7)=layer_offset(good);

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