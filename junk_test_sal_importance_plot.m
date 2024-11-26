load_TreeSetUp
file_stats=[path_new_tree_season,tree_model_file_name_season,'_all_stats_split.mat'];

load(file_stats,'TreeStats')

 PredictorNames={'Year' 'Lon' 'Lat' 'SSH' 'SST' 'Temp' 'Layer'};

for iyear_mod=start_year_mean:.5:end_year_mean
      iyear=(iyear_mod-start_year_mean)*2+1;
    for ilayer=2:59
    
    
%         for ibasin=1:nbasin
               ibasin=5;
            imp=TreeStats(ibasin,ilayer,iyear).PredictorImpotance;
            plot(imp)
            ylabel('Predictor importance estimates');
            xlabel('Predictors');
            h = gca;
           
            h.XTickLabel =PredictorNames;
            h.XTickLabelRotation = 45;
            h.TickLabelInterpreter = 'none';

            hold on
            pause
    
    
    
    
    
    
    
%         end
    end
end