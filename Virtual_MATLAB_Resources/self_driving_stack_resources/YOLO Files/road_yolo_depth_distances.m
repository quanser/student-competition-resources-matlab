function [signM,lineM,distances,valid,signValid,lineValid] = road_yolo_depth_distances(depth,boxes,classIDs,count)
% Robust axial depth (camera Z, meters), NOT Euclidean range or braking distance.
% Requires depth spatially aligned and time-synchronized to the RGB frame.
distances=nan(size(boxes,1),1,'single'); valid=false(size(boxes,1),1);
[height,width]=size(depth);
for k=1:min(double(count),size(boxes,1))
    id=classIDs(k);
    if id~=1 && id~=3, continue; end
    b=double(boxes(k,:));
    if any(~isfinite(b)) || any(b(3:4)<=0), continue; end
    % Exclude clipped boxes, whose apparent center may be outside the object.
    if b(1)<1 || b(2)<1 || b(1)+b(3)-1>width || b(2)+b(4)-1>height, continue; end
    % Inner sign patch avoids the background around octagonal sign corners.
    % A thin center band of the line box samples its central painted/road patch.
    x1=max(1,ceil(b(1)+0.3*b(3))); x2=min(width,floor(b(1)+0.7*b(3)));
    y1=max(1,ceil(b(2)+0.3*b(4))); y2=min(height,floor(b(2)+0.7*b(4)));
    if x2<x1 || y2<y1, continue; end
    patch=double(depth(y1:y2,x1:x2));
    values=patch(isfinite(patch) & patch>0);
    if numel(values)<3 || numel(values)<0.25*numel(patch), continue; end
    distances(k)=single(median(values)); valid(k)=true;
end
signs=distances(valid & classIDs==1); lines=distances(valid & classIDs==3);
signM=single(NaN); lineM=single(NaN);
signValid=~isempty(signs); lineValid=~isempty(lines);
if signValid, signM=min(signs); end
if lineValid, lineM=min(lines); end
end
