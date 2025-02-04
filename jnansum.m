function total=jnansum(Mat,DimSum)
% this function insures Nans in the sum when all nan

% this was my old way wich is 10% slower
% if exist('DimSum','var')
%     total=sum(Mat,DimSum,'omitnan');
%     NSum=sum(isfinite(Mat),DimSum);
% else
%     total=sum(Mat,'omitnan');
%     NSum=sum(isfinite(Mat));
% end
% total(NSum==0)=nan;
if exist('DimSum','var')
    total=sum(Mat,DimSum,'omitnan');
    total(~any(isfinite(Mat),DimSum))=nan;
else
    total=sum(Mat,'omitnan');
    total(~any(isfinite(Mat)))=nan;
end