clear
close all
TreeSetUp=TreeSetUp_2024_orca_temp_press_novert_paige_sulu;
% ilayer=1;
[lon,lat,~,tim,~]=load_netcdf_temp_depth(ilayer,TreeSetUp);



i1=find(lon>30);
i2=find(lon<30);
lon=[lon(i1);lon(i2)+360];

ct=cat(1,ct(i1,:,:),ct(i2,:,:));



jul=julian(1950,1,1,0); % julian days at 1 Jan 1950
greg=gregorian(jul+tim); % get gregorian days
dyr=decyear(greg(:,1),greg(:,2),greg(:,3),greg(:,4)); % change to decimal years


dprs=[5,10+0*[1:17],15,20+0*[19:31],25,50+0*[33:50],75,100+0*[52:56],50];
 
clear dd jul greg q ii

mid_year=2008.5;

[m,n,p]=size(ct);
o=length(dprs);

% maxlag=48;
ct_mod_coeffs=NaN*ones(m,n,o,13);
% sa_mod_coeffs=ct_mod_coeffs;
ct_res=NaN*ct;
% sa_res=ct_res;

% sa_mod_coeffs2=ct_mod_coeffs;
% sa_res2=ct_res;

% ct_cor_max_ub=NaN*ones(m,n,o);
% ct_cor_lag_ub=ct_cor_max_ub;
% ct_cor_max_co=ct_cor_max_ub;
% ct_cor_lag_co=ct_cor_max_ub;
% ct_cor_ub=NaN*ones(m,n,o,maxlag*2+1);
% ct_cor_co=ct_cor_ub;

ct_res_std=NaN*ones(m,n,o);
% sa_res_std=ct_res_std;
% sa_res_std2=ct_res_std;


surf_area=ones(360,1)*cosd(lat)'*dist([-0.5 0.5],[0 0])*dist([0 0],[-.5 .5]);


tic
for i1=1:m
    for i2=1:n
        surf_area(:,i2)=dist([lat(i2) lat(i2)],[-0.5 0.5])*dist([lat(i2)-0.5,lat(i2)+0.5],[0 0]);
        for i3=1:o
            ct_temp=squeeze(ct(i1,i2,i3,:));
            % sa_temp=squeeze(sa(i1,i2,i3,:));
            % sa_temp2=squeeze(sa2(i1,i2,i3,:));
            ii=find(isfinite(ct_temp)==1);
            % if length(ii)>50
            if length(ii)==p
                [mod_temp,res_temp]=fit_trend_seasonal_cycle(dyr(ii),ct_temp(ii),2,mid_year);
                ct_mod_coeffs(i1,i2,i3,:)=mod_temp;
                ct_res(i1,i2,i3,ii)=res_temp;
                % [mod_temp,res_temp]=fit_trend_seasonal_cycle(dyr(ii),sa_temp(ii),2,mid_year);
                % sa_mod_coeffs(i1,i2,i3,:)=mod_temp;
                % sa_res(i1,i2,i3,ii)=res_temp;
                % [mod_temp,res_temp]=fit_trend_seasonal_cycle(dyr(ii),sa_temp2(ii),2,mid_year);
                % sa_mod_coeffs2(i1,i2,i3,:)=mod_temp;
                % sa_res2(i1,i2,i3,ii)=res_temp;      
                % ct_res_std(i1,i2,i3)=std(res_temp);
                % [cor_ub,lag_ub]= xcorr(oni(ii),res_temp,maxlag,'unbiased');
                % [cor_co,lag_co]= xcorr(oni(ii),res_temp,maxlag,'coeff');
                % jj=find(abs(cor_ub)==max(abs(cor_ub)));
                % ct_cor_lag_ub(i1,i2,i3)=lag_ub(jj(1));
                % ct_cor_max_ub(i1,i2,i3)=cor_ub(jj(1));
                % ct_cor_lag_co(i1,i2,i3)=lag_co(jj(1));
                % ct_cor_max_co(i1,i2,i3)=cor_co(jj(1));
                % ct_cor_ub(i1,i2,i3,:)=cor_ub;
                % ct_cor_co(i1,i2,i3,:)=cor_co;
                % % ct_cor(i1,i2,i3,:)=cor;
            end
        end
    end
    disp(i1)
    toc
end

