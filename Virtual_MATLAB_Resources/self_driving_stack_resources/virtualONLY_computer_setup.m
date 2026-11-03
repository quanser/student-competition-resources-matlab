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

%% Progress Bar Setup

% Close any progress bar left behind by a previous run that errored out
close(findall(0, 'Type', 'figure', 'Tag', 'QuanserSetupWaitbar'));

% The progress bar advances as each stage of the script finishes
totalSteps = 7;
progressBar = waitbar(0, 'Starting setup ....', 'Name', 'Quanser Competition Setup');
set(progressBar, 'Tag', 'QuanserSetupWaitbar');
updateProgress = @(stepNumber, message) waitbar(stepNumber/totalSteps, progressBar, message);
updateProgress(1, 'Windows detected. Checking for git ....');
try
    % Is git installed?
    [status, ~] = system('git --version', '-echo');
    
    if status == 0
        fprintf('git has been detected, nice ....\n')
        git_installed_flag = true;
    else
        % prompt user to install git
        prompt = 'git was not detected, select yes to install git using a default installation';
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
    updateProgress(2, 'git is ready. Setting up the QLabs add-on ....');
    
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
        error(['QLabs seems to be installed but the MATLAB add on is not detected, please uninstall QLabs either by ' ...
            'typing QLabs.remove in the Command Window or by uninstalling it from Add or Remove Programs in Windows. '])
    end
    
    
    % if the add on does not exist, download it and add it
    if ~addOnExists

        % Get the latest version number from online
        rel = webread('https://api.github.com/repos/quanser/Mathworks_QLabs/releases/latest');
        latestVersion = erase(string(rel.tag_name), "v");     % "2.25.0.18"
        % remove the last segment of the versioning
        latestVersion = extractBefore(latestVersion, find(char(latestVersion) == '.', 1, 'last'));

        % construct the url
        urlPart1 = 'https://addons.mathworks.com/registry/v1/addons/packages/10b5302e-ce6e-4dec-8fa7-e6544bf6d35f/';
        urlPart2 = '/-/download/mltbx';
        url = strcat(urlPart1, latestVersion, urlPart2);
        % construct the file name
        fileNamePart1 = 'quanser_labs-';
        fileNamePart2 = '.mltbx';
        fileName = strcat(fileNamePart1, latestVersion, fileNamePart2);
        % websave has no progress callback, so show an indeterminate dialog
        downloadFig = uifigure('Name', 'Downloading');
        downloadDlg = uiprogressdlg(downloadFig, 'Title', 'Downloading', ...
            'Message', 'Downloading the Quanser Interactive Labs add-on ....', ...
            'Indeterminate', 'on');
        try
            websave(fileName, url);
        catch downloadError
            close(downloadDlg);
            close(downloadFig);
            rethrow(downloadError)
        end
        close(downloadDlg);
        close(downloadFig);
    
        % attempt to add matlab add on
        try
            warning('off', 'matlab_addons:install:noAdditionalSoftwareInstall');
            matlab.addons.install(fileName, "add", true);
        catch errorMsg
            error(errorMsg.message)
        end
    
        % delete quanser mltbx since it is no longer needed
        disp('Attempting to delete downloaded file ....')
        delete(fileName)
    
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
    updateProgress(3, 'QLabs is installed. Checking folders ....');
    
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
    updateProgress(4, 'Cloning the Student Competition repository ....');
    
    %% Clone Competition Repo
    
    competitionRepoURL = 'https://github.com/quanser/student-competition-resources-matlab.git';
    if ~competition_dir_exists_flag && git_installed_flag
        % competition repo with system git
        disp('Attempting to clone the Student Competition Repository ....')
        disp('This could take a few minutes ....')
        % --progress forces git to print percentages even when not in a terminal
        command = ['git clone --progress -b virtualONLY ', competitionRepoURL, ' ', competition_dir];
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
    
    updateProgress(5, 'Cloning the Quanser Academic repository (this can take several minutes) ....');
    
    %% Clone Academic Repo
    academicRepoURL = 'https://github.com/quanser/Quanser_Academic_Resources.git';
    % clone academic repo with system git
    if ~quanser_dir_exists_flag && git_installed_flag
        disp('Attempting to clone the Quanser Academic Repo ....')
        disp('This could take several minutes as the repository is large ....')
        % --progress forces git to print percentages even when not in a terminal
        command = ['git clone --progress ', academicRepoURL, ' ', quanser_dir];
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

    % Create the QAL_DIR Environment Variable and check for the 0_libraries
    % folder
    qal_dir = fullfile(quanser_dir, '0_libraries');
    if isfolder(qal_dir)
        setenv('QAL_DIR', qal_dir);
    else
        error('Cannot find 0_libraries in the Quanser Academic Resources after clone. Check folder paths!')
    end
    
    % Notification if any cloned repos were not installed
    competitionRepoURL = 'https://github.com/quanser/student-competition-resources-matlab/tree/virtualONLY';
    if quanser_dir_exists_flag || competition_dir_exists_flag
        fprintf(['\nOne or more of the repositories intended to be cloned may already exist.\n' ...
                    'It is your responsibility to investigate why that folder already exists!\n'])
        fprintf(['\nThese repos can be found here:\n', academicRepoURL, '\n', competitionRepoURL, '\n'])
    end
    
    updateProgress(6, 'Repositories are ready. Finishing up ....');
    
    %% Final Comments if Completed
    
    % complete and close the progress bar
    updateProgress(7, 'Setup complete!');
    pause(1);
    close(progressBar);
    
    % final message and opening of resources
    fprintf('\nEverything should now be set up for running the Student Competition Resources!\n')
    technicalResourcesURL = 'https://github.com/quanser/student-competition-resources-matlab/blob/virtualONLY/Virtual_MATLAB_Resources/Virtual_MATLAB_How_to_Run_the_Stack.md';
    web(technicalResourcesURL)
    
    % Ensure they are directed to register for QLabs
    qlabsRegisterURL = 'https://portal.quanser.com/Accounts/Register';
    web(qlabsRegisterURL);
    prompt = ['At this point, you will need to register for QLabs to gain access to the QCar2 module! ' ...
        'The registration page should be opened in your browser. Please go fill in the form and wait to be added. ' ...
        'This could take 1-2 days until you have access. If you do not receive access in that time period, please email the student competition coordinator.'];
    helpdlg(prompt, 'QLabs Registration?');
    
    % change directory to competition directory
    prompt = 'Would you like to change your active directory to the competition resources?';
    answer = questdlg(prompt, 'Change directory?', 'yes', 'no', 'yes');
    switch answer
        case 'yes'
            cd(competition_dir);
    end
catch errorMsg
    disp(errorMsg.message)
    questdlg('Script failed on something. Please read the Command Window for details. Click OK to continue', 'Script End', 'OK', 'OK');
    close(findall(0, 'Type', 'figure', 'Tag', 'QuanserSetupWaitbar'));
end