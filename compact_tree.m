tic
file_name='argo_2020_10_14_QC';
tree_model_file_name='baggedtree_sst_tpx_all2_year';
path_oisst='C:\data\oisst\';
file_name_argo='pfloat_sal_greg_oct_2021_QC'
path_OHCA_data_out='C:\data\OHCA\'
path_OHCA_data_in='C:\OHCA\'

 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
file_name='argo_2020_10_14_QC';
path_tree=[path_OHCA_data_out,'OHCA_trees\'];

file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
path_ssh=[path_OHCA_data_in,'Mtpers\'];


% eval(['load ',path_tree,tree_model_file_name,'.mat ']);
nbasin=9;
nlayer=length(layer_bounds);
model_names_compact=[];
for ilayer=2:nlayer
% for ilayer=8:nlayer
    
    
    Input_model=['Model_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
    Input_model_compact=['CModel_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
    model_names_compact=[model_names_compact,' ','CModel_',num2str(layer_bounds(ilayer-1)),'_',...
             num2str(layer_bounds(ilayer))];
   
    

    
   
   
    for ibasin=1:nbasin
        eval(['M=',Input_model,'(ibasin).model;'])
        eval([Input_model_compact,'(ibasin).name=',Input_model,'(ibasin).name;']);
        if ~isempty(M)

        
        eval([Input_model_compact,'(ibasin).model=compact(M);']);
        else
            ibasin
            'bad'
        end
    end

    
end
eval(['save ',path_tree,tree_model_file_name,'_compact2.mat ',model_names_compact]);