load('C:\Users\jlyma\OneDrive - University of Hawaii\Documents\MATLAB\hdata_new_layers__ishii_EN3_2014_argo_2020_1_05_QC_sst.mat')
var_names=cell(1,6);
var_names{1}='ht';
var_names{2}='lon';
var_names{3}='lat';
var_names{4}='time';
var_names{5}='ssh';
var_names{6}='sst';

model_leaf='ht ~ ssh + sst';
 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];

for ilayer=2:length(layer_bounds)
    
    eval(['ht_use=ht_',num2str(layer_bounds(ilayer-1)),'_',...
             num2str(layer_bounds(ilayer)),';'])
         
    
    
    
    good=find(floor(yr)>=1990 & isfinite(ht_use));
%     good_old=find(floor(yr)==2010 & isfinite(ht_use));
%     ht_use_table_old=table(ht_use(good_old)./max(ht_use(good_old)),yr(good_old)-floor(yr(good_old)),coords(good_old,1),coords(good_old,2),tpx(good_old)./max(tpx(good_old)),sst(good_old)./max(sst(good_old)),'VariableNames',var_names);
    
    ht_use_table=table(ht_use(good)./max(ht_use(good)),yr(good)-floor(yr(good)),coords(good,1),coords(good,2),tpx(good)./max(tpx(good)),sst(good)./max(sst(good)),'VariableNames',var_names);
    m=TreeBagger(30,ht_use_table,'ht','Method','regression','MinLeafSize',100,...
        'OOBPrediction','on','PredictorSelection','curvature','OOBPredictorImportance','on');
    % % view(m.Trees{1},'mode','graph');
    oobErrorBaggedEnsemble = oobError(m);
    plot(oobErrorBaggedEnsemble)
    xlabel 'Number of grown trees';
    ylabel 'Out-of-bag classification error';
    
    
    
    mCART = m.OOBPermutedPredictorDeltaError;
    
    figure;
    bar(mCART);
    title('Curvature CART');
    ylabel('Predictor importance estimates');
    xlabel('Predictors');
    h = gca;
    h.XTickLabel = m.PredictorNames;
    h.XTickLabelRotation = 45;
    h.TickLabelInterpreter = 'none';
    eval(['m_',num2str(layer_bounds(ilayer-1)),'_',...
             num2str(layer_bounds(ilayer)),'=m;'])

end
save 'baggedtree_sst_tpx.mat' 
% htfit = predict(m,ht_use_table_old);