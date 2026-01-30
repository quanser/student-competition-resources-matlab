%% Configurable Params

% Choose spawn location of QCar
% 1 => calibration location
% 2 => taxi hub area
spawn_location = 2;

%% Traffic Light Function

% Cleanup Function

function cleanupQLabs(qlabs)
    qlabs.close()
end

function trafficLightController(qlabs)

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
    
        while(true)
    
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
    
            pause(5)
        end
    
    catch
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

% Stop RT models
try
    qc_stop_model('tcpip://localhost:17000', 'QCar2_Workspace')
catch error
end
pause(1)

try
    qc_stop_model('tcpip://localhost:17000', 'QCar2_Workspace_studio')
    pause(1)
catch error
end
pause(1)

% QLab connection
qlabs = QuanserInteractiveLabs();
connection_established = qlabs.open('localhost');

if connection_established == false
    disp("Failed to open connection.")
    return
end

disp('Connected')
verbose = true;
num_destroyed = qlabs.destroy_all_spawned_actors();

% Flooring

x_offset = 0.13;
y_offset = 1.67;
hFloor = QLabsQCarFlooring(qlabs);
hFloor.spawn_degrees([x_offset, y_offset, 0.001],[0, 0, -90]);


%region: Walls
hWall = QLabsWalls(qlabs);
hWall.set_enable_dynamics(false);

for y = 0:4
    hWall.spawn_degrees([-2.4 + x_offset, (-y*1.0)+2.55 + y_offset, 0.001], [0, 0, 0]);
end

for x = 0:4
    hWall.spawn_degrees([-1.9+x + x_offset, 3.05+ y_offset, 0.001], [0, 0, 90]);
end

for y = 0:5
    hWall.spawn_degrees([2.4+ x_offset, (-y*1.0)+2.55 + y_offset, 0.001], [0, 0, 0]);
end

for x = 0:3
    hWall.spawn_degrees([-0.9+x+ x_offset, -3.05+ y_offset, 0.001], [0, 0, 90]);
end

hWall.spawn_degrees([-2.03 + x_offset, -2.275+ y_offset, 0.001], [0, 0, 48]);
hWall.spawn_degrees([-1.575+ x_offset, -2.7+ y_offset, 0.001], [0, 0, 48]);


%% Signage

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

%% Cameras
%spawn cameras 1. birds eye, 2. edge 1, possess the qcar

camera1Loc = [0.15, 1.7, 5];
camera1Rot = [0, 90, 0];
camera1 = QLabsFreeCamera(qlabs);
camera1.spawn_degrees(camera1Loc, camera1Rot);

camera1.possess();

camera2Loc = [-0.36+ x_offset, -3.691+ y_offset, 2.652];
camera2Rot = [0, 47, 90];
camera2=QLabsFreeCamera(qlabs);
camera2.spawn_degrees (camera2Loc, camera2Rot);

%% Spawn QCar 2 and start rt model

% Use user configured parameters

calibration_location_rotation = [0, 2.13, 0.005, 0, 0, -90];
taxi_hub_location_rotation = [-1.205, -0.83, 0.005, 0, 0, -44.7];

%QCar
myCar = QLabsQCar2(qlabs);

switch spawn_location
    case 1
        spawn = calibration_location_rotation;
    case 2
        spawn = taxi_hub_location_rotation;
end


myCar.spawn_id_degrees(0, spawn(1:3), spawn(4:6), [1/10, 1/10, 1/10], 1);

% Start RT models
file_workspace = fullfile(getenv('RTMODELS_DIR'), 'QCar2', 'QCar2_Workspace_studio.rt-win64');
pause(2)
system(['quarc_run -D -r -t tcpip://localhost:17000 ', file_workspace]);
pause(3)

% Run traffic controller
trafficLightController(qlabs)
