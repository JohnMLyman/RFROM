
s=size(TreeStats);



for ibasin=[2 5 1]    
    
    for iyear=1:s(3)
        
        

        for ilayer=s(2)-2
                PredictorNames=TreeStats(ibasin,ilayer,iyear).PredictorNames;
                imp=TreeStats(ibasin,ilayer,iyear).PredictorImpotance
                
                
                layer_title=TreeStats(ibasin,ilayer,iyear).LayerTitle;
                Basin_name=TreeStats(ibasin,ilayer,iyear).BasinName;

                PredictorNames_old=TreeStats_old(ibasin,ilayer,iyear+8).PredictorNames;
                imp_old=TreeStats_old(ibasin,ilayer,iyear+8).PredictorImpotance
                
                
                layer_title_old=TreeStats_old(ibasin,ilayer,iyear+8).LayerTitle;
                Basin_name_old=TreeStats_old(ibasin,ilayer,iyear+8).BasinName;

                            figure(1);
                            clf
                            bar(imp);
                            h=gca;
                            ylabel('Predictor importance estimates');
                            xlabel('Predictors');
                              h.XTickLabel =PredictorNames;
                            h.XTickLabelRotation = 45;
                            h.TickLabelInterpreter = 'none';
                            title([layer_title,' ',Basin_name])

                            hold on
                            bar(imp_old);
%                             h=gca;
%                             ylabel('Predictor importance estimates');
%                             xlabel('Predictors');
%                               h.XTickLabel =PredictorNames_old;
%                             h.XTickLabelRotation = 45;
%                             h.TickLabelInterpreter = 'none';
%                             title([layer_title_old,' old ',Basin_name_old])
                            pause
                           
            

        end
    end
end


