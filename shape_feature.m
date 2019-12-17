% Estimate each object's area and perimeter. 
% Use these results to form a simple metric indicating the roundness of an
% object.
function [Ifinal,num]= shape_feature(I,circularityThresh)
keeperList = [];
num=0;
[B, L] = bwboundaries(I);
stats = regionprops(L, 'Area', 'Centroid');
for k = 1:length(B)
  boundary = B{k};
  delta_sq = diff(boundary).^2;
  perimeter = sum(sqrt(sum(delta_sq,2)));
  area = stats(k).Area;
  metric = 4*pi*area/perimeter^2;
  if metric > circularityThresh   
      keeperList = [keeperList k];
      num=num+1;
  end 
end
 Ifinal = ismember(L, keeperList);




