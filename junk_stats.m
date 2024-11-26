
% load('L:\NCAR\tree_heat_novert_paige\h_trees\tree_heat_novert_paige_all_year_seasonal\tree_heat_novert_paige_all_year_seasonal_all_stats_split_a.mat')
% 
% TreeStats_season=TreeStats;
% load('L:\NCAR\tree_heat_novert_paige\h_trees\tree_heat_novert_paige_all_year_seasonal_anom\tree_heat_novert_paige_all_year_seasonal_anom_all_stats_split_a.mat')

figure

for ilayer=1:10
    for ibasin=1:9
         clf
        plot(TreeStats(ibasin,ilayer).PredictorImpotance,'ko')
        hold on
         plot(TreeStats_season(ibasin,ilayer).PredictorImpotance,'ro')

        TreeStats(ibasin,ilayer).BasinName

        ilayer
        pause
    end

    pause
    clf
end
