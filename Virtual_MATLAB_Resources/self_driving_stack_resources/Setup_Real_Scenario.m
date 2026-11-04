%% Traffic Light Function

% Cleanup Function

function cleanupQLabs(qlabs)
    qlabs.close()
end

% Stop Window Functions

function stopFig = createStopWindow()
    % Create a small window that does not block the script. Clicking the
    % button (or closing the window) tells the traffic light loop to stop.
    stopFig = uifigure('Name', 'Traffic Light Controller', ...
        'Position', [100 100 360 140], 'WindowStyle', 'alwaysontop');
    stopFig.UserData = struct('stop', false);
    uilabel(stopFig, 'Text', 'The traffic lights are running.', ...
        'Position', [20 90 320 30], 'FontSize', 16);
    uibutton(stopFig, 'push', 'Text', 'Stop Traffic Lights', ...
        'Position', [80 25 200 45], 'FontSize', 16, ...
        'ButtonPushedFcn', @(~,~) requestStop(stopFig));
    stopFig.CloseRequestFcn = @(~,~) requestStop(stopFig);
end

function requestStop(stopFig)
    % Set the flag that the traffic light loop checks
    stopFig.UserData.stop = true;
end

function trafficLightController(qlabs, stopFig)

    disp('running traffic controller')
    try
    
        clear trafficLight1 trafficLight2 trafficLight3 trafficLight4
    
        trafficLight1 = QLabsTrafficLight(qlabs);
        trafficLight2 = QLabsTrafficLight(qlabs);
        trafficLight3 = QLabsTrafficLight(qlabs);
        trafficLight4 = QLabsTrafficLight(qlabs);
    
        %intersection 1
        trafficLight1.spawn_id_degrees(1, [0.6, 1.55, 0.006], [0,0,0], [0.1, 0.1, 0.1], 0, false);
        trafficLight2.spawn_id_degrees(2, [-0.6, 1.28, 0.006], [0,0,90], [0.1, 0.1, 0.1], 0, false);
        trafficLight3.spawn_id_degrees(3, [-0.37, 0.3, 0.006], [0,0,180], [0.1, 0.1, 0.1], 0, false);
        trafficLight4.spawn_id_degrees(4, [0.75, 0.48, 0.006], [0,0,-90], [0.1, 0.1, 0.1], 0, false);
    
        intersection1Flag = 0;

        cleanup = onCleanup(@()cleanupQLabs(qlabs));
    
        while isvalid(stopFig) && ~stopFig.UserData.stop
    
            %intersection 1
            disp('in loop')
            if intersection1Flag == 0
                trafficLight1.set_color(QLabsTrafficLight.COLOR_RED);
                trafficLight3.set_color(QLabsTrafficLight.COLOR_RED);
                trafficLight2.set_color(QLabsTrafficLight.COLOR_GREEN);
                trafficLight4.set_color(QLabsTrafficLight.COLOR_GREEN);
            end
    
            if intersection1Flag == 1
                trafficLight1.set_color(QLabsTrafficLight.COLOR_RED);
                trafficLight3.set_color(QLabsTrafficLight.COLOR_RED);
                trafficLight2.set_color(QLabsTrafficLight.COLOR_YELLOW);
                trafficLight4.set_color(QLabsTrafficLight.COLOR_YELLOW);
            end
    
            if intersection1Flag == 2
                trafficLight1.set_color(QLabsTrafficLight.COLOR_GREEN);
                trafficLight3.set_color(QLabsTrafficLight.COLOR_GREEN);
                trafficLight2.set_color(QLabsTrafficLight.COLOR_RED);
                trafficLight4.set_color(QLabsTrafficLight.COLOR_RED);
            end
    
            if intersection1Flag == 3
                trafficLight1.set_color(QLabsTrafficLight.COLOR_YELLOW);
                trafficLight3.set_color(QLabsTrafficLight.COLOR_YELLOW);
                trafficLight2.set_color(QLabsTrafficLight.COLOR_RED);
                trafficLight4.set_color(QLabsTrafficLight.COLOR_RED);
            end
    
            intersection1Flag = mod((intersection1Flag + 1),4);
    
            % wait 5 seconds in short steps so the stop button responds quickly
            for waitStep = 1:50
                pause(0.1)
                if ~isvalid(stopFig) || stopFig.UserData.stop
                    break
                end
            end
        end

        disp('Stop requested, shutting down the traffic lights')
    
    catch errorMsg
        disp(errorMsg.message)
        qlabs.close()
    end
end


%% Set up QLabs Connection and Variables

% MATLAB Path

newPathEntry = fullfile(getenv('QAL_DIR'), '0_libraries', 'matlab', 'qvl');
pathCell = regexp(path, pathsep, 'split');
if ispc  % Windows is not case-sensitive
  onPath = any(strcmpi(newPathEntry, pathCell));
else
  onPath = any(strcmp(newPathEntry, pathCell));
end

if onPath == 0
    path(path, newPathEntry)
    savepath
end

% QLab connection
qlabs = QuanserInteractiveLabs();
connection_established = qlabs.open('localhost');

if connection_established == false
    disp("Failed to open connection.")
    return
end

disp('Connected')

%% Signage

x_offset = 0.13;
y_offset = 1.67;

% stop signs
%parking lot
myStopSign = QLabsStopSign(qlabs);

myStopSign.spawn_degrees([-1.5, 3.6, 0.006], ...
                        [0, 0, -35], ...
                        [0.1, 0.1, 0.1], ...
                        false);  

myStopSign.spawn_degrees([-1.5, 2.2, 0.006], ...
                        [0, 0, 35], ...
                        [0.1, 0.1, 0.1], ...
                        false);

%x+ side
myStopSign.spawn_degrees([2.410, 0.206, 0.006], ...
                        [0, 0, -90], ...
                        [0.1, 0.1, 0.1], ...
                        false); 

myStopSign.spawn_degrees([1.766, 1.697, 0.006], ...
                        [0, 0, 90], ...
                        [0.1, 0.1, 0.1], ...
                        false);

%roundabout signs
myRoundaboutSign = QLabsRoundaboutSign(qlabs);
myRoundaboutSign.spawn_degrees([2.392, 2.522, 0.006], ...
                          [0, 0, -90], ...
                          [0.1, 0.1, 0.1], ...
                          false);

myRoundaboutSign.spawn_degrees([0.698, 2.483, 0.006], ...
                          [0, 0, -145], ...
                          [0.1, 0.1, 0.1], ...
                          false);

myRoundaboutSign.spawn_degrees([0.007, 3.973, 0.006], ...
                        [0, 0, 135], ...
                        [0.1, 0.1, 0.1], ...
                        false);


%yield sign
%one way exit yield
myYieldSign = QLabsYieldSign(qlabs);
myYieldSign.spawn_degrees([0.0, -1.3, 0.006], ...
                          [0, 0, -180], ...
                          [0.1, 0.1, 0.1], ...
                          false);

%roundabout yields
myYieldSign.spawn_degrees([2.4, 3.2, 0.006], ...
                        [0, 0, -90], ...
                        [0.1, 0.1, 0.1], ...
                        false);

myYieldSign.spawn_degrees([1.1, 2.8, 0.006], ...
                        [0, 0, -145], ...
                        [0.1, 0.1, 0.1], ...
                        false);

myYieldSign.spawn_degrees([0.49, 3.8, 0.006], ...
                        [0, 0, 135], ...
                        [0.1, 0.1, 0.1], ...
                        false);

% Spawning crosswalks
myCrossWalk = QLabsCrosswalk(qlabs);
myCrossWalk.spawn_degrees   ([-2 + x_offset, -1.475 + y_offset, 0.01], ...
                            [0,0,0], ...
                            [0.1,0.1,0.075], ...
                            0);

myCrossWalk.spawn_degrees   ([-0.5, 0.95, 0.006], ...
                            [0,0,90], ...
                            [0.1,0.1,0.075], ...
                            0);

myCrossWalk.spawn_degrees   ([0.15, 0.32, 0.006], ...
                            [0,0,0], ...
                            [0.1,0.1,0.075], ...
                            0);

myCrossWalk.spawn_degrees   ([0.75, 0.95, 0.006], ...
                            [0,0,90], ...
                            [0.1,0.1,0.075], ...
                            0);

myCrossWalk.spawn_degrees   ([0.13, 1.57, 0.006], ...
                            [0,0,0], ...
                            [0.1,0.1,0.075], ...
                            0);

myCrossWalk.spawn_degrees   ([1.45, 0.95, 0.006], ...
                            [0,0,90], ...
                            [0.1,0.1,0.075], ...
                            0);

%Signage line guidance (white lines)
mySpline = QLabsBasicShape(qlabs);
mySpline.spawn_degrees ([2.21, 0.2, 0.006], ...
                        [0, 0, 0], ...
                        [0.27, 0.02, 0.001], ...
                        false);

mySpline.spawn_degrees ([1.951, 1.68, 0.006], ...
                        [0, 0, 0], ...
                        [0.27, 0.02, 0.001], ...
                        false);

mySpline.spawn_degrees ([-0.05, -1.02, 0.006], ...
                        [0, 0, 90], ...
                        [0.38, 0.02, 0.001], ...
                        false);

%% Scenario Pop Up that will Stop Everything
% Run traffic controller with a window that can stop it
stopFig = createStopWindow();
trafficLightController(qlabs, stopFig)

% Close the stop window and, if this is the separate MATLAB instance started
% without the desktop, close that instance as well
if isvalid(stopFig)
    delete(stopFig)
end
disp('Traffic lights stopped.')
if ~usejava('desktop')
    pause(1)
    exit
end
