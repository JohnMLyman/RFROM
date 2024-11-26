% Plot double Histigram
figure(3); clf;orient landscape; wysiwyg
%load allheat
load allheat_no_te

pos_argo=find(s(:,1)=='A');
pos_xbt=find(s(:,1)~='A');

[h1,time]=hist(dt(:,1)+.5,[1950.5:1:2008.5]);
[h2,time]=hist(dt(pos_argo,1)+.5,[1950.5:1:2008.5]);
[h3,time]=hist(dt(pos_xbt,1)+.5,[1950.5:1:2008.5]);
bar(time,h1./1e3)
hold on
%bar(time,h3./1e4,'g')
bar(time,h2./1e3,'r')
axis([1955 2007 0 200]);
xlabel('Time [years]','fontsize',16);

title('Profiles of Upper Ocean','fontsize',18);

set(gca,'fontsize',16)
ylabel('Thousands of Profiles','fontsize',16);

hold off
eval(['print -dpng -f3 ../figs/trend_paper/hist_argo4'])

% h2=hist(dt(:,1)+.5,[1950+.5:1:2008.5])
% set(gca,'FaceColor','r');
