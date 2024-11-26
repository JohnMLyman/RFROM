% this code plots the data in a squarrrre and fits it year by year ment to
% be run with mapdiff_with_error (inside the loop!)

w=unique(wnum);
for i=163 :length(w)
  ii=find(w(i)==wnum&~isnan(tpx+htanom));


figure(10)
hold off
clf
m_ungrid m_proj;
m_proj('Equidistant Cylindrical','long',[30 390],'lat',[-90 90]);
 m_coast;
 m_grid;
 hold on
m_plot(cds(ii,1),cds(ii,2),'.r')

m_plot(cds(ii,1)+360,cds(ii,2),'.r')
hold off
lon=cds(ii,1);
lat=cds(ii,2);

year=dt(ii,1);

year_u=unique(year);

t=tpx(ii);
y=htanom(ii);



for iyear=1:length(year_u)
 
slope=nan;slope_error=nan;  
    jj=find(year_u(iyear) == year & ~isnan(t+y));
    tj=t(jj);
    yj=y(jj);
    length(jj)
if length(jj) >= 20 
    [y_model,y_model_err_95,slope_error,slope]=j_fit_alpha_remove_std(tj',yj');
    
    slope_t(iyear)=slope;
    slope_error_t(iyear)=slope_error;
% plot resuts
end

figure(8)

 lonj=lon(jj);
 latj=lat(jj);
plot(lonj,latj,'.')



%  plot(tj,yj,'r.',tj,y_model,'b-',tj,y_model+y_model_err_95,'m--',tj,y_model- y_model_err_95,'m--')

end


figure(20)

if exist('slope_t','var') 
    clf
    slope_error_t(find(slope_error_t == 0))=nan
    slope_t(find(slope_t == 0))=nan
    e=errorbar(slope_t,slope_error_t,'k')
    hold on 
     slope2=(1./(slope_error_t)).*slope_t;
    ns=length(find(finite(slope2) == 1));
    sm=nansum(slope2)/nansum((1)./(slope_error_t));
    slope_error_new=sqrt(nansum(((slope_t-sm)./slope_error_t).^2)/(nansum(1./slope_error_t.^2)))

    [y_modeltt,y_model_err_95tt,slope_errortt,slopett]=j_fit_alpha_remove_std(t',y');
    
    slope_error_new
    slope_errortt
    pause
    hold off
    clear slope_t slope_error_t
end
end

