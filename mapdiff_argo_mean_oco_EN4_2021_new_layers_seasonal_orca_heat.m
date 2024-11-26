function mapdiff_argo_mean_oco_EN4_2021_new_layers_seasonal_orca_heat(OcoSetUp)

%%

file_path_out=OcoSetUp.file_path_out;

file_path_hdata=OcoSetUp.file_path_hdata;

file_WOD_suf=OcoSetUp.file_WOD_suf; 

h_var_name=OcoSetUp.h_var_name;

file_name_season=OcoSetUp.file_name_season;

%%

eval(['load ',file_path_out,'allheat_new_layers_argo_WOD_new_',file_name_season,...
   h_var_name,...
    'cds dt argo_delayed_mode argo_float_id mdep wod_oclnum topex'])%

   



% comput wnum which are 10x10 degree boxes over which the alphas are
% computed.
 
% calculate appropriate square for given lat and lon
iii=find(cds(:,1)<=0&cds(:,2)>0);
jjj=find(cds(:,1)>0 &cds(:,2)>0);
lll=find(cds(:,1)<=0&cds(:,2)<=0);
nnn=find(cds(:,1)>0 &cds(:,2)<=0);
wnum(iii)=abs(ceil(cds(iii,1)/10))+100*(ceil(cds(iii,2)/10)-1)+7000;
wnum(jjj)=ceil(cds(jjj,1)/10)-1+100*(ceil(cds(jjj,2)/10)-1)+1000;
wnum(lll)=abs(ceil(cds(lll,1)/10))+100*abs(ceil(cds(lll,2)/10))+5000;
wnum(nnn)=ceil(cds(nnn,1)/10)-1+100*abs(ceil(cds(nnn,2)/10))+3000;



% compute the alphas for each month


% for ilayer=2:length(layer_bounds)
% 
%      eval(['hctpx_',num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),'=',...
%          't_',num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),'*NaN;'])
% end
 


tpx=topex(:,1);
% tpx(isnan(tpx))=0;

% compute alpha for all times over the time period of the mean
% 
% good_time=find(dt(:,1) >=min_year_mean & dt(:,1)<= max_year_mean);


%     [alat,alon,alpha_0_40,c_0_40,xvar_0_40]=compute_alpha(t_0_40(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
%     eval(['save ',file_path_out,'hregress_0_40_2 alpha_0_40 c_0_40 xvar_0_40 alat alon']);
    
% for ilayer=2:length(layer_bounds)
%      eval(['t_junk=',...
%         't_',num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),';'])
%      
%      
%      
%      [alat,alon,alpha_junk,c_junk,xvar_junk]=compute_alpha(t_junk(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
%      
%      
%      eval(['alpha_',num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),...
%          '=alpha_junk;'])
%      eval(['c_',num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),...
%          '=c_junk;'])
%      eval(['xvar_',num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),...
%          '=xvar_junk;'])
%      
%      junk_name_hregress=['hregress_',file_name_season,'_',...
%          num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),...
%          ' alpha_',num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),...
%          ' c_',num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),...
%          ' xvar_',num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),' '];
%      
%      eval(['save ',file_path_out,junk_name_hregress,' alat alon']);
%      
%     
% end


    
    
  
    
%     for ilayer=2:length(layer_bounds)
% 
%      eval(['hctpx_',num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),'=',...
%          'tpx.*interp2(alat,alon,alpha_',...
%          num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),...
%          ',cds(:,2),cds(:,1));'])
%      end
 

%     for ilayer=2:length(layer_bounds)
% 
%      eval(['tdiff',num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),'=',...
%          't_',...
%          num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),...
%          '-hctpx_',num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),';'])
%      end
 

    
    

% time is not saved so set it to 0
tm=dt(:,1).*0;
day=datenum([dt,tm,tm*0,tm*0])-datenum(1950,1,1);

% yr=(day-datenum(1992,1,1)+datenum(1950,1,1))/365.25+1992;
yr=decyear(dt);
% make files for gridding 

fname_nc=[file_path_hdata,'hdata_new_layers_',file_WOD_suf,'_',file_name_season];
    
    
coords = cds;

% 
% eval(['save ',fname_nc,' tpx yr coords ',...
%     tdiffvar_name, t_var_name])
eval(['save ',fname_nc,' tpx yr coords ',...
     h_var_name])
