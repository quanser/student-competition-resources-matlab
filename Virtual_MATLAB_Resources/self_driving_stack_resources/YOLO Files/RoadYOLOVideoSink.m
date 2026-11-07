classdef RoadYOLOVideoSink < matlab.System
    properties (Nontunable)
        OutputFile = 'road_yolo_annotated.avi'
        FrameRate = 30
        ShowVideo = false
    end
    properties (Access = private)
        Writer
        Player
        FramesWritten = 0
    end
    methods (Access = protected)
        function setupImpl(obj)
            obj.Writer = VideoWriter(obj.OutputFile,'Motion JPEG AVI');
            obj.Writer.FrameRate = obj.FrameRate;
            open(obj.Writer);
            obj.FramesWritten=0;
            if obj.ShowVideo
                obj.Player = vision.VideoPlayer('Name','YOLO: stop signs, lane lines, stop lines');
            end
        end
        function stepImpl(obj,rgb)
            writeVideo(obj.Writer,rgb);
            obj.FramesWritten=obj.FramesWritten+1;
            if mod(obj.FramesWritten,250)==0
                fprintf('YOLO video: wrote %d frames.\n',obj.FramesWritten);
            end
            if obj.ShowVideo, obj.Player(rgb); end
        end
        function releaseImpl(obj)
            if ~isempty(obj.Writer), close(obj.Writer); end
            if ~isempty(obj.Player), release(obj.Player); end
        end
        function n = getNumOutputsImpl(~), n=0; end
    end
end
