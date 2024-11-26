function []=make_model_stats_yearly_overlap_seasonal_split(TreeSetUp)

load_TreeSetUp

 nlayer=length(layer_bounds);



 for iyear_mod=start_year_mean:.5:end_year_mean

     year_file_name=num2str(10*iyear_mod)
    tic
     
    
     iyear=(iyear_mod-start_year_mean)*2+1;


for ilayer=2:nlayer
    
    
   

   



    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
    layer_title=[num2str(layer_bounds(ilayer-1)),'m to ',num2str(layer_bounds(ilayer)),'m'];
   file_big_model=[path_new_tree_season,tree_model_file_name_season,'_model_',layer_name,'_',year_file_name,'_split.mat'];
   
    
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
            PredictorNames={'Year' 'Lon' 'Lat' 'SSH' 'SST'};
%             h.XTickLabel =PredictorNames;
%             h.XTickLabelRotation = 45;
%             h.TickLabelInterpreter = 'none';
% %             title([layer_title,' ',model_all(ibasin).name])
    
            TreeStats(ibasin,ilayer,iyear).PredictorNames=PredictorNames;
            TreeStats(ibasin,ilayer,iyear).PredictorImpotance=imp;
            TreeStats(ibasin,ilayer,iyear).oobError=oobErrorBaggedEnsemble;
            TreeStats(ibasin,ilayer,iyear).LayerName=layer_name;
            TreeStats(ibasin,ilayer,iyear).LayerTitle=layer_title;
            TreeStats(ibasin,ilayer,iyear).BasinName=model_all(ibasin).name;
       
        end

    end
            

  
    
  
end
 toc./60
end
file_stats=[path_new_tree_season,tree_model_file_name_season,'_all_stats_split.mat'];

save(file_stats,'TreeStats')


