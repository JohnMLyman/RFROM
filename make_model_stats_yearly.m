tree_model_file_name='tree_sst_tpx_year_1993';
tree_model_file_name='tree_sst_tpx_yearly';
path_OHCA_data_out='C:\data\OHCA\'
file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
path_tree=[path_OHCA_data_out,'OHCA_trees\'];
path_new_tree=[path_tree,tree_model_file_name,'\'];
file_name='argo_2020_10_14_QC';
file_WOD_suf='_cheng_EN4_2014';
file_path_hdata=[path_OHCA_data_out,'OHCA_maps\'];







 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
 nlayer=length(layer_bounds);

start_year=1993;
end_year=2021;

for iyear_mod=start_year:end_year
    tic
     
     year_file_name=num2str(iyear_mod)
     iyear=iyear_mod-start_year+1;


for ilayer=2:nlayer
    
    
   

   



    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
    layer_title=[num2str(layer_bounds(ilayer-1)),'m to ',num2str(layer_bounds(ilayer)),'m'];
   file_big_model=[path_new_tree,tree_model_file_name,'_model_',layer_name,'_',year_file_name,'.mat'];
   
    
    load(file_big_model,'model_all')

    nbasin=length(model_all);
    
    for ibasin=1:nbasin
        Mdl=model_all(ibasin).model;
        if ~isempty(Mdl)
%             figure;
%             oobErrorBaggedEnsemble = oobError(Mdl);
%             plot(oobErrorBaggedEnsemble)
%             xlabel 'Number of grown trees';
%             ylabel 'Out-of-bag classification error';
%             
%             imp = Mdl.OOBPermutedPredictorDeltaError;
% %              title([layer_title,' ',model_all(ibasin).name])
%             figure;
%             bar(imp);
%             
%             ylabel('Predictor importance estimates');
%             xlabel('Predictors');
%             h = gca;
%             PredictorNames={'Year' 'Lon' 'Lat' 'SSH' 'SST'};
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
        pause
        end

    end
            

  
    
  
end
 toc./60
end
file_stats=[path_new_tree,tree_model_file_name,'_all_stats.mat'];

save(file_stats,'TreeStats')


