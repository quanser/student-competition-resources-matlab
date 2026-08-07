# How to Run the Self Driving Stack 🪧 <!-- omit in toc -->

Everything pertaining to running the `/self_driving_stack_resources` is found here.

## Description <!-- omit in toc -->

Please use the following guide to run the Self Driving Stack after completing the [Virtual Software Setup Guide](./Virtual_MATLAB_Software_Setup.md) or the
[Manual Software Setup Guide](./Virtual_MATLAB_Manual_Software_Setup.md):

- [Running the Self-Driving Stack Resources](#running-the-self-driving-stack-resources)
- [MATLAB Setup Real Scenario](#matlab-setup-real-scenario)
- [Next Steps](#next-steps)
  - [Learning the Self-Driving Stack](#learning-the-self-driving-stack)

## Running the Self-Driving Stack Resources

Follow the below instructions to make sure everything is set up correctly and learn how to use the provided resources:

1. Using MATLAB navigate to the `Documents/student-competition-resources-matlab/Virtual_MATLAB_Resources/self_driving_stack_resources` (make sure you double -click on folders and don't expand them)

2. Open QLabs and navigate to `Self-Driving Car Studio` => `Plane`

    ![qlabs plane](../Pictures/plane_world_qlabs.png)

3. Run the `Virtual_Setup_Competition_Map.m` script and when prompted to `Setup real scenario?`, type `n`

4. Use `run` button to run the simulink model once it opens

   ![competition map](../Pictures/simulink_run_button.png)

You should see the QCar begin to complete a lap of the outside-most lane as shown below (sped up):

![1 lap self drivning stack](../Pictures/1_lap_self_driving_stack.gif)

If something is not working correctly, please double-check that you have gone through the steps correctly. If the issue persists, you may raise an issue in the [Issues tab](https://github.com/quanser/student-competition-resources-matlab/issues)

## MATLAB Setup Real Scenario

In the `Virtual_Setup_Competition_Map.m` script, you will be prompted to setup the real scenario if it is desired.

A more realistic traffic scenario is provided through the `Setup_Real_Scenario.m` file. This script spawns signage and traffic lights.

This script runs CONTINUOUSLY in a loop to control the traffic lights. If this scenario is desired, selecting `y` in the `Virtual_Setup_Competition_Map.m` script when prompted will open a MATLAB Command Window to run the Real Scenario in a separate instance of MATLAB.

## Next Steps

This self-driving stack should now be set up to develop with, most of the competitions use the [Detailed Scenario](https://quanser.github.io/student-competitions/events/common/Rules_and_Objectives/Virtual_Detailed_Scenario.html) as an objective to shoot for. If you can complete this, you will have a good understanding of this self-driving stack.

### Learning the Self-Driving Stack

To learn the architecture of the self-driving stack and the different components, please read the  [development guide](./Virtual_MATLAB_Development_Guide.md).
