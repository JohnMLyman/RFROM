function []=make_model_stats_yearly_seasonal_anom_orca_vert_sal(TreeSetUp)




load_TreeSetUp


nbasins_use=TreeSetUp.nbasins_use;
file_name=TreeSetUp.file_name;

file_name_season=TreeSetUp.file_name_season;
file_name_season_anom=TreeSetUp.file_name_season_anom;
file_WOD_suf=TreeSetUp.file_WOD_suf;
file_path_hdata=TreeSetUp.file_path_hdata;
fname_nc_season=TreeSetUp.fname_nc_season;
fname_nc=TreeSetUp.fname_nc;

tree_prefix=TreeSetUp.tree_prefix;
tree_model_file_name_season=TreeSetUp.tree_model_file_name_season;
tree_model_file_name_yearly=TreeSetUp.tree_model_file_name_yearly;
tree_model_file_name_all_year=TreeSetUp.tree_model_file_name_all_year;
tree_model_file_name_combined=TreeSetUp.tree_model_file_name_combined;
% 
% file_name_season=[file_name,'_seasonal'];
% file_name_season_anom=[file_name_season,'_anom'];

path_oisst=TreeSetUp.path_oisst;
path_OHCA_data_out=TreeSetUp.path_OHCA_data_out;
path_OHCA_data_in=TreeSetUp.path_OHCA_data_in;
path_ssh=TreeSetUp.path_ssh;

path_tree=TreeSetUp.path_tree;
path_new_tree_season=TreeSetUp.path_new_tree_season;
path_new_tree_yearly=TreeSetUp.path_new_tree_yearly;
path_new_tree_all_year=TreeSetUp.path_new_tree_all_year;

path_tree_junk=TreeSetUp.path_tree_junk;
path_tree_junk2=TreeSetUp.path_tree_junk2;
path_curve=TreeSetUp.path_curve;

layer_bounds=TreeSetUp.layer_bounds;
ilayer_depth_use_sst=TreeSetUp.ilayer_depth_use_sst;

ilayer_depth_use_ssh=TreeSetUp.ilayer_depth_use_ssh;


start_year=TreeSetUp.start_year;
end_year=TreeSetUp.end_year;

start_year_mean=TreeSetUp.start_year_mean;
end_year_mean=TreeSetUp.end_year_mean;
max_year_fit=TreeSetUp.max_year_fit;
min_year_fit=TreeSetUp.min_year_fit;
center_year=TreeSetUp.center_year;

start_yearly_maps=TreeSetUp.start_yearly_maps;
end_yearly_maps=TreeSetUp.end_yearly_maps;

sal_yearly_year_junk2=TreeSetUp.sal_yearly_year_junk2;

start_all_year=TreeSetUp.start_all_year;
end_all_year=TreeSetUp.end_all_year;

start_year_trans=TreeSetUp.start_year_trans;
end_year_trans=TreeSetUp.end_year_trans;


path_tree_junk1=path_tree_junk;

% this file is necessary to download seasonal data

tree_model_file_name=tree_model_file_name_yearly;
path_new_tree=path_new_tree_yearly;


% max_year=2019;
% min_year=2005;
% center_year=(max_year+min_year)./2;

 nlayer=length(layer_bounds);



parfor ilayer=2:nlayer
    
    
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
    layer_title=[num2str(layer_bounds(ilayer-1)),'m to ',num2str(layer_bounds(ilayer)),'m'];
    filejunk=[path_tree_junk2,tree_model_file_name,'_model_a_',layer_name,'_junk.mat'];
    TreeJunk=[];

    for iyear_mod=start_yearly_maps:.5:end_yearly_maps
    
        year_file_name=num2str(10*iyear_mod);
        
        
        
        iyear=(iyear_mod-start_yearly_maps)*2+1;
        
        % because of space I needed to save all the yearly model
                if iyear_mod <= sal_yearly_year_junk2
                    path_tree_junk=path_tree_junk1;
                else
                     path_tree_junk=path_tree_junk2;
                end
        
        
        file_big_model=[path_tree_junk,tree_model_file_name,'_model_a_',layer_name,'_',year_file_name,'_split.mat'];
       
        %     load(file_big_model,'model_all')
        model_all=parload_model(file_big_model);
        
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

                if ilayer==2
                    PredictorNames={'Year' 'Lon' 'Lat' 'SSH' 'Temp'};
                
                elseif ilayer<=ilayer_depth_use_ssh
                      PredictorNames={'Year' 'Lon' 'Lat' 'SSH' 'Sal_layerup' 'Temp'};
                else
                    PredictorNames={'Year' 'Lon' 'Lat' 'Sal_layerup' 'Temp'};
                end
               %             h.XTickLabel =PredictorNames;
                %             h.XTickLabelRotation = 45;
                %             h.TickLabelInterpreter = 'none';
                % %             title([layer_title,' ',model_all(ibasin).name])
                
                TreeJunk(ibasin,iyear).PredictorNames=PredictorNames;
                TreeJunk(ibasin,iyear).PredictorImpotance=imp;
                TreeJunk(ibasin,iyear).oobError=oobErrorBaggedEnsemble;
                TreeJunk(ibasin,iyear).LayerName=layer_name;
                TreeJunk(ibasin,iyear).LayerTitle=layer_title;
                TreeJunk(ibasin,iyear).BasinName=model_all(ibasin).name;
            
            
            end
        end
    end
        parsave_stats(filejunk,TreeJunk)

    
end
            

  
    
  





for ilayer=2:nlayer

    
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
    filejunk=[path_tree_junk2,tree_model_file_name,'_model_a_',layer_name,'_junk.mat'];
    TreeJunk=parload_stats(filejunk);
    [nbasin,~]=size(TreeJunk);
    for iyear_mod=start_yearly_maps:.5:end_yearly_maps
        iyear=(iyear_mod-start_yearly_maps)*2+1;
        for ibasin=1:nbasin
                    TreeStats(ibasin,ilayer-1,iyear).PredictorNames=TreeJunk(ibasin,iyear).PredictorNames;
                    TreeStats(ibasin,ilayer-1,iyear).PredictorImpotance=TreeJunk(ibasin,iyear).PredictorImpotance;
                    TreeStats(ibasin,ilayer-1,iyear).oobError=TreeJunk(ibasin,iyear).oobError;
                    TreeStats(ibasin,ilayer-1,iyear).LayerName=TreeJunk(ibasin,iyear).LayerName;
                    TreeStats(ibasin,ilayer-1,iyear).LayerTitle=TreeJunk(ibasin,iyear).LayerTitle;
                    TreeStats(ibasin,ilayer-1,iyear).BasinName=TreeJunk(ibasin,iyear).BasinName;
        end
        
    end
      pardelete_stats(filejunk)
end

file_stats=[path_new_tree,tree_model_file_name,'_all_stats_split_a.mat'];
save(file_stats,'TreeStats')

end


function [model_all]=parload_model(filename)
    
    load(filename,'model_all')     
end
function parsave_stats(filename,TreeJunk)

    save(filename,'TreeJunk')
end
function [TreeJunk]=parload_stats(filename)
    
    load(filename,'TreeJunk')     
end
function pardelete_stats(filename)

         delete(filename)
end

