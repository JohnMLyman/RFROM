tree_model_file_name='tree_sst_tpx_year_1993';
path_OHCA_data_out='C:\data\OHCA\'
file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
path_tree=[path_OHCA_data_out,'OHCA_trees\'];
path_new_tree=[path_tree,tree_model_file_name,'\'];
file_name='argo_2020_10_14_QC';
file_WOD_suf='_cheng_EN4_2014';
file_path_hdata=[path_OHCA_data_out,'OHCA_maps\'];







 

file_stats=[path_new_tree,tree_model_file_name,'_all_stats.mat'];

load(file_stats,'TreeStats')

stree=size(TreeStats);
nlayer=stree(2);
nbasin=stree(1);

PredictorNames=TreeStats(1,2).PredictorNames; % there are the same for all

for ilayer=2:nlayer
    
    




    for ibasin=1:nbasin

       
        if ~isempty(TreeStats(ibasin,ilayer).LayerTitle)
            figure(1);
            clf
            oobErrorBaggedEnsemble = TreeStats(ibasin,ilayer).oobError;
            plot(oobErrorBaggedEnsemble)
            xlabel 'Number of grown trees';
            ylabel 'Out-of-bag classification error';
            title([TreeStats(ibasin,ilayer).LayerTitle,' ',TreeStats(ibasin,ilayer).BasinName])
            



            figure(2);
            imp = TreeStats(ibasin,ilayer).PredictorImpotance;
            bar(imp);
            ylabel('Predictor importance estimates');
            xlabel('Predictors');
            h = gca;
            PredictorNames={'Year' 'Lon' 'Lat' 'SSH' 'SST'};
            h.XTickLabel =PredictorNames;
            h.XTickLabelRotation = 45;
            h.TickLabelInterpreter = 'none';
            title([TreeStats(ibasin,ilayer).LayerTitle,' ',TreeStats(ibasin,ilayer).BasinName])
    
            pause
        end

   
     end           

  
    
 
end




