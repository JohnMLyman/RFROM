
load_TreeSetUp


cold_to_hot_colormap=diverging_map([0:1/200:1],[20 43 140]/255,[204 0 51]/255);

tree_model_file_name_old=tree_model_file_name_season;% this file is necessary to download seasonal data
tree_model_file_name=tree_model_file_name_all_year;




 

file_stats=[path_new_tree_all_year,tree_model_file_name,'_all_stats_split.mat'];

load(file_stats,'TreeStats')

stree=size(TreeStats);
nlayer=stree(2);
nbasin=stree(1);

PredictorNames=TreeStats(1,2).PredictorNames; % there are the same for all
start_year=1993;
end_year=2021;
 figure(1);
 clf;orient tall; wysiwyg_tuna

    
    
basins_pos=[1,2,5];
layers_pos=[2:11]; colormap(cold_to_hot_colormap)
  for jbasin=1:length(basins_pos)
      ibasin=basins_pos(jbasin);
      subplot(3,1,jbasin)
    
for jlayer=1:length(layers_pos)
    ilayer=layers_pos(jlayer);
       
        if ~isempty(TreeStats(ibasin,ilayer).LayerTitle)
%             figure(1);
%             clf
%             oobErrorBaggedEnsemble = TreeStats(ibasin,ilayer).oobError;
%             plot(oobErrorBaggedEnsemble)
%             xlabel 'Number of grown trees';
%             ylabel 'Out-of-bag classification error';
%             title([TreeStats(ibasin,ilayer).LayerTitle,' ',TreeStats(ibasin,ilayer).BasinName])
%             



           
            imp = TreeStats(ibasin,ilayer).PredictorImpotance;
            hold on
            color_line=cold_to_hot_colormap(floor(200*(12-ilayer)./10)-10,:);
           
            plot(imp,'color',color_line,'LineWidth',2)
            hold on
            ylabel('Predictor importance estimates');
            
            h = gca;
            PredictorNames={'Year' '' 'Lon' '' 'Lat' '' 'SSH' '' 'SST'};
            
           
            h.XTickLabel='';
%             title(TreeStats(ibasin,ilayer).BasinName)
           set(gca,'tickdir','out','Fontname','Arial','box','on')
            if ibasin==1
                layer_name=[num2str(layer_bounds(ilayer-1)),'--',num2str(layer_bounds(ilayer)),' m'];
                
             plot([1.25 1.5]+.25,[45 45]-(ilayer-2)*3,'color',color_line,'LineWidth',2);
             text(1.5+.05+.25,45-(ilayer-2)*3,layer_name,'color',color_line,'FontName','Arial','FontSize',...
                 8,'Interpreter','Latex','FontWeight','bold')
             text(1.25,45,'(a)','FontName','Arial','FontSize',12)

            end
            if ibasin==2
                text(1.25,35,'(b)','FontName','Arial','FontSize',12)
            end
            if ibasin==5
               text(1.25,30.1,'(c)','FontName','Arial','FontSize',12)
               h.XTickLabel =PredictorNames;
            h.XTickLabelRotation = 45;
            xlabel('Predictors');
            end
    
        
        end

    end
end           

  
    
 


path_figs='D:\data\OHCA\figs\tree_paper\'
 eval(['print -dpng -r600 -f1 ',path_figs,'importance_orca'])


