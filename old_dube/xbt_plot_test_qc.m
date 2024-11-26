good_bad_oclnum=bad_oclnum(find(isfinite(bad_oclnum)==1));
num_bad=0;
for it=1:length(oclnum)
    
    if ismember(oclnum(it),xbt_oclnum)
        
%          plot(temp{it}(:,2),-1.*temp{it}(:,1),'.-')
%          hold on
         if ismember(oclnum(it),good_bad_oclnum)
             'cat'
             plot(temp{it}(:,2),-1.*temp{it}(:,1),'r.-')
             num_bad=num_bad+1
             hold on
         end
       
    end
end