%load alllheat

for iyear=1970:2005
    
    ii=find(dt(:,1) == iyear);
    
    
figure(1) 
m_ungrid m_proj;
m_proj('Equidistant Cylindrical','long',[30 390],'lat',[-90 90]);
 m_coast;
 m_grid;
 hold on
m_plot(cds(ii,1),cds(ii,2),'.r')

m_plot(cds(ii,1)+360,cds(ii,2),'.r')
hold off

 title(num2str(iyear))

pause
close all


    
end


