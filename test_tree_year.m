
global_basins=find_basin_paige(coords(:,1),coords(:,2));




paroptions = statset('UseParallel',true);
good_yr=(floor(yr)>=2000 & isfinite(ht_use));
nbasins=length(global_basins);

for ibasin=1:nbasins
       junk_pos=global_basins(ibasin).pos;
       good=good_yr & junk_pos;

       ht_mat=ht_use(good)';
       
       if ~isempty(ht_mat)
           input_mat=nans(length(ht_mat),5);
           input_mat(:,1)=yr(good);
           input_mat(:,2)=coords(good,1);
           input_mat(:,3)=coords(good,2);
           input_mat(:,4)=tpx(good);
           input_mat(:,5)=sst(good);
    
    
           m=TreeBagger(30,input_mat,ht_mat','Method','regression','MinLeafSize',20,...
                'OOBPrediction','on','PredictorSelection','curvature','OOBPredictorImportance','on',...
                 'Options',paroptions);
       
           model_all(ibasin).name=global_basins(ibasin).name;
           model_all(ibasin).model=m;
    
           oobErrorBaggedEnsemble = oobError(m);
           plot(oobErrorBaggedEnsemble)
           xlabel 'Number of grown trees';
           ylabel 'Out-of-bag classification error';
        
        
        
           mCART = m.OOBPermutedPredictorDeltaError;
        
           figure;
           bar(mCART);
           title([global_basins(ibasin).name,': Curvature CART']);
           ylabel('Predictor importance estimates');
           xlabel('Predictors');
           h = gca;
           h.XTickLabel = m.PredictorNames;
           h.XTickLabelRotation = 45;
           h.TickLabelInterpreter = 'none';
        
           oobErrorBaggedEnsemble = oobError(m);
           plot(oobErrorBaggedEnsemble)
           xlabel 'Number of grown trees';
           ylabel 'Out-of-bag classification error';
           title([global_basins(ibasin).name])
       end
   
end

clear input_mat m
%     view(m.Trees{1},'mode','graph');
  