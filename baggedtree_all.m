tree_model_file_name='baggedtree_sst_tpx_all2_year';
path_OHCA_data_out='C:\data\OHCA\'
file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
path_tree=[path_OHCA_data_out,'OHCA_trees\'];
load('C:\Users\jlyma\OneDrive - University of Hawaii\Documents\MATLAB\hdata_new_layers__ishii_EN3_2014_argo_2020_1_05_QC_sst.mat')

 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
 model_names=[];
 nlayer=length(layer_bounds);
for ilayer=2:nlayer
    layer_bounds(ilayer)
    tic
    eval(['ht_use=ht_',num2str(layer_bounds(ilayer-1)),'_',...
             num2str(layer_bounds(ilayer)),';'])
         
    
    %test_tree_2
    test_tree_year
    
    eval(['Model_',num2str(layer_bounds(ilayer-1)),'_',...
             num2str(layer_bounds(ilayer)),'=model_all;'])

    model_names=[model_names,' ','Model_',num2str(layer_bounds(ilayer-1)),'_',...
             num2str(layer_bounds(ilayer))];
   toc
end

eval(['save ',path_tree,tree_model_file_name,'.mat -v7.3',model_names]) 



% save a compact version of the same model
nbasin=9;


model_names_compact=[];

for ilayer=2:nlayer
% for ilayer=8:nlayer
    
    
    Input_model=['Model_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
    Input_model_compact=['CModel_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
    model_names_compact=[model_names_compact,' ','CModel_',num2str(layer_bounds(ilayer-1)),'_',...
             num2str(layer_bounds(ilayer))];
    

    
   
   
    for ibasin=1:nbasin
        eval([Input_model_compact,'(ibasin).name=',Input_model,'(ibasin).name;']);
        eval([Input_model_compact,'(ibasin).model=compact(',Input_model,'(ibasin).model);']);
    
    end

    
end
eval(['save ',path_tree,tree_model_file_name,'_compact.mat ',model_names_compact]);