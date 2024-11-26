nlayrs=length(layer_bounds);
ilayer=2;
sname=['sal_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'_wod'];
s=eval(['size(',sname,');']);

SAL_wod=nans(s(1),nlayrs-1);
TEMP_wod=SAL_wod;

pres=.5*(layer_bounds(1:end-1)+layer_bounds(2:end));

for ilayer=2:nlayrs
    sname=['sal_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'_wod'];
    tname=['temp_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'_wod'];
    SAL_wod(:,ilayer-1)=eval(sname);
    TEMP_wod(:,ilayer-1)=eval(tname);

end