load('C:\Users\jlyma\OneDrive_UH\Documents\MATLAB\hdata_new_layers__ishii_EN3_2014_argo_2020_1_05_QC_sst.mat')
var_names=cell(1,6);
var_names{1}='ht';
var_names{2}='lon';
var_names{3}='lat';
var_names{4}='time';
var_names{5}='ssh';
var_names{6}='sst';
global_basins=find_basin_paige(coords(:,1),coords(:,2));
tic
model_leaf='ht ~ ssh + sst';
predict_name={'lon','lat','time'};
ht_use=ht_0_40;
paroptions = statset('UseParallel',true);
good_yr=(floor(yr)>=2010 & isfinite(ht_use));
nbasins=length(global_basins);

for ibasin=1:nbasins-1 
       junk_pos=global_basins(ibasin).pos;
       good=good_yr & junk_pos;


ht_use_table=table(ht_use(good)./max(ht_use(good)),yr(good)-floor(yr(good)),coords(good,1),coords(good,2),tpx(good)./max(tpx(good)),sst(good)./max(sst(good)),'VariableNames',var_names);
    m=TreeBagger(30,ht_use_table,'ht','Method','regression','MinLeafSize',10,...
        'OOBPrediction','on','PredictorSelection','curvature','OOBPredictorImportance','on',...
         'Options',paroptions);
    %         'PredictorNames',predict_name);
toc
     model_all(ibasin).name=global_basins(ibasin).name
     model_all(ibasin).model=m;

      oobErrorBaggedEnsemble = oobError(m);
    plot(oobErrorBaggedEnsemble)
    xlabel 'Number of grown trees';
    ylabel 'Out-of-bag classification error';
    
    
    
    mCART = m.OOBPermutedPredictorDeltaError;
    
    figure;
    bar(mCART);
    title([global_basins(ibasin).name,': Curvature CART']);
    ylabel('Predictor importance estimates');
    xlabel('Predictors');
    h = gca;
    h.XTickLabel = m.PredictorNames;
    h.XTickLabelRotation = 45;
    h.TickLabelInterpreter = 'none';

    oobErrorBaggedEnsemble = oobError(m);
plot(oobErrorBaggedEnsemble)
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';
  title([global_basins(ibasin).name])
   
end
%     view(m.Trees{1},'mode','graph');
   save 'test_tree_model' model_all