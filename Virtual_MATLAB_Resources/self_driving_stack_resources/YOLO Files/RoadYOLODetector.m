classdef RoadYOLODetector < matlab.System
    % YOLO object detection and lane annotation for Normal simulation.
    properties (Nontunable)
        ModelFile = 'road_yolo_detector.mat'
        Threshold = 0.35
        MaxDetections = 100
        ExecutionEnvironment = 'cpu'
    end
    properties (Access = private)
        Detector
    end
    methods (Access = protected)
        function setupImpl(obj)
            filename=obj.ModelFile;
            if ~isfile(filename)
                filename=fullfile(fileparts(mfilename('fullpath')),filename);
            end
            assert(isfile(filename),'RoadYOLO:MissingWeights', ...
                'Missing trained weights: %s.',filename);
            data=load(filename,'detector');
            assert(isfield(data,'detector') && isa(data.detector,'yolov4ObjectDetector'), ...
                'RoadYOLO:InvalidWeights','MAT file must contain a yolov4ObjectDetector named detector.');
            assert(all(ismember(["stop_sign","lane_line","stop_line"],string(data.detector.ClassNames))), ...
                'RoadYOLO:MissingClasses','Detector must include stop_sign, lane_line, stop_line.');
            assert(strcmp(data.detector.PredictedBoxType,'axis-aligned'), ...
                'RoadYOLO:BoxType','Use an axis-aligned YOLO detector.');
            obj.Detector=data.detector;
        end
        function [rgbOut,boxes,scores,classIDs,count,lanePoints]=stepImpl(obj,rgb)
            [b,s,l]=detect(obj.Detector,rgb,'Threshold',obj.Threshold, ...
                'ExecutionEnvironment',obj.ExecutionEnvironment);
            names=["stop_sign","lane_line","stop_line"];
            [keep,ids]=ismember(string(l),names);
            keep=keep & ids~=2;
            b=b(keep,:); s=s(keep); ids=ids(keep);
            [~,order]=sort(s,'descend');
            order=order(1:min(numel(order),obj.MaxDetections));
            b=b(order,:); s=s(order); ids=ids(order);
            n=numel(order);
            boxes=zeros(obj.MaxDetections,4,'single');
            scores=zeros(obj.MaxDetections,1,'single');
            classIDs=zeros(obj.MaxDetections,1,'uint8');
            boxes(1:n,:)=single(b); scores(1:n)=single(s);
            classIDs(1:n)=uint8(ids); count=uint32(n);
            [rgbOut,lanePoints]=annotate_road_lanes(rgb);
            colors={'red','yellow','cyan'};
            for k=[1 3]
                selected=ids==k;
                if any(selected)
                    labels=names(k)+" "+compose('%.2f',s(selected));
                    rgbOut=insertObjectAnnotation(rgbOut,'rectangle',b(selected,:), ...
                        cellstr(labels),'Color',colors{k},'LineWidth',2);
                end
            end
        end
        function [a,b,c,d,e,f,g,h]=getOutputSizeImpl(obj)
            a=propagatedInputSize(obj,1); b=[obj.MaxDetections 4];
            c=[obj.MaxDetections 1]; d=c; e=[1 1]; f=a(1:2);
            g=[96 2 2]; h=[2 1];
        end
        function [a,b,c,d,e,f,g,h]=getOutputDataTypeImpl(~)
            a='uint8'; b='single'; c='single'; d='uint8'; e='uint32';
            f='logical'; g='single'; h='logical';
        end
        function [a,b,c,d,e,f,g,h]=isOutputComplexImpl(~)
            a=false; b=false; c=false; d=false; e=false; f=false; g=false; h=false;
        end
        function [a,b,c,d,e,f,g,h]=isOutputFixedSizeImpl(~)
            a=true; b=true; c=true; d=true; e=true; f=true; g=true; h=true;
        end
        function validatePropertiesImpl(obj)
            validateattributes(obj.Threshold,{'numeric'},{'scalar','>',0,'<',1});
            validateattributes(obj.MaxDetections,{'numeric'},{'scalar','integer','positive'});
        end
    end
end
