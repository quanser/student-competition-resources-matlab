%% MANUAL OVERRIDE
% set to true if you would like to spawn the qcar in a custom location and
% heading and not open any models
% (only use this if you understand the components of the setup)

manual_overide_flag = false;

%% Pre-Checks

% Initialize variables
externalModeFlag = false; % assumed false if they downloaded this set of resources
qlabsInstalledFlag = false;
calibrationPresent = false; % never need to calibrate because we use autolocalize
desireToCalibrate = false;
desireForRealScenario = false;

% check that qlabs is installed and QAL_DIR is defined
qlabsDir = fullfile(getenv('ProgramFiles'), 'Quanser', 'Quanser Interactive Labs');
if isfolder(qlabsDir)
    disp('QLabs Installation Detected ... nice!')
else
    error('QLabs not detected! Ensure QLabs has been installed according the the competition page instructions ...')
end

% check that MATLAB has access to qvl libraries
qvlDir = fullfile(getenv('QAL_DIR'), '0_libraries', 'matlab', 'qvl');
if ~isfolder(qvlDir)
    disp('qvl libraries are not set, but are necessary for running the setup scripts')
    error('please download the libraries from the https://github.com/quanser/Quanser_Academic_Resources#downloading-resources');
end

%% Warning to Open the Correct World in QLabs

fprintf('\nBefore proceeding, please ensure that QLabs is open to the QCar2 module and the Open Plane World!\n')
input('Once ready, press enter to proceed ...\n')

%% User Interaction

if manual_overide_flag == true
    
    % configure the setup options
    spawn_option = 3;
    desireToCalibrate = false;
    % ask for the user input
    x_location = input('What X location (m) would you like to spawn the qcar in?: ');
    y_location = input('What Y location (m) would you like to spawn the qcar in?: ');
    heading = input('What heading (deg) would you like to spawn the qcar in?: ');
    manual_location = [double(x_location), double(y_location), double(heading)];
    loadParamFlag = input('Would you like to load the qcar2 parameters? (y/n)','s');
    switch loadParamFlag
        case 'y'
            loadParamFlag = true;
        case 'n'
            loadParamFlag = false;
        otherwise
            error('Invalid input')
    end

else
    % ask where to spawn the car
    spawn_option = 2;
    realScenarioFlag = input('Setup real scenario? (y/n)', 's');

    switch realScenarioFlag
        case 'y'
            desireForRealScenario = true;
        case 'n'
            desireForRealScenario = false;
        case other
            fprintf('Unrecognized input, defaulting to false')
            desireForRealScenario = false;
    end
end

%% Environment Setup

% if manual override, setup QLabs with manual pos
if manual_overide_flag == true
    setupQLabs(spawn_option, manual_location);
    simLaunch(desireToCalibrate, externalModeFlag);
else
    setupQLabs(spawn_option);
    simLaunch(desireToCalibrate, externalModeFlag); 
end

% run the real scenario in a matlab terminal if requested
if desireForRealScenario == true
    filePath = fullfile(pwd, 'Setup_Real_Scenario.m');
    beginningCmd = 'matlab -nosplash -nodesktop -r "run(''';
    endCmd = char(''');" &');
    command = [beginningCmd, filePath, endCmd];
    [status, cmdout] = system(command);
    if status == 0
        disp('Real scenario setup initiated successfully.');
    else
        disp('Failed to initiate real scenario setup.');
    end
end

%% Helper Functions
function setupQLabs(spawn_option, manual_location)
    arguments
        spawn_option int32
        manual_location (1,3) double = [0.0,0.0,0.0]
    end

    % set MATLAB path to qvl library
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
    qlabs.destroy_all_spawned_actors();
    
    % flooring
    x_offset = 0.13;
    y_offset = 1.67;
    hFloor = QLabsQCarFlooring(qlabs);
    hFloor.spawn_degrees([x_offset, y_offset, 0.001],[0, 0, -90]);
    
    % walls
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
    
    %spawn cameras 1. birds eye, 2. edge 1
    camera1Loc = [0.15, 1.7, 5];
    camera1Rot = [0, 90, 0];
    camera1 = QLabsFreeCamera(qlabs);
    camera1.spawn_degrees(camera1Loc, camera1Rot);
    camera1.possess();
    camera2Loc = [-0.36+ x_offset, -3.691+ y_offset, 2.652];
    camera2Rot = [0, 47, 90];
    camera2=QLabsFreeCamera(qlabs);
    camera2.spawn_degrees (camera2Loc, camera2Rot);

    % define spawnable locations
    calibration_location_rotation = [0, 2.13, 0.005, 0, 0, -90];
    taxi_hub_location_rotation = [-1.205, -0.83, 0.005, 0, 0, -44.7];
    manual_location = [manual_location(1), manual_location(2), 0.005, 0, 0, manual_location(3)];

    % connect to qlabs qcars
    myCar = QLabsQCar2(qlabs);
    
    switch spawn_option
        case 1
            spawn = calibration_location_rotation;
        case 2
            spawn = taxi_hub_location_rotation;
        case 3
            spawn = manual_location;
        otherwise
            error('unknown location selected!\n')
    end
    
    % spawn car according to the location
    myCar.spawn_id_degrees(0, spawn(1:3), spawn(4:6), [1/10, 1/10, 1/10], 1);
    
    % start rt model for qcar2
    file_workspace = fullfile(getenv('RTMODELS_DIR'), 'QCar2', 'QCar2_Workspace_studio.rt-win64');
    pause(2)
    system(['quarc_run -D -r -t tcpip://localhost:17000 ', file_workspace]);
    pause(3)

    qlabs.close();

end

function simLaunch(desireToCalibrate, externalModeFlag)
    % if the calibration flag is set, launch the calibration model
    if desireToCalibrate == true
        modelName = 'QCar2_Virtual_Calibrate';
        open_system(modelName)
        % if external mode flag is set, config model accordingly
        if externalModeFlag == true
            disp('setting external mode in simulink model')
            setActiveConfigSet(modelName, 'externalMode')
        else
            disp('setting normal mode in simulink model')
            setActiveConfigSet(modelName, 'normalMode')
        end
        
        % only autorun if in normal mode
        if externalModeFlag == false
            simout = sim(modelName);
            % if there are no simulink errors
            if isempty(simout.ErrorMessage)
                disp('calibration files angles_new_qcar2.mat and distance_new_qcar2.mat created')
            else
                disp('something may have gone wrong in the calibration')
                disp(simout.ErrorMessage)
            end
        end

        % notify user to re-run the script and run the self driving stack
        fprintf('\nre-run this script to run the self driving stack ....\n')


    % if the calibration flag is not set, run parameter script and launch the self driving stack
    else
        % set up parameters
        issueFlag = Setup_QCar2_Params_Addons(1, 1);
        if issueFlag == true
            error('issue setting up the parameters')
        end
        % open model
        modelName = 'VIRTUAL_self_driving_stack_autoLocalize';  
        open_system(modelName)
        % if external mode flag is set, config model accordingly
        if externalModeFlag == true
            disp('setting external mode in simulink model')
            setActiveConfigSet(modelName, 'externalMode')
        else
            disp('setting normal mode in simulink model')
            setActiveConfigSet(modelName, 'normalMode')
        end

    end
end