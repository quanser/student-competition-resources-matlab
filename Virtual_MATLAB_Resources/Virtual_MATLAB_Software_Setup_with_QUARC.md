# Virtual MATLAB Software Setup 🪧 <!-- omit in toc -->

Please go through the following steps to set up a computer to use the QCar with MATLAB in Quanser Interactive Labs.

## Description <!-- omit in toc -->

This document will cover the following:

- [System Requirements](#system-requirements)
- [Setting up Quanser Interactive Labs (QLabs) with MATLAB](#setting-up-quanser-interactive-labs-qlabs-with-matlab)
- [Setting Up the MATLAB Competition Resources](#setting-up-the-matlab-competition-resources)
- [Running the Resources](#running-the-resources)

By the end of this document, you will have the following development environment set up:

## System Requirements

`OS:` Windows 10 or 11

`MATLAB Version:` 2024a or higher

`MATLAB Toolboxes:` Simulink Coder, MATLAB Coder, and Control System Toolbox

`C++ Compiler:` [Visual Studio 2019 Community](https://dl.boxcloud.com/d/1/b1!G3gNCWCvPc1wgzxAOhjrlw2WavrVW8dFZteiZo8DCD5LOjWYsoyv1Gkvv4TDcck7p8SthF-L7CrdgV_bVQSGVf3Va09Aepqivq5e-y-Mb3D3X2xpPjtSsKfJgyzefE5jSO09eLO7spIEu2lMI1dVT5SYMOhfSBR31C8ouVIu39-7fhzq0Xu0GCijXe2LainBIOdNtvVW79Ue7JhgH5lcu-C6EUAeOCqo0-bVPAs_Xhtsooc6jyjqUX6ob0JKHCB0IZ3YO0LvGMMsbt8RM9os1vD4wjBZzUir-svHBp-pIsmnVg6RAyuu6yuT_UzsmUt1MEfQXPghMU3tOkoHwU0Kfft6vmupdBdbPBaKRZ7BmdueA4q6w4Z1Pdk3TJ0MeQikd8fd6krB8sbz8HqhydiNgfqO6_vGCEfvNI5fb6XUsAa20jw13VTs_fB99g5SSiTeZXiGGoHn-KROecZ0KuTAz_IEs1l3I0mKrYEB9SNLdJ6vCamXT-_LPPVNfyyVwzuMI4ANdII_8W87MS3leCUVecf_LecnWiQO7Y_Q471lJQkWZZBtbnyfnlh8cdR-_RO5VNd90a09WjIRT52TuE72zqrNYuGCIhEpQhkbXCuNNvnGYDwZ5BThyHvCy-ny4bLgeQsv_iF26m67pPDpvn8TzyD7OaNGGY853NQjECVZNR3nyr7JORuNEIcRHHQOGHEFyj2wHPBryftSiHpe9gnNFx9HO2S7QvhsPBWQcHvyQ7YmNT7XLzUxxKWISghhBHdNXJuTN_I_vW_p9KNYgb139cgGzYFYj5sBDRDt_x-lyejPACYloWjHc9rdQSeosBBAfEnrjNSzJY7cMk4KMQfbsQ5cSCseNwHoq1QQmdvCTzClq8_--7Pmuh5-aeGWStAxcCtPLXH2abf7_Otp09jWE3zlYIryrnaCBUQNCww_fhmt0Bc18Ex3qeaapLBwvzqeurpnIZ9-dbwv9iHVGDbhPW4ApKyn1wAiuUl3omTtlLD8JS124zRfJUy-10I-AxXU6BrZV_DPvORn2PoH2p4e2uYbhuJh_3_m3rU-TPAnIqS0ucO2wJheBE_Oj3BCUBWon4IR4tcY4nWDo4ArKVLA_oKi_qrQSP2j5G47PQuDhObQyir_JX_Wy3QB-trKUUKCgvlvxaoFQUeuAP94HKU9Ks_mpVkb7cZdgrWXArn7C1ST5oApycI69ThO-Yl8Rdj3fHekx8OxEi05GRPTGM-qhWpozzkvS9k004nTdLXRyoQsyBSrbZUWYam5ZICrTImeHCKBg6XMwzKEZzmD_aX7XgE_Z41PRidPIWQxh5ORo0NQzattTdX-6nrESaPBH3OR1uEoM2R6hmbzf1rZxC5NbEcWKiSlf5IEfJdvAouyeyTvZgb-zoFIkB39l2KtqWckzwGLkykBN1xQU-2Oau3tl3JbcG9yknivbS1v1rUye0IlDV1HqSZlrdrEgr0KOlDI1fSP3gpDyVh1hChnLVQMBHIHhoxWzkbRIflbZ7zl6Ld2q_69/download) (Desktop development with C++)

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

1. Download the [Competition License file](https://quanserinc.box.com/shared/static/q5o3t3yl5att8h4qsvzzqhkgy3chroe5.qlic)

2. Download the [QUARC 2025 SP1 Installer](https://download.quanser.com/installers/2025/install_quarc.exe)

3. Follow this guide to install QUARC 2025 SP1 (this will install QLabs): [QUARC 2025 SP1 Installation Guide](https://download.quanser.com/doc/2025sp1/QUARC_Quick_Installation_Guide_Local_License.pdf)

    a. Use the license file (.qlic) you installed in Step 1 along with the guide

4. Register for QLabs on the [Quanser Academic Portal](https://portal.quanser.com/Accounts/Register)

## Setting Up the MATLAB Competition Resources

**First**, the Quanser Academic Resources will be installed:

1. Follow the instructions here to download the Quanser Academic Resources: [Quanser Academic Resources Download](https://github.com/quanser/Quanser_Academic_Resources?tab=readme-ov-file#downloading-resources)

2. Run the following two batch files:

   ```matlab
   C:\Users\<username>\Documents\Quanser\1_setup\step_1_check_requirements.bat
   C:\Users\<username>\Documents\Quanser\1_setup\configure_matlab.bat
   ```

    These resources will contain all the Quanser Resources for all of Quanser's products, but the [SDCS lab content](https://github.com/quanser/Quanser_Academic_Resources/blob/dev-windows/docs/start_labs.md#sdcs) will be the most relevant.

**Second**, the Github repo containing the student competition resources for MATLAB will be downloaded:

1. Navigate to your Documents folder within a File Explorer window

2. Open a CMD Window in this directory by right-clicking in the blank space and selecting `Open in Terminal`

<center>

![open_in_terminal](../Pictures/open_in_terminal.png)

</center>

3. Clone the following Github Repo into the Documents folder using the following command:

    ```bash
    git clone https://github.com/quanser/student-competition-resources-matlab.git
    ```

## Running the Resources

Follow the below instructions to make sure everything is set up correctly and learn how to use the provided resources:

1. Using MATLAB navigate to the `student-competition-resources-matlab` (make sure you double -click on folders and don't expand them)

2. Open QLabs and navigate to `Self-Driving Car Studio` => `Plane`

    ![qlabs plane](../Pictures/plane_world_qlabs.png)

3. Run the `Setup_Competition_Map.m` script

    a. Make sure the `spawn_location` variable is `1` (top of the script)

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
