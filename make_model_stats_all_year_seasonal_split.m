function []=make_model_stats_all_year_seasonal_split(TreeSetUp)

load_TreeSetUp

 nlayer=length(layer_bounds);



 

for ilayer=2:nlayer
    
    
   

   



    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
    layer_title=[num2str(layer_bounds(ilayer-1)),'m to ',num2str(layer_bounds(ilayer)),'m'];
   file_big_model=[path_new_tree_season,tree_model_file_name_season,'_model_',layer_name,'_split.mat'];
   
    
    load(file_big_model,'model_all')

    nbasin=length(model_all);
    
    for ibasin=1:nbasin
        Mdl=model_all(ibasin).model;
        if ~isempty(Mdl)
%             figure;
            oobErrorBaggedEnsemble = oobError(Mdl);
%             plot(oobErrorBaggedEnsemble)
%             xlabel 'Number of grown trees';
%             ylabel 'Out-of-bag classification error';
%             
            imp = Mdl.OOBPermutedPredictorDeltaError;
% %              title([layer_title,' ',model_all(ibasin).name])
%             figure;
%             bar(imp);
%             
%             ylabel('Predictor importance estimates');
%             xlabel('Predictors');
%             h = gca;
            PredictorNames={'Year' 'Lon' 'Lat' 'SST'};
%             h.XTickLabel =PredictorNames;
%             h.XTickLabelRotation = 45;
%             h.TickLabelInterpreter = 'none';
% %             title([layer_title,' ',model_all(ibasin).name])
    
            TreeStats(ibasin,ilayer).PredictorNames=PredictorNames;
            TreeStats(ibasin,ilayer).PredictorImpotance=imp;
            TreeStats(ibasin,ilayer).oobError=oobErrorBaggedEnsemble;
            TreeStats(ibasin,ilayer).LayerName=layer_name;
            TreeStats(ibasin,ilayer).LayerTitle=layer_title;
            TreeStats(ibasin,ilayer).BasinName=model_all(ibasin).name;
       
        end

    end
            

  
    
  
end
 toc./60

file_stats=[path_new_tree_season,tree_model_file_name_season,'_all_stats_split.mat'];

save(file_stats,'TreeStats')


