# Virtual MATLAB Development Guide 🪧 <!-- omit in toc -->

This document covers the information necessary to navigate the current self-driving stack that is provided by Quanser and eventually iterate on it.

## Topics <!-- omit in toc -->

This document will cover the following:

- [Overview of the Architecture](#overview-of-the-architecture)
- [Conventions](#conventions)

## Overview of the Architecture

The self-driving stack is a resource that Quanser provides and is continuously being worked on by Quanser engineers. There are many things to improve on and the methods used are not necessarily the best, so any and **all aspects of this stack should be questioned and improved upon**.

This is a very computationally intense self-driving stack. Keep in mind that if the CPU and GPU of your computer is not powerful (see [system requirements](./../README.md#-system-requirements-)) this stack will perform significantly worse.

Here is the [guide for running the self-driving stack](./Virtual_MATLAB_How_to_Run_the_Stack.md) for reference.

## Conventions

**Goto and From Blocks:**

The self-driving stack utilizes many `goto` and `from` blocks to move signals through the model. This is because using lines becomes extremely messy when there are a large amount of signals.

![goto blocks](../Pictures/self_driving_stack_goto_blocks.png)

**Subsystem Inports and Outports:**

There are many inports and outports to each of the subsystems within the model. To easily identify what signals are intended to be connected, the name, signal size, and units/data types are used in the following format [ `<signalName> [size] (units)` ]:

![subsystem signals example](../Pictures/self_driving_stack_subsystem_signals.png)

**Subsystem Colors:**

Certain colors of subsystems represent different types of self-driving components:

- <span style="color: red;"> Red </span>: I/O of the QCar hardware
- <span style="color: lightblue;"> Blue </span>: Controllers (mainly for speed and steering)
- <span style="color: lightgreen;"> Green </span>: Interpretation of the environment
- <span style="color: orange;"> Orange </span>: Decision and planning
- <span style="color: pink;"> Pink </span>: Monitoring timings

