function [tgrid,tgrid_annual,ht_curve,ht_no_cycle,ht_curve_annual,std_ht_annual]=load_tree_ohca_nocycle(TreeSetUp,min_depth,max_depth)
% min_depth=0;
% max_depth=700;
OUTOUT_type=TreeSetUp.OUTOUT_type;
path_Fig_data=TreeSetUp.path_Fig_data;
tree_prefix=TreeSetUp.tree_prefix;

depth_range_name=[num2str(min_depth),'_',num2str(max_depth)];

curve_name=['curve_',tree_prefix,'_',depth_range_name,'_ohca_nomean_',OUTOUT_type,'.mat'];
% map_name=['map_',tree_prefix,'_',depth_range_name,'_ohca_nomean_',OUTOUT_type,'.mat'];

load ([path_Fig_data,curve_name], 'tgrid', 'ht_curve')

good_all=find(tgrid>=2005& tgrid<=max(floor(tgrid)-1));% compute the annual cycle over the argo period not including last year
%  good_all=find(tgrid>=1993 & tgrid<=2005);% compute the annual cycle over the argo period not including last year
 
 ht_cycle=double(ht_curve(good_all));
 tgrid_cycle=double(tgrid(good_all));





[model_tree_all,~,~,~,~,~,~,slope_tree_all,mean_tree_all,~]=...
    j_fit_annual_tree(tgrid_cycle,ht_cycle',tgrid);
% [model_tree_all,amp_annual,phase_annual,amp_semi,phase_semi,amp_third,phase_third,slope_tree_all,mean_tree_all,model_err]=...
%     j_fit_annual_tree(time_tree_all_cycle,ht_tree_all_cycle');

ht_res=ht_curve-model_tree_all';




ht_no_cycle=ht_res'+(tgrid).*slope_tree_all'+mean_tree_all;

tgrid_annual=(floor(min(tgrid)):floor(max(tgrid)))+.5;
std_ht_annual=zeros(size(tgrid_annual));
ht_curve_annual=std_ht_annual;
ipos=0;
for itgrid=tgrid_annual
    ipos=ipos+1;
    good=floor(tgrid)==floor(itgrid);
    ht_junk=ht_res(good);
    tgrid_junk=tgrid(good);

    % fit a line to the year to get rid pof increasing slope biases in the
    % error
    [y_model_junk,~,~,~]=j_fit_90(tgrid_junk,ht_junk',1);


    std_ht_annual(ipos)=std(ht_junk-y_model_junk');
    ht_curve_annual(ipos)=mean(ht_no_cycle(good));

end


