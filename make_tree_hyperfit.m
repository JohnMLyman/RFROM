mycor=[228,26,28 
    55,126,184
    77,175,74
    152,78,163
    255,127,0
    55,78,0]./255;
% path_model='C:\Users\jlyma\OneDrive - University of Hawaii\data\OHCA\OHCA_trees\tree_sst_tpx_yearly_overlap_seasonal_anom\'
path_model='E:\data\OHCA\tree_sst_tpx_atlatic_yearly_overlap_seasonal_anom\';
layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
nlayer=length(layer_bounds);

figure(1)
clf;orient landscape; wysiwyg_tuna

for i=[5]
for ileaf=[5 10 15 20]
    error_all=zeros(30,1);
     for ilayer=2:nlayer
        layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
        
    load([path_model,'tree_sst_tpx_atlatic_yearly_overlap_seasonal_anom_model_',layer_name,'_20185_leaf',...
        num2str(ileaf),'_split.mat'])
       M1=model_all(i).model;
       error_all=oobError(M1)+error_all;
       if ilayer==7
           error_0_700=error_all;

       end
     end
       error_0_2000=error_all;
       eval(['error_',num2str(ileaf),'_0_2000=error_0_2000;'])
       eval(['error_',num2str(ileaf),'_0_700=error_0_700;'])




plot((error_0_2000),'color',mycor(ileaf/5,:),'LineWidth',1.25)
 

hold on
end
end
% save([path_model,'leaf_tree_error_atlatic_yearly_20085.mat'],'error_5_0_2000',...
%    'error_10_0_2000','error_15_0_2000','error_20_0_2000','error_5_0_700',...
%    'error_10_0_700','error_15_0_700','error_20_0_700' )
% % plot(oobError(M1))


legend_a=legend('5','10','15','20');
legend('boxoff');
  title(legend_a,'Leaf Size')
  set(legend_a,'Position',[.55 .55 .2 .2])

xlabel("Number of Grown Trees",'Fontsize',10,'Fontname','Arial')
ylabel("Cumulative Mean Out-of-Bag Error [J m^{-2}]^{2}",'Fontsize',10,'Fontname','Arial')

path_figs='C:\data\OHCA\figs\tree_paper\'
 eval(['print -dpng -r600 -f1 ',path_figs,'hyper_fit_atl_leaf'])
