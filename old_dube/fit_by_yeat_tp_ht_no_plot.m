% this code plots the data in a squarrrre and fits it year by year ment to
% be run with mapdiff_with_error (inside the loop!)



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





%  plot(tj,yj,'r.',tj,y_model,'b-',tj,y_model+y_model_err_95,'m--',tj,y_model- y_model_err_95,'m--')

end


slope_error_new=nan;
if exist('slope_t','var') 
    
   slope_error_t(find(slope_error_t == 0))=nan
    slope_t(find(slope_t == 0))=nan
%     e=errorbar(slope_t,slope_error_t,'k')
%     hold on 
     slope2=(1./(slope_error_t)).*slope_t;
    ns=length(find(finite(slope2) == 1));
    sm=nansum(slope2)/nansum((1)./(slope_error_t));
    slope_error_new=sqrt(nansum(((slope_t-sm)./slope_error_t).^2)/(nansum(1./slope_error_t.^2)))

    [y_modeltt,y_model_err_95tt,slope_errortt,slopett]=j_fit_alpha_remove_std(t',y');
    
     clear slope_t slope_error_t
end    
