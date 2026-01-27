# Virtual MATLAB Software Setup 🪧 <!-- omit in toc -->

Please go through the following steps to set up a computer to use the QCar with MATLAB in Quanser Interactive Labs.

## Description <!-- omit in toc -->

This document will cover the following:

- [System Requirements](#system-requirements)
- [Setting up Quanser Interactive Labs (QLabs) with MATLAB](#setting-up-quanser-interactive-labs-qlabs-with-matlab)
- [Setting Up the MATLAB Competition Resources](#setting-up-the-matlab-competition-resources)
- [Running the Self-Driving Stack Resources](#running-the-self-driving-stack-resources)
- [MATLAB Setup Real Scenario](#matlab-setup-real-scenario)
- [Learning the Self-Driving Stack](#learning-the-self-driving-stack)

## System Requirements

`Installation Time:` It will take around **2 hours** to install everything

`Storage:`: Installing everything will consume around **35GB of storage**

`OS:` Windows 10 or 11

`MATLAB Version:` 2024a or higher

`MATLAB Toolboxes:` Simulink Coder, MATLAB Coder, and Control System Toolbox

`C++ Compiler:` [Visual Studio 2019 Community](https://quanserinc.box.com/s/ffe1ud4hikxdau9qwdlxf0ali07d1l6c) (Desktop development with C++)

`Minimum Hardware:`

- Graphics Card: Intel UHD or Intel Iris Xe integrated GPU, or equivalent
- Processor: Intel Core Ultra 5, Intel Core i5, AMD Ryzen 5, or equivalent
- Memory: 8 GB RAM

`Recommended Hardware:`

- Graphics Card: 4050m or equivalent
- Processor: i5-13500HX or equivalent
- Memory: 16 GB RAM

**Note**: Recommended hardware is based on the hardware used to develop and run self-driving stack in Simulink.

## Setting up Quanser Interactive Labs (QLabs) with MATLAB

Follow the below steps to set up QLabs with MATLAB:

WARNING: Ensure you do not already have QUARC or Quanser Interactive Labs installed on this PC (uninstall them if you do).

1. Ensure you have [registered for your competition](https://quanser.github.io/student-competitions/) (Necessary for gaining access to QLabs). This could take a few days.

2. Download the [Competition License file](https://quanserinc.box.com/shared/static/q5o3t3yl5att8h4qsvzzqhkgy3chroe5.qlic)

3. Download the [QUARC 2025 SP1 Installer](https://download.quanser.com/installers/2025/install_quarc.exe)

4. Follow this guide to install QUARC 2025 SP1 (this will install QLabs): [QUARC 2025 SP1 Installation Guide](https://download.quanser.com/doc/2025sp1/QUARC_Quick_Installation_Guide_Local_License.pdf)

    - Use the license file (.qlic) you downloaded in Step 1 along with the guide

5. Register for QLabs on the [Quanser Academic Portal](https://portal.quanser.com/Accounts/Register)

## Setting Up the MATLAB Competition Resources

**First**, the Quanser Academic Resources will be installed:

1. Follow the instructions here to download the Quanser Academic Resources: [Quanser Academic Resources Download](https://github.com/quanser/Quanser_Academic_Resources?tab=readme-ov-file#downloading-resources)

2. Run the following batch file with the following guidelines:

    - You are using MATLAB only
    - You are using both virtual and hardware

    `C:\Users\<username>\Documents\Quanser\1_setup\step_1_check_requirements.bat`

3. Run the following batch file:

    `C:\Users\<username>\Documents\Quanser\1_setup\configure_matlab.bat`

These resources will contain all the Quanser Resources for all of Quanser's products, but the [SDCS lab content](https://github.com/quanser/Quanser_Academic_Resources/blob/dev-windows/docs/start_labs.md#sdcs) will be the most relevant.

**Second**, the Github repo containing the student competition resources for MATLAB will be downloaded:

1. Navigate to your Documents folder within a File Explorer window

2. Open a CMD Window in this directory by right-clicking in the blank space and selecting `Open in Terminal`

    ![open_in_terminal](../Pictures/open_in_terminal.png)

3. Clone the following Github Repo into the Documents folder using the following command:

    ```bash
    git clone https://github.com/quanser/student-competition-resources-matlab.git
    ```

## Running the Self-Driving Stack Resources

Follow the below instructions to make sure everything is set up correctly and learn how to use the provided resources:

1. Using MATLAB navigate to the `/student-competition-resources-matlab/Virtual_MATLAB_Resources/self_driving_stack_resources` (make sure you double -click on folders and don't expand them)

2. Open QLabs and navigate to `Self-Driving Car Studio` => `Plane`

    ![qlabs plane](../Pictures/plane_world_qlabs.png)

3. Run the `Setup_Competition_Map.m` script

    - Make sure the `spawn_location` variable is `1` (top of the script)

    It should look like this after running the script:

    ![competition map](../Pictures/qlabs_setup_competition_map.png)

4. Open `QCar2_Virtual_calibrate.slx`

5. Use 'Monitor & Tune' to run the model

    ![competition map](../Pictures/monitor_and_tune.png)

6. Change `spawn_location` to `2` in the `Setup_Competition_Map.m` script

7. Run `Setup_Competition_Map.m` to spawn the QCar in the taxi hub area

8. Run `Setup_QCar2_Params.m`

9. Open `VIRTUAL_self_driving_stack_v2.slx`

10. Use 'Monitor & Tune' to run the model

    ![competition map](../Pictures/monitor_and_tune.png)

You should see the QCar begin to complete a lap of the outside-most lane as shown below (sped up):

![1 lap self drivning stack](../Pictures/1_lap_self_driving_stack.gif)

If something is not working correctly, please double-check that you have gone through the steps correctly. If the issue persists, you may raise an issue in the [Issues tab](https://github.com/quanser/student-competition-resources-matlab/issues)

## MATLAB Setup Real Scenario

A more realistic traffic scenario is provided through the [`Setup_Real_Scenario.m`](../Virtual_MATLAB_Resources/self_driving_stack_resources/Setup_Real_Scenario.m) file. This script spawns signage and traffic lights. This script runs CONTINUOUSLY in a loop to control the traffic lights, so it will need to be run in a separate MATLAB session from the `VIRTUAL_self_driving_stack_v2.slx`. To open another session of matlab, you will need to right-click on the MATLAB icon and select your version of MATLAB again.

## Learning the Self-Driving Stack

Once everything is confirmed and working, you can take a look at the [development guide](./Virtual_MATLAB_Development_Guide.md).
