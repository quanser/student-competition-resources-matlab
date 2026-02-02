clear all;

%% User configurable parameters

% sets the large SDCS mat
map_type = 1;

% VIRTUAL = 1
% PHYSICAL = 2
qcar_types = 1;

%% Setting Qcar Variables

% Various Timing Loops
Controller_Sample_Time = 1/500;
CSI_Sample_Time = Controller_Sample_Time * ceil(0.033 / Controller_Sample_Time);
RealSense_Sample_Time = Controller_Sample_Time * ceil(0.033 / Controller_Sample_Time);
ImageDisplay_Sample_Time = Controller_Sample_Time * 50;
LiDAR_Sample_Time = Controller_Sample_Time * ceil(1/15 / Controller_Sample_Time);
Audio_Sample_Time = Controller_Sample_Time * 100;
Initialization_Time = 5; %5 seconds to make sure all systems are good
cameraStepSize = 3e-2;

NN_Sample_Time = RealSense_Sample_Time*1;

% Size of lidar capture
SPR_qcar2 = 1000; %Scans per revolution for the LiDAR scan (Long Mode)


% define where the calibration was taken from (2 options)
if map_type == 1
    cal_pos = [0, 2, 0] % large map calibration spot
    disp('Large SDCS Map Being Used ...')
else
    cal_pos = [0, 0, 0] % small map calibration spot
    disp('Small SDCS Map Being Used ...')
end

if qcar_types == 1
    disp('Params Configured for VIRTUAL QCAR ...')
elseif qcar_types == 2
    disp('Params Configured for PHYSICAL QCAR ...')
end

%% QCar Steering PD Controller

if qcar_types == 1 % IF VIRTUAL

    steering_Kp = 1.2;
    steering_Kd = 0.6;

elseif qcar_types == 2 % IF PHYSICAL
    
    steering_Kp = 1;
    steering_Kd = 0.1;

end


%% QCar KF + EKF

GyroKF_sampleTime = 0.001;

if qcar_types == 1 % IF VIRTUAL
    % QCar KF
    GyroKF_X0 = [0;0];
    GyroKF_P0 = eye(2);
    
    GyroKF_Q = diag([0.001, 0.001]); 
    GyroKF_R = 0.05;
    
    
    % QCar EKF
    QCarEKF_sampleTime = GyroKF_sampleTime;
    
    QCarEKF_L = 0.256;
    
    QcarKF_X0 = [0; 0; 0];
    QCarEKF_P0 = eye(3);
    
    QCarEKF_Q = diag([0.001, 0.001, 0.001]);
    
    QCarEKF_R_heading = diag(0.1);
    QCarEKF_R_combined = diag([0.005, 0.005, 0.001]);

elseif qcar_types == 2 % IF PHYSICAL
    
    % QCar KF
    GyroKF_sampleTime = 0.001;
    
    GyroKF_X0 = [0;0];
    GyroKF_P0 = eye(2);
    
    GyroKF_Q = diag([0.01, 0.001]);
    GyroKF_R = 0.01;
    
    
    % QCar EKF
    QCarEKF_sampleTime = GyroKF_sampleTime;
    
    QCarEKF_L = 0.256;
    
    QcarKF_X0 = [0; 0; 0];
    QCarEKF_P0 = eye(3);
    
    QCarEKF_Q = diag([0.00001, 0.00001, 0.00001]);
    
    QCarEKF_R_heading = diag(0.1);
    QCarEKF_R_combined = diag([0.1, 0.1, 0.01]);

end

%% Load Calibration Files

% lidar to map frame rotations

if qcar_types == 1 % FOR VIRTUAL\
    qcar2_virtual_to_physical_lidar_rotation = -7*pi/180;
    qcar2_lidar_to_map_rotation = -1.5 * pi/180;
    qcar2_lidar_to_body_rotation = 0;
elseif qcar_types == 2 % FOR PHYSICAL
    qcar2_virtual_to_physical_lidar_rotation = 0; %remove offset when physical
    qcar2_lidar_to_map_rotation = 2*pi/180;
    qcar2_lidar_to_body_rotation = -pi;
end

% distance and angles need to be loaded from a file based on types of qcars
load distance_new_qcar2.mat;
load angles_new_qcar2.mat;
range_qcar2 = distance_new_qcar2(2: length (distance_new_qcar2), width (distance_new_qcar2)-5);
angles_qcar2 = angles_new_qcar2(2: length (angles_new_qcar2), width (angles_new_qcar2)-5);
range_indicies_qcar2 = find(range_qcar2 == 0);
% range_qcar2(range_indicies_qcar2) = [];
% angles_qcar2(range_indicies_qcar2) = [];

%% Load and Plot Paths

% load pre-defined paths
load ("SDCS_Paths_7.mat");

% plot calibration scan and paths (calibration is the origin)
figure(1)
hold on;

%if using any qcar 2s, plot using qcar 2 calibration scan
polar(-angles_qcar2-qcar2_lidar_to_map_rotation, range_qcar2,'k.');

% plot all paths
plot (path_x4 - cal_pos(1), path_y4 - cal_pos(2));
hold off;
