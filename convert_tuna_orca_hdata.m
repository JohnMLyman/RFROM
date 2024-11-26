function []=convert_tuna_orca_hdata(TreeSetUp)
%%
fname_nc_season_old=TreeSetUp.fname_nc_season_old;
fname_nc_season=TreeSetUp.fname_nc_season;
layer_bounds=TreeSetUp.layer_bounds;
var_type=TreeSetUp.var_type;

nlayer=length(layer_bounds);

varinfo=who('-file',fname_nc_season_old);
varnames_extra=[];
varnames_ht=[];
varnames_h=[];
for iname=1:length(varinfo)
    junk_name=varinfo{iname};
    if ~contains(junk_name,'diff') 
        if ~contains(junk_name,'ht_')
            varnames_extra=[varnames_extra,junk_name,' '];
        else
            varnames_ht=[varnames_ht,junk_name,' '];
            varnames_h=[varnames_h,'h',junk_name(3:end),' '];
        end

    end


end

eval(['load ',fname_nc_season_old,' ',varnames_extra,' ',varnames_ht])





for ilayer=2:nlayer
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
    
 

    eval([var_type,'_',layer_name,'=ht_',layer_name,';'])

    

end



eval(['save ',fname_nc_season,' ',varnames_h,' ',varnames_extra,'-v7.3'])



