classdef FourTileVideoViewer < matlab.System
    % One 2-by-2 display for the four video streams in the capture subsystem.
    % Normal simulation only; display operations do not alter input signals.
    properties (Nontunable)
        ShowWindow = true
        CloseOnRelease = false
    end
    properties (Access = private)
        Window
        Images
    end
    methods (Access = protected)
        function setupImpl(obj,raw,edges,threshold,annotated)
            if ~isempty(obj.Window) && isgraphics(obj.Window), close(obj.Window); end
            visibility='off';
            if obj.ShowWindow, visibility='on'; end
            screen=get(groot,'ScreenSize');
            position=[screen(1)+40 screen(2)+60 max(400,min(1280,screen(3)-80)) ...
                max(320,min(1040,screen(4)-140))];
            obj.Window=figure('Name','QCar - Four Video Outputs','NumberTitle','off', ...
                'Color',[0.06 0.08 0.12],'Position',position, ...
                'Visible',visibility,'Tag','FourTileVideoViewer');
            layout=tiledlayout(obj.Window,2,2,'TileSpacing','compact','Padding','compact');
            labels={'Raw RGB','Edge detection','Threshold output','Annotated output'};
            frames={raw,edges,threshold,annotated};
            obj.Images=gobjects(1,4);
            for k=1:4
                ax=nexttile(layout,k);
                obj.Images(k)=image(ax,obj.displayRGB(frames{k}), ...
                    'Tag',sprintf('FourTileImage%d',k));
                axis(ax,'image'); axis(ax,'off');
                title(ax,labels{k},'Color','white','FontSize',13,'FontWeight','bold');
            end
        end
        function stepImpl(obj,raw,edges,threshold,annotated)
            % Closing the viewer does not stop the vehicle model or recordings.
            if isempty(obj.Window) || ~isgraphics(obj.Window), return; end
            frames={raw,edges,threshold,annotated};
            for k=1:4
                obj.Images(k).CData=obj.displayRGB(frames{k});
            end
            drawnow limitrate;
        end
        function releaseImpl(obj)
            if obj.CloseOnRelease && ~isempty(obj.Window) && isgraphics(obj.Window)
                close(obj.Window);
                obj.Window=[]; obj.Images=[];
            end
        end
        function n=getNumInputsImpl(~), n=4; end
        function n=getNumOutputsImpl(~), n=0; end
        function [a,b,c,d]=getInputNamesImpl(~)
            a='Raw RGB'; b='Edges'; c='Threshold'; d='Annotated';
        end
        function icon=getIconImpl(~), icon=sprintf('Four Video Outputs\n2 x 2'); end
    end
    methods (Static, Access = private)
        function rgb=displayRGB(frame)
            assert((isnumeric(frame) || islogical(frame)) && isreal(frame), ...
                'Video input must be a real numeric or logical image.');
            assert(ndims(frame)<=3 && (size(frame,3)==1 || size(frame,3)==3), ...
                'Video input must be grayscale H-by-W or RGB H-by-W-by-3.');
            if isa(frame,'uint8')
                rgb=frame;
            elseif islogical(frame)
                rgb=uint8(frame)*255;
            elseif isinteger(frame)
                rgb=im2uint8(frame);
            else
                values=single(frame); values(~isfinite(values))=0;
                if all(values>=0 & values<=1,'all'), values=255*values; end
                rgb=uint8(min(max(values,0),255));
            end
            if size(rgb,3)==1, rgb=repmat(rgb,1,1,3); end
        end
    end
end
