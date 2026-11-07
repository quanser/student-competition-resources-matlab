classdef RoadYOLODistance < matlab.System
    methods (Access = protected)
        function [distances]=stepImpl(~,depth,boxes,classIDs,count)
            [distances]= ...
                road_yolo_depth_distances(depth,boxes,classIDs,count);
        end
        function [a,b,c,d,e,f]=getOutputSizeImpl(obj)
            a=[1 1]; b=a; boxSize=propagatedInputSize(obj,2);
            c=[boxSize(1) 1]; d=c; e=a; f=a;
        end
        function [a,b,c,d,e,f]=getOutputDataTypeImpl(~)
            a='single'; b=a; c=a; d='logical'; e=d; f=d;
        end
        function [a,b,c,d,e,f]=isOutputComplexImpl(~)
            a=false; b=false; c=false; d=false; e=false; f=false;
        end
        function [a,b,c,d,e,f]=isOutputFixedSizeImpl(~)
            a=true; b=true; c=true; d=true; e=true; f=true;
        end
    end
end
