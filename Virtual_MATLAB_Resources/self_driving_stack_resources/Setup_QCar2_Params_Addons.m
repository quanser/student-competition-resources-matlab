function issueFlag = Setup_QCar2_Params_Addons(qcar_types, map_type)

    issueFlag = false;

    % perform check that inputs are valid
    if ~(qcar_types == 1) && ~(qcar_types == 2)
        print('Invalid QCar Type!')
        issueFlag = True;
        return
    end
    % check if map input is allowed
    if ~(map_type == 1) && ~(map_type == 2)
        print('Invalid Map Type!')
        issueFlag = true;
        returnZ
    end

    % check if the paths file exists in the active dir
    if ~exist('SDCS_Paths_7.mat','file')
        print('Missing paths file (SDCS_Paths_7.mat)')
        issueFlag = true;
        return
    end


    %% Setting Qcar Variables

    % Load Various Timing Loops into workspace
    Controller_Sample_Time = 1/500;
    assignin('base', "Controller_Sample_Time", Controller_Sample_Time)
    assignin('base', "CSI_Sample_Time", Controller_Sample_Time * ceil(0.033 / Controller_Sample_Time))
    assignin('base', "RealSense_Sample_Time", Controller_Sample_Time * ceil(0.033 / Controller_Sample_Time))
    assignin('base', "ImageDisplay_Sample_Time", Controller_Sample_Time * 50)
    assignin('base', "LiDAR_Sample_Time", Controller_Sample_Time * ceil(1/15 / Controller_Sample_Time))
    assignin('base', "Audio_Sample_Time", Controller_Sample_Time * 100)
    assignin('base', "Initialization_Time", 5)
    assignin('base', "cameraStepSize", 3e-2)
    assignin('base', "SPR_qcar2", 1000)   
    
    % define where the calibration was taken from (2 options)
    if map_type == 1
        cal_pos = [0, 2, 0]; % large map calibration spot
        assignin('base', "cal_pos", [0, 2, 0])  
        disp('Large SDCS Map Being Used ...')
    else
        cal_pos = [0, 0, 0]; % small map calibration spot
        assignin('base', "cal_pos", [0, 0, 0])  
        disp('Small SDCS Map Being Used ...')
    end
    
    if qcar_types == 1
        disp('Params Configured for VIRTUAL QCAR ...')
    elseif qcar_types == 2
        disp('Params Configured for PHYSICAL QCAR ...')
    end
    
    %% QCar Steering PD Controller
    assignin('base', "steering_Kp", 1)
    assignin('base', "steering_Kd", 0.1)
    
    %% Load and Plot Paths
    
    % load pre-defined paths
    load("SDCS_Paths_7.mat");
    
    % plot calibration scan and paths (calibration is the origin)
    figure(1)
    hold on;
    
    % plot all paths
    plot (path_x4 - cal_pos(1), path_y4 - cal_pos(2));
    hold off;

    % assign path variables
    assignin('base', "path_x4", path_x4)
    assignin('base', "path_y4", path_y4)

end