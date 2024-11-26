



global_basins=find_basin_paige(coords(:,1),coords(:,2));




paroptions = statset('UseParallel',true);

nbasins=length(global_basins);

for ibasin=1:nbasins
       junk_pos=global_basins(ibasin).pos;
       
       good=good_yr & good_prof & junk_pos & use;

       ht_mat=ht_use(good)';
       
       if ~isempty(ht_mat)
           input_mat=nans(length(ht_mat),5);
           input_mat(:,1)=yr(good);
           input_mat(:,2)=coords(good,1);
           input_mat(:,3)=coords(good,2);
           input_mat(:,4)=tpx(good);
           input_mat(:,5)=sst(good);
           ntrees=30;

    
           if ~ismember(ibasin,[1 2 5])
               ntrees=30;
           end


           m=TreeBagger(ntrees,input_mat,ht_mat','Method','regression','MinLeafSize',20,...
                'OOBPrediction','on','PredictorSelection','curvature','OOBPredictorImportance','on',...
                 'Options',paroptions);
           cmod=compact(m);
           model_all(ibasin).name=global_basins(ibasin).name;
           model_all(ibasin).model=m;
% 
%            compact_model_all(ibasin).name=global_basins(ibasin).name;
%            compact_model_all(ibasin).model=cmod;
           clear m cmod
           
       end
   
       



end
clear input_mat


%     view(m.Trees{1},'mode','graph');
  