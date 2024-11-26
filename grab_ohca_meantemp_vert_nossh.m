function [ohca,depth]=grab_ohca_meantemp_vert_nossh(year_grab)

tic
pathvert='J:\tree_temp_vert_nossh\t_trees\tree_temp_vert_nossh_yearly_overlap_seasonal\';

 layer_bounds=[0, 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125,...
    135, 145, 155, 165, 175, 190, 210, 230, 250, 270, 290, 310, 330 , ...
    350, 370 , 390, 410,  430, 450, 475, 525, 575, 625, 675, 725, 775,...
    825, 875, 925, 975, 1025, 1075, 1125, 1175, 1225, 1275, 1325, 1375,...
    1450, 1550, 1650, 1750, 1850, 1950, 2000];% layer_bounds must be in assending order
depth=(layer_bounds(1:end-1)+layer_bounds(2:end))./2;
nlayers=length(layer_bounds);
ohca=[];
 for ilayer=2:nlayers
      layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
      load([pathvert,'tree_temp_vert_nossh_yearly_overlap_seasonal_',layer_name,'_',num2str(year_grab),'_split_7day.mat'],'ht_estimate_year')
      ohca=cat(4,ohca,ht_estimate_year);
 end
toc./60