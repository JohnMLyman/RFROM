% this code plots all the data set n at the commandline, n=0...n=20



e=sdir('grad_den*.mat')
%figure
%n=0
start_n=n*16.+1
for i=start_n:start_n+15,
%for i=start_n:length(e),
    subplot(4,4,i-start_n+1)
    eval(['load ',e(i).name])
    yd=dt(:,1)+(dt(:,2)-1)/12.+(dt(:,3)-1)/365.;
  
  %find the right dates (ie only preform the qc on the times that
  % I cheacked.
  
  good_times=find(yd > 1992);
  
  if length(good_times) ge 1 then 
  
  temp=temp(good_times,:);
    
    plot(temp,-1.*depth,'.')
    title(e(i).name)
  end
end

% % figure
% % 
% % for i=start_n:start_n+15,
% %     subplot(4,4,i-start_n+1)
% %     eval(['load ',e(i).name])
% %     plot(coords(:,1),coords(:,2),'b.')
% %     axis([-180 180 -60 60])
% %     title([e(i).name, ' ',num2str(length(coords(:,1)))])
% %    
% %     
% % end
% % 
% % 
