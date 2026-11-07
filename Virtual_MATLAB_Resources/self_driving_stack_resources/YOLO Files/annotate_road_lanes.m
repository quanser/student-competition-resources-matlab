function [annotated,laneMask,lanePoints,laneFound] = annotate_road_lanes(rgb)
% Trace lane boundaries in the supplied simulated-road videos.
% This is image post-processing, not learned YOLO segmentation. It does not
% extrapolate beyond observed paint or draw boxes around lanes.
% Reference: MathWorks Lane and Vehicle Detection in Simulink Using Deep
% Learning: boundary coordinates followed by insertShape line segments.
I=single(rgb); [height,width,~]=size(rgb);
r=I(:,:,1); g=I(:,:,2); b=I(:,:,3);
gray=0.299*r+0.587*g+0.114*b;
roi=false(height,width); roi(max(1,round(0.35*height)):end,:)=true;
yellow=roi & r>130 & g>120 & min(r,g)>1.25*b;
yellow=bwareaopen(imclose(yellow,strel('disk',1,0)),6);
white=roi & min(I,[],3)>185 & (max(I,[],3)-min(I,[],3))<35;
dark=gray<100;
components=bwconncomp(white,8);
stats=regionprops(components,'BoundingBox','Area');
whiteLanes=false(height,width);
for k=1:components.NumObjects
    box=stats(k).BoundingBox;
    if stats(k).Area<5 || stats(k).Area>0.008*height*width, continue; end
    % Transverse stop bars are not lane boundaries. Small distant dashes can
    % be nearly horizontal, so only reject long, flat components.
    if box(3)>0.1*width && box(3)>4*box(4), continue; end
    x1=max(1,floor(box(1))-3); x2=min(width,ceil(box(1)+box(3))+3);
    y1=max(1,floor(box(2))-3); y2=min(height,ceil(box(2)+box(4))+3);
    patch=false(y2-y1+1,x2-x1+1);
    [ys,xs]=ind2sub([height width],components.PixelIdxList{k});
    patch(sub2ind(size(patch),ys-y1+1,xs-x1+1))=true;
    ring=imdilate(patch,strel('disk',2,0)) & ~patch;
    background=dark(y1:y2,x1:x2);
    % Reject white sidewalks/walls: lane paint should be surrounded by road.
    if nnz(ring)==0 || nnz(background & ring)/nnz(ring)<0.55, continue; end
    whiteLanes(components.PixelIdxList{k})=true;
end
laneMask=yellow | whiteLanes;
annotated=rgb;
lanePoints=nan(96,2,2,'single'); laneFound=false(2,1);
% The supplied scene uses a solid yellow boundary and a dashed white boundary.
% Track their visible paint independently and interpolate dashed gaps.
masks={yellow,whiteLanes};
for boundary=1:2
    [points,found]=fitBoundary(masks{boundary},boundary==1);
    lanePoints(:,:,boundary)=points; laneFound(boundary)=found;
    if found
        segments=[points(1:end-1,:) points(2:end,:)];
        annotated=insertShape(annotated,'Line',segments,'Color',[40 255 70],'LineWidth',4);
    end
end
end

function [points,found]=fitBoundary(mask,isSolid)
[height,width]=size(mask);
points=nan(96,2,'single'); found=false;
if isSolid
    % Trace the paint's centerline. Sharp bends in the simulation are not
    % reliably represented by one image-space parabola.
    skeleton=bwskel(mask,'MinBranchLength',max(5,round(0.015*height)));
    components=bwconncomp(skeleton,8);
    if components.NumObjects==0, return; end
    [n,largest]=max(cellfun(@numel,components.PixelIdxList));
    if n<20, return; end
    pixels=components.PixelIdxList{largest};
    [ys,xs]=ind2sub([height width],pixels);
    node=zeros(height,width,'uint32'); node(pixels)=uint32(1:n);
    from=[]; to=[]; weights=[];
    offsets=[0 1;1 -1;1 0;1 1];
    for j=1:4
        yy=ys+offsets(j,1); xx=xs+offsets(j,2);
        inside=yy>=1 & yy<=height & xx>=1 & xx<=width;
        origin=find(inside); neighbors=double(node(sub2ind([height width],yy(inside),xx(inside))));
        connected=neighbors>0;
        from=[from;origin(connected)]; to=[to;neighbors(connected)]; %#ok<AGROW>
        weights=[weights;repmat(hypot(offsets(j,1),offsets(j,2)),nnz(connected),1)]; %#ok<AGROW>
    end
    network=graph(from,to,weights,n);
    [~,start]=max(distances(network,1));
    [~,finish]=max(distances(network,start));
    path=shortestpath(network,start,finish);
    if numel(path)<20, return; end
    coordinates=double([xs(path) ys(path)]);
    arc=[0;cumsum(hypot(diff(coordinates(:,1)),diff(coordinates(:,2))))];
    if arc(end)<0.08*height, return; end
    points=single(interp1(arc,coordinates,linspace(0,arc(end),96)','linear'));
    found=true; return
end
rows=find(any(mask,2));
if numel(rows)<12 || range(rows)<0.08*height, return; end
% Follow one coherent marking through rows instead of averaging distinct lines.
xs=zeros(size(rows)); lastX=width/2;
for k=numel(rows):-1:1
    positions=find(mask(rows(k),:));
    cuts=[0 find(diff(positions)>8) numel(positions)];
    centers=zeros(1,numel(cuts)-1);
    for j=1:numel(centers), centers(j)=median(positions(cuts(j)+1:cuts(j+1))); end
    [~,nearest]=min(abs(centers-lastX)); xs(k)=centers(nearest); lastX=xs(k);
end
% Do not bridge unrelated markings separated by a large spatial jump.
breaks=[0;find(diff(rows)>0.2*height | abs(diff(xs))>0.18*width);numel(rows)];
[~,segment]=max(diff(breaks)); chosen=breaks(segment)+1:breaks(segment+1);
rows=rows(chosen); xs=xs(chosen);
if numel(rows)<12 || range(rows)<0.08*height, return; end
% Bin individual paint pixels, then interpolate between observed dash positions.
bins=floor((rows-min(rows))/max(3,round(0.025*height)));
groups=unique(bins); knotY=zeros(numel(groups),1); knotX=knotY;
for j=1:numel(groups)
    selected=bins==groups(j); knotY(j)=median(rows(selected)); knotX(j)=median(xs(selected));
end
if numel(groups)<3, return; end
ys=linspace(knotY(1),knotY(end),96)';
fittedX=interp1(knotY,knotX,ys,'pchip');
points=single([fittedX ys]); found=true;
end
