nlayrs=length(layer_bounds);
ilayer=2;
sname=['s_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
s=eval(['size(',sname,');']);

SAL_argo=nans(s(1),nlayrs-1);
TEMP_argo=SAL_argo;

pres=.5*(layer_bounds(1:end-1)+layer_bounds(2:end));

for ilayer=2:nlayrs
    sname=['s_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
    tname=['t_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
    SAL_argo(:,ilayer-1)=eval(sname);
    TEMP_argo(:,ilayer-1)=eval(tname);

end