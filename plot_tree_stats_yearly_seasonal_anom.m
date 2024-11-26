file_name='argo_2021_02_02_QC'
max_year_fit=2021;
min_year_fit=2008;
start_year=1993;
end_year=2021.5;
center_year=(max_year_fit+min_year_fit)./2;



tree_model_file_name_old='tree_sst_tpx_yearly_overlap_seasonal';
tree_model_file_name=[tree_model_file_name_old,'_anom'];
path_OHCA_data_out='C:\data\OHCA\'
file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
path_tree=[path_OHCA_data_out,'OHCA_trees\'];
path_new_tree=[path_tree,tree_model_file_name,'\'];
% file_name='argo_2020_10_14_QC';
file_name_season=[file_name,'_seasonal'];
file_WOD_suf='_cheng_EN4_2014';
file_path_hdata=[path_OHCA_data_out,'OHCA_maps\'];






 

file_stats=[path_new_tree,tree_model_file_name,'_all_stats.mat'];

load(file_stats,'TreeStats')

stree=size(TreeStats);
nlayer=stree(2);
nbasin=stree(1);

PredictorNames=TreeStats(1,2).PredictorNames; % there are the same for all
start_year=1993;
end_year=2021;
for ilayer=2:nlayer
    
    


for iyear_mod=start_year:end_year
    tic
     
     year_file_name=num2str(iyear_mod)
     iyear=iyear_mod-start_year+1;

%     for ibasin=1:nbasin
      for ibasin=2

       
        if ~isempty(TreeStats(ibasin,ilayer,iyear).LayerTitle)
            figure(1);
            clf
            oobErrorBaggedEnsemble = TreeStats(ibasin,ilayer,iyear).oobError;
            plot(oobErrorBaggedEnsemble)
            xlabel 'Number of grown trees';
            ylabel 'Out-of-bag classification error';
            title([TreeStats(ibasin,ilayer,iyear).LayerTitle,' ',TreeStats(ibasin,ilayer).BasinName])
            



            figure(2);
            imp = TreeStats(ibasin,ilayer,iyear).PredictorImpotance;
            bar(imp);
            ylabel('Predictor importance estimates');
            xlabel('Predictors');
            h = gca;
            PredictorNames={'Year' 'Lon' 'Lat' 'SSH' 'SST'};
            h.XTickLabel =PredictorNames;
            h.XTickLabelRotation = 45;
            h.TickLabelInterpreter = 'none';
            title([TreeStats(ibasin,ilayer,iyear).LayerTitle,' ',TreeStats(ibasin,ilayer).BasinName])
    
       
        end

    end
end           

  
    
 
end




