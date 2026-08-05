% This script is intended to set up a Windows PC with the QLabs add ons and
% competition resources
% Assumptions:
%   - No QLabs is installed
%   - No QUARC is installed
%   - QLabs not added on
%   - No Githubs have been cloned (Academic or Student Comp)

%% Pre-checks for Windows

% Is this a Windows Machine
if ispc
    fprintf('Windows Detected, nice ....\n')
else
    error('This machine is not being detected as a windows machine!')
end

% Is git installed?
[status, ~] = system('git --version', '-echo');

if status == 0
    fprintf('git has been detected, nice ....\n')
    git_installed_flag = true;
else
    % prompt user to install git
    prompt = 'git was not detected, we will attempt to install it if you want';
    choices = {'yes', 'no'};
    answer = questdlg(prompt, 'git install?', 'yes', 'no', 'yes');
    % install git if desired
    switch answer
        case 'yes'
            [status, cmdout] = system('winget install --id Git.Git -e --silent --accept-source-agreements --accept-package-agreements', '-echo');
        case 'no'
            error('git not detected and will not be installed')
    end
    % check the result of installing
    if status == 0
        fprintf('Successfully installed git!\n')
    else
        disp(cmdout)
        error('Could not install git ....')
    end
end

% recheck git was installed
[status, cmdout] = system('git --version');
if status == 0
    git_installed_flag = true;
else
    disp(cmdout)
    error('git is still not being detected after attempted installation ....')
end

%% Setup QLabs

% check if QLabs already exists somehow on the system

qlabs_installed_flag = false;
qlabsDir = fullfile(getenv('ProgramFiles'), 'Quanser', 'Quanser Interactive Labs');
if isfolder(qlabsDir)
    qlabs_installed_flag = true;
end

% Attempt to add the matlab add on for Quanser Interactive Labs
% Check if Quanser Interactive Labs has been added through Add-Ons
try
    addOnExists = matlab.addons.isAddonEnabled('Quanser Interactive Labs for MATLAB');
catch
    addOnExists = false;
end

if ~addOnExists && qlabs_installed_flag
    error('QLabs seems to be installed but the MATLAB add on is not detected, please uninstall QLabs ....')
end


% if not added on, add it
if ~addOnExists

    % download add on from online
    url = 'https://www.mathworks.com/matlabcentral/mlc-downloads/downloads/10b5302e-ce6e-4dec-8fa7-e6544bf6d35f/b60041fe-f314-4cd5-82a4-a15c8c2afbc3/packages/mltbx';
    fileName = 'Quanser_Interactive_Labs_for_MATLAB.mltbx';
    websave(fileName, url);
    
    % attempt to add matlab add on
    try
        warning('off', 'matlab_addons:install:noAdditionalSoftwareInstall');
        matlab.addons.install("Quanser_Interactive_Labs_for_MATLAB.mltbx", "add", true);
    catch errorMsg
        error(errorMsg.message)
    end

    % delete quanser mltbx since it is no longer needed
    disp('Attempting to delete downloaded file ....')
    delete('Quanser_Interactive_Labs_for_MATLAB.mltbx')

    % attempt to setup QLabs
    try
        QLabs.setup
    catch errorMsg
        error(errorMsg.message)
    end

% if the add on exists check for qlabs installation
else
    % check if qlabs is installed
    qlabsDir = fullfile(getenv('ProgramFiles'), 'Quanser', 'Quanser Interactive Labs');
    if ~isfolder(qlabsDir)
        % if the folder is not detected try running setup command
        try
            QLabs.setup
        catch errorMsg
            error(errorMsg.message)
        end
    end
end

% double check that QLabs was installed at this point
qlabsDir = fullfile(getenv('ProgramFiles'), 'Quanser', 'Quanser Interactive Labs');
if ~isfolder(qlabsDir)
    error('QLabs installation folder not being found ....')
end

%% Reuseable Path Variables and Path Checking
user_path = getenv('userprofile');
documents_dir = fullfile(user_path, 'Documents');
% check for existence
if ~isfolder(documents_dir)
    fprintf('expected documents dir: \n%s\n', documents_dir)
    error('cannot find documents dir!')
end

% ensure this quanser_dir doesn't already exist
quanser_dir = fullfile(documents_dir, 'Quanser');
quanser_dir_exists_flag = false;
if isfolder(quanser_dir)
    fprintf('quanser directory already exists, please remove the following directory and re-run the script:\n%s\n', quanser_dir);
    quanser_dir_exists_flag = true;
end

% ensure this student competition dir does not already exist
competition_dir = fullfile(documents_dir, 'student-competition-resources-matlab');
competition_dir_exists_flag = false;
if isfolder(competition_dir)
    fprintf('student competition directory already exists, please remove the following directory and re-run the script:\n%s\n', competition_dir);
    competition_dir_exists_flag = true;
end
%% Clone Competition Repo

competitionRepoURL = 'https://github.com/quanser/student-competition-resources-matlab.git';
if ~competition_dir_exists_flag && git_installed_flag
    % competition repo with system git
    disp('Attempting to clone the Student Competition Repository ....')
    disp('This could take a few minutes ....')
    command = ['git clone -b virtualONLY ', competitionRepoURL, ' ', competition_dir];
    [status, cmdout] = system(command, '-echo');
    if status == 0
        fprintf('successfully cloned the competition repo ....\n')
    else
        disp('cmdout: ')
        disp(cmdout)
        error('failed to clone the competition repo!')
    end
else
    disp('The Student Competition Github Repo was NOT attempted to be cloned because it may already be cloned ....')
end

%% Clone Academic Repo
academicRepoURL = 'https://github.com/quanser/Quanser_Academic_Resources.git';
% clone academic repo with system git
if ~quanser_dir_exists_flag && git_installed_flag
    disp('Attempting to clone the Quanser Academic Repo ....')
    disp('This could take several minutes as the repository is large ....')
    command = ['git clone ', academicRepoURL, ' ', quanser_dir];
    [status, cmdout] = system(command, '-echo');
    if status == 0
        fprintf('successfully cloned the Academic repo ....\n')
    else
        disp('cmdout: ')
        disp(cmdout)
        error('failed to clone the Academic repo!')
    end
else
    disp('Quanser Academic Resources were NOT attempted to be installed because they may already be cloned ....')
end

% Notification if any cloned repos were not installed
competitionRepoURL = 'https://github.com/quanser/student-competition-resources-matlab/tree/virtualONLY';
if quanser_dir_exists_flag || competition_dir_exists_flag
    fprintf(['\nOne or more of the repositories intended to be cloned may already exist.\n' ...
                'It is your responsibility to investigate why that folder already exists!\n'])
    fprintf(['\nThese repos can be found here:\n', academicRepoURL, '\n', competitionRepoURL, '\n'])
end

%% Final Comments if Completed

% final message and opening of resources
fprintf('\nEverything should now be set up for running the Student Competition Resources!\n')
technicalResourcesURL = 'https://github.com/quanser/student-competition-resources-matlab/blob/virtualONLY/Virtual_MATLAB_Resources/Virtual_MATLAB_How_to_Run_the_Stack.md';
web(technicalResourcesURL)

% Ensure they are directed to register for QLabs
qlabsRegisterURL = 'https://portal.quanser.com/Accounts/Register';
web(qlabsRegisterURL);
prompt = ['At this point, you will need to register for QLabs to gain access to the QCar2 module! ' ...
    'I have opened the registration page in your browser. Please go fill in the form and wait to be added. ' ...
    'This could take 1-2 days until you have access.'];
questdlg(prompt, 'Change directory?', 'yes', 'yes', 'yes');

% change directory to competition directory
prompt = 'Would you like me to change your directory to the competition resources?';
answer = questdlg(prompt, 'Change directory?', 'yes', 'no', 'yes');
switch answer
    case 'yes'
        cd(competition_dir);
end
