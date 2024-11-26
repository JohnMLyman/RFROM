% qc2.m - matlab file to do initial QC pass on d????.mat files
% after they have been consolidated by remdups.m and toss.m has been run
% 2/25/03

% round 2 is done by checking first derivative on scales of 20 m and
% less.  below 120m


cd './All_Data'
d=dir('d*.mat');[dd,ii]=sortrows(strvcat(d(:).name));
d=d(ii);clear dd ii

% loop through files and perform qc
tic,for i=1:length(d)
  load(d(i).name);
  len(i)=size(temp,1);

  % derivative test
  tpp=temp(:,11:end)-temp(:,1:end-10);
  tpp=tpp-repmat(nanmean(tpp),[size(tpp,1),1]);  
  tmpp=tpp;tmpp(tpp>0)=NaN;tl=sqrt(nanmean(tmpp.^2))*-8.5;
  tmpp=tpp;tmpp(tpp<0)=NaN;tu=sqrt(nanmean(tmpp.^2))*8.5;  
  ind=tpp>repmat(tu,[size(temp,1),1])|tpp<repmat(tl,[size(temp,1),1]);
  ii=find(sum(ind(:,61:end)')');  clear ind tmpp
  % ii are indicies thrown out by derivative test

  % standard deviation test
  td=4.2*nanstd(temp);tm=nanmean(temp);
  ind2=abs(temp-repmat(nanmean(temp),[size(temp,1),1]))> ...
	repmat(td,[size(temp,1),1]);
  jj=find(sum(ind2(:,201:end)')');
  % jj are indicies thrown out by std test

  % take care of special cases
  switch str2num(d(i).name(2:5))
    % lots of files don't need the 4 std test, so these are excluded here
    case num2cell([1301:1303,1312,1413,1414,1700,1717,3012,5001, ...
		   5207,7117,7305,7600,7603,7605,7700])
        jj=[];
    % a few files don't need the derivative test either
    case num2cell([1000,1203,3000,3009,5012,5314])
        ii=[];jj=[];
    % kill 1 bad prof.
    case 1010
	jj=[jj;find(temp(:,293)<6.4)];
    % kill 1 bad prof.
    case 1013
	jj=[jj;find(temp(:,26)<18.4)];
    % kill a few bad prof.
    case {1015,1016,1105,1106}
	jj=[jj;find(min(temp(:,1:36)')'<13)];
    % kill 1 bad prof.
    case 1112
	jj=[jj;find(temp(:,186)>19)];
    % kill a few bad prof.
    case {1113,1114,1115}
	jj=[jj;find(max(temp')'>32|min(temp(:,1:26)')'<22)];
    % fix up 1205
    case 1205
        ii=[];jj=find(min(temp(:,1:56)')'<15);
    % get rid of std check, keep diff check and throw out 1 bad prof.
    case num2cell([1212:1216])
	jj=find(min(temp(:,1:56)')'<15);
    % get rid of std check, keep diff check and throw out 1 bad prof.
    case 1300
	jj=find(temp(:,201)<11);
    % need to fix this one up a bit
    case 1313
        jj=find(min(temp')'<2.5|min(temp(:,1:51)')'<10| ...
		temp(:,201)>20| temp(:,101)>24);
    % catch 2 more profiles
    case 1314
	jj=[jj;find(temp(:,351)<1)];
    % catch 2 more profiles
    case 1315
	jj=[jj;find(temp(:,351)<2.5)];
    case 1315
	jj=[jj;find(temp(:,251)>15)];
    case 1500
	jj=find(min(temp(:,21:66)')'<2.5);
    case 1514
	jj=[jj;find(temp(:,251)>3)];
    case 1516
	jj=[jj;find(temp(:,351)<1.5|temp(:,151)>6|max(temp(:,301:end)')'>4)];
    case 1517
	jj=[jj;find(temp(:,16)>12)];
    case 1600
	jj=[jj;find(temp(:,201)>9)];
    case 1601
	jj=[jj;find(min(temp(:,1:51)')'<2)];
    case 1701
	jj=[jj;find(min(temp(:,26:151)')'<1.5|min(temp(:,151:201)')'<.5)];
    case 1800
	jj=[jj;find(temp(:,23)>1|min(temp(:,151:301)')'<.1|max(temp')'>3)];
    case 3007
	jj=[jj;find(temp(:,301)>11)];
    case 3008
	jj=find(temp(:,301)<6|temp(:,301)>=10);
    case 3013
	jj=[jj;find(temp(:,401)>6.6|temp(:,401)<5)];
    case 3015
	jj=find(temp(:,51)<20|max(temp(:,376:end)')'>7.6);
	ii=find(temp(:,109)>29.5);
    case 3016
	ii=find(temp(:,51)<20|temp(:,101)<12);
    case 3100
	jj=find(temp(:,151)>13);
    case 3103
	jj=[jj;find(temp(:,201)>15)];
    case 3110
	jj=find(temp(:,201)<7.5|temp(:,91)<10.4|temp(:,21)<21);
    case 3111
	jj=[jj;find(min(temp(:,1:43)')'<17)];
    case 3114
	jj=find(temp(:,31)<23|min(temp(:,101:end)')'<4.5|...
	max(temp(:,251:end)')'>12|temp(:,201)>16|temp(:,101)<12);
    case 3116
	jj=[jj;find(min(temp(:,1:51)')'<20)];
    case 3203
	jj=[jj;find(temp(:,301)>13.5|temp(:,251)>14.5)];
    case 3204
	jj=[jj;find(temp(:,201)>16)];
    case 3205
	jj=[jj;find(temp(:,241)>14)];
    case 3210
	jj=find(temp(:,226)>13.5|temp(:,226)<7);
    case 3217
	jj=[jj;find(temp(:,151)<11.5)];
    case 3301
	jj=[jj;find(min(temp(:,1:26)')'<10|max(temp(:,1:26)')'>25)];
    case 3310
	jj=[jj;find(temp(:,401)<4)];
    case 3311
	ind2=(temp-repmat(nanmean(temp),[size(temp,1),1]))> ...
        	repmat(td,[size(temp,1),1]);
	jj=find(sum(ind2(:,201:end)')');
	jj=[jj;find(temp(:,401)>9)];
    case 3314
	jj=[jj;find(temp(:,386)>9)];
    case 3317
	jj=[jj;find(max(temp')'>26)];
    case 3512
	jj=find(max(temp')'>15);
    case 3600
	jj=find(max(temp')'>4.5|max(temp(:,301:end)')'>3);
    case 3700
	jj=find(temp(:,38)>-.1);
	tpp=diff(temp')';ii=find(max(tpp')'>.4);
    case 5000
	jj=[jj;find(temp(:,51)<10|temp(:,101)>20)];
    case 5002
	jj=find(temp(:,151)<8|temp(:,151)>13);
    case {5009,5010,5016}
	jj=[jj;find(max(temp')'>32)];
    case 5013
	ii=[];jj=find(temp(:,61)<12);
    case 5015
	jj=find(max(temp')'>32|temp(:,101)<10.5);
    case 5017
	jj=[jj;find(max(temp')'>32|min(temp(:,81:131)')'<10| ...
		temp(:,126)>22|min(temp(:,1:21)')'<23.6)];
    case 5100
	jj=[jj;find(temp(:,116)>15.4)];
    case 5101
	jj=[jj;find(min(temp(:,1:51)')'<15|min(temp(:,1:51)')'>29)];
    case 5102
	jj=[jj;find(temp(:,171)>15)];
    case 5103
	jj=[jj;find(temp(:,201)>15|temp(:,331)<3)];
    case 5107
	jj=[jj;find(min(temp(:,1:51)')'<10)];
    case 5111
	jj=[jj;find(max(temp(:,1:51)')'>30|temp(:,101)>25)];
    case 5113
	jj=[jj;find(temp(:,51)>30)];
    case {5114,5115,5116i,5117}
	jj=[jj;find(max(temp(:,1:51)')'>31)];
    case 5200
	jj=[jj;find(temp(:,101)>18)];
    case 5209
	jj=find(temp(:,51)<15);
    case {5214,5215}
	jj=[jj;find(temp(:,101)<14)];
    case 5307
	jj=find(temp(:,101)<8);
    case 5308
	jj=find(temp(:,301)>7|temp(:,151)>12);
    case 5309
	jj=find(temp(:,46)>23);
    case 5312
	jj=[jj;find(temp(:,181)<6)];
    case 5317
	jj=[jj;find(temp(:,301)<6.5|temp(:,101)>18)];
    case 5400
	jj=find(temp(:,151)>16|temp(:,351)>8|temp(:,226)>10);
    case 5407
	jj=[jj;find(temp(:,376)>8)];
    case 5500
	jj=find(temp(:,176)<.1);
    case 5507
	jj=[jj;find(temp(:,301)>5.5|max(temp(:,1:26)')'>12|temp(:,201)>7)];
    case 5517
	jj=[jj;find(min(temp(:,1:26)')'<.3&min(temp(:,1:26)')'>-.1)];
    case 5600
	jj=[jj;find(temp(:,236)>2.7|max(temp(:,1:51)')'>4.5)];
    case 5607
	jj=find(temp(:,216)<.8);
	ii=[ii;find(max(diff(temp'))'>1)];
    case 7000
	jj=[jj;find(temp(:,76)>19)];
    case 7001
	jj=[jj;find(min(temp(:,1:11)')'<17)];
    case 7003
	jj=[jj;find(temp(:,116)>15)];
    case 7004
	jj=[jj;find(min(temp(:,1:51)')'<10)];
    case 7005
	jj=[jj;find(temp(:,37)<15)];
    case 7009
	jj=[jj;find(max(temp')'>32|temp(:,111)>16)];
    case 7010
	jj=[jj;find(min(temp(:,1:37)')'<13|temp(:,71)<10.8)];
	ii=[];
    case 7011
	jj=[jj;find(max(temp')'>32)];
    case 7012
	jj=[jj;find(max(temp')'>32|temp(:,151)>13.2|...
		temp(:,91)<10.5|temp(:,116)<11.5)];
    case 7014
	jj=[jj;find(temp(:,11)<17)];
    case 7015
	jj=[jj;find(max(temp')'>31|temp(:,3)<22)];
    case {7016,7017}
	jj=find(min(temp(:,1:36)')'<16);
    case 7101
	jj=find(min(temp(:,1:41)')'<13);
    case 7102
	jj=find(min(temp(:,1:51)')'<13);
    case 7103
	jj=find(temp(:,151)>17|temp(:,351)>9.5);
    case 7104
	jj=[jj;find(temp(:,26)<17|temp(:,226)>15)];
    case 7107
	jj=[jj;find(temp(:,61)<17)];
    case {7112,7113}
	jj=[jj;find(min(temp(:,1:51)')'<11.25|max(temp')'>31| ...
		temp(:,151)>14|min(temp(:,1:3)')'<18)];
    case {7114,7115}
	jj=[jj;find(temp(:,26)<14)];
    case 7201
	jj=[jj;find(temp(:,351)>12)];
    case 7202
	jj=[jj;find(temp(end)>11)];
    case 7203
	jj=[jj;find(max(temp')'>29)];
    case 7204
	jj=[jj;find(min(temp(:,1:51)')'<15)];
    case 7205
	jj=[jj;find(max(temp')'>30|min(temp(:,1:26)')'<18|temp(:,176)>18.5)];
    case 7206
	jj=[jj;find(max(temp')'>30.05|temp(:,51)>28)];
    case 7207
        ind2=(temp-repmat(nanmean(temp),[size(temp,1),1]))> ...
                repmat(td,[size(temp,1),1]);
        jj=find(sum(ind2(:,201:end)')');
    case {7208,7214,7215}
	jj=[jj;find(min(temp(:,1:41)')'<15|max(temp')'>32)];
    case 7209
	jj=find(min(temp(:,1:41)')'<15|max(temp')'>32);
    case 7212
	jj=[jj;find(temp(:,101)<7)];
    case 7213
	jj=[jj;find(max(temp')'>26.5|max(temp(:,41:end)')'>25)];
    case 7300
	jj=find(min(temp(:,1:41)')'<15|temp(:,246)>14.5);
    case 7301
	jj=[jj;find(min(temp(:,1:101)')'<12|temp(:,56)>21.5)];
    case 7306
	jj=find(temp(:,351)>18.5);
    case 7307
	jj=[jj;find(temp(:,101)>26|temp(:,351)>18)];
    case 7311
	jj=[jj;find(temp(:,26)<7|temp(:,407)>5.5)];
    case 7312
	jj=[jj;find(min(temp(:,1:51)')'<5|max(temp')'>23)];
    case 7313
	jj=[jj;find(max(temp')'>24.5)];
    case 7400
	jj=[jj;find(min(temp(1:51)')'<10)];
    case 7401
	jj=[jj;find(min(temp(:,1:51)')'<7|temp(:,101)>16)];
    case 7402
	jj=find(temp(:,181)>14.5);
    case 7403
	jj=[jj;find(temp(:,51)<5|temp(:,76)>19)];
    case 7405
	jj=find(temp(:,351)<2.5);
    case 7406
	jj=find(temp(:,216)<4);
    case 7412
	jj=[jj;find(min(temp(:,1:51)')'<5|max(temp')'>20)];
    case 7414
	jj=[jj;find(max(temp')'>22)];
    case 7416
	jj=[jj;find(max(temp')'>25|min(temp')'<2.5)];
    case 7417
        ll=diff(temp');ll=ll(351:end,:);
        ii=[ii;find(max(ll)'>2)];
	jj=find(temp(:,351)>4.75|max(temp')'>24|temp(:,201)>8.5| ...
		temp(:,256)>6.9|temp(:,301)>5.5);
    case 7500
	jj=find(min(temp(:,1:51)')'<7);
    case 7501
	jj=[jj;find(max(temp')'>25)];
    case 7503
	jj=find(max(temp')'>18);
    case 7504
	jj=find(max(temp(:,251:end)')'>11.5);
    case 7505
	jj=find(temp(:,51)>7.5);
    case 7516
	jj=[jj;find(max(temp(:,18:end)')'>13.5)];
    case 7601
	ii=[];jj=find(max(temp')'>15);
    case 7602
	jj=find(max(temp')'>15);
    case 7705
	jj=[jj;find(max(temp(:,36:51)')'>1)];
    case 7800
	jj=find(max(temp(:,1:26)')'>1);
	
    

  end

  clear ind ind2 tmp tmpp ll

  qc2dtoss(i)=length(ii);
  qc2stoss(i)=length(jj);
  ii=[ii;find(isnan(nansum(temp')'))];
  ii=unique([ii;jj]); clear jj
  oldlen(i)=size(temp,1);
  qc2toss(i)=length(ii);
cd '..'
save qc2num oldlen qc2*toss
cd './All_Data' 
 coords(ii,:)=[];dt(ii,:)=[];mdep(ii)=[];qual(ii)=[];
  temp(ii,:)=[];time(ii,:)=[];npts(ii)=[];
  typ(ii,:)=[];src(ii,:)=[];bath(ii)=[];isunk(ii)=[];oclnum(ii)=[];

%  save(d(i).name,'coords','dt','depth','mdep','ndups','nkept', ...
%	'npts','ntot','qual','temp','time','src','typ','bath')
  save(d(i).name,'coords','dt','depth','mdep','nkept', ...
	'npts','qual','temp','time','src','typ','bath','isunk','oclnum')

  disp([num2str([i toc],5),'  ',d(i).name(1:5)]);

end
cd '..'
save qc2num oldlen qc2*toss

return

% this loop is diagnostic, run it to look through all files
% and check which ones need special treatment.
% % nstrt=282;
% % 
% % 
% % load ./All_Data/d1000 depth
% % load tossd len
% % cd './All_Data'
% % for i=nstrt:length(d)
% %   load(d(i).name,'temp');
% %   len(i)=size(temp,1);
% %   tpp=temp(:,11:end)-temp(:,1:end-10);
% %   tpp=tpp-repmat(nanmean(tpp),[size(tpp,1),1]);
% %   tmpp=tpp;tmpp(tpp>0)=NaN;tl=sqrt(nanmean(tmpp.^2))*-8.5;
% %   tmpp=tpp;tmpp(tpp<0)=NaN;tu=sqrt(nanmean(tmpp.^2))*8.5;
% %   ind=tpp>repmat(tu,[size(temp,1),1])|tpp<repmat(tl,[size(temp,1),1]);
% %   ii=find(sum(ind(:,61:end)')');clear tmpp ind
% % 
% %   td=4.2*nanstd(temp);tm=nanmean(temp);
% %   ind2=abs(temp-repmat(nanmean(temp),[size(temp,1),1]))> ...
% %         repmat(td,[size(temp,1),1]);
% %   jj=find(sum(ind2(:,201:end)')');
% %   jj=setdiff(jj,ii);
% % 
% %   subplot('position',[.035 .075 .45 .865])
% %   tpp=temp;tpp(ii,:)=[];
% %   plot(depth,tpp'),ax=axis;hold on
% %   title([d(i).name(1:5),'     ',num2str([size(temp,1),length(jj)])])
% %   p=plot(depth,tm+td,'b',depth,tm-td,'b');set(p,'linewidth',3),hold off
% %   if ~isempty(jj), hold on,p=plot(depth,temp(jj,:),'g'); hold off,end
% %   if ~isempty(ii)
% %     subplot('position',[.525 .075 .45 .865])
% %     plot(depth,temp(ii,:)),axis(ax);
% %     title(num2str([length(ii)]))
% %   else
% %     subplot('position',[.525 .075 .45 .865]),cla,axis(ax);
% %     title(num2str([length(ii)]))
% %   end
% %   pause
% % end
% % 
% % 
% % cd '..'
% % 
