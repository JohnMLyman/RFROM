function [ct_mod_coeffs,ct_res_std]=fit_trend_layer(TreeSetUp,ilayer)

% ilayer=1;
[~,~,~,tim,ct]=load_netcdf_temp_depth(ilayer,TreeSetUp);




jul=datenum(1950,1,1); % julian days at 1 Jan 1950
greg=datevec(jul+double(tim)); % get gregorian days
dyr=decyear(greg(:,1),greg(:,2),greg(:,3)); % change to decimal years



 
clear dd jul greg q ii

mid_year=2008.5;
mid_year=2009;
mid_year=(max(dyr)+min(dyr))./2;
[m,n,p]=size(ct);



ct_mod_coeffs=nan(m,n,13);
ct_res_std=nan(m,n);
% % % 
% % % ct_res=NaN*ct;




% % % ct_res_std=NaN*ones(m,n);




 parfor i1=1:m
%     for i1=1:m

    for i2=1:n
%         surf_area(:,i2)=dist([lat(i2) lat(i2)],[-0.5 0.5])*dist([lat(i2)-0.5,lat(i2)+0.5],[0 0]);

            ct_temp=squeeze(ct(i1,i2,:));
           
            ii=find(isfinite(ct_temp));
           
            if length(ii)>=.85*p
                [mod_temp,res_temp]=fit_trend_seasonal_cycle(dyr(ii),ct_temp(ii),2,mid_year);
                ct_mod_coeffs(i1,i2,:)=mod_temp;
                ct_res_std(i1,i2)=std(res_temp);
                
            end

    end
   
   
end
end
