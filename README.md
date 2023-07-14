# Moshpitters Model

## Introduction

This repository contains a simulation model called "Moshpitters Model". It simulates the behavior of active and inactive moshpitters in a concert venue. The model uses NetLogo, a multi-agent programming language, to create the simulation.

## Model Description

The Moshpitters Model consists of the following components:

### Turtles

The model defines three turtle breeds:

- `active-moshpitters`: Represents the active moshpitters.
- `inactive-moshpitters`: Represents the inactive moshpitters.
- `characters-person`: Represents the singers on the stage.

Each turtle breed has its own set of variables, such as activity status, collision counter, shape, size, and color.

### Global Variables

The model also defines several global variables that track various aspects of the simulation, including the number of moshpitters, the total time ticks, and the count of active red moshpitters.

### Setup Functions

The code includes several setup functions that initialize the world, stage, characters, walls, and moshpitters.

- `setup`: Sets up the initial state of the model.
- `setup-stage`: Sets up the blue stage in the venue.
- `setupCharacters`: Sets up the singers on the stage.
- `setup-walls`: Sets up the blue square wall around the venue.
- `setupMoshpitters`: Sets up the active and inactive moshpitters.

### Behavior Functions

The model includes behavior functions that define the interactions and movements of the agents:

- `check-collision`: Checks for collisions between active and inactive moshpitters.
- `jitter`: Controls the random movement of inactive moshpitters.
- `jitterActivemoshpitters`: Controls the movement of active moshpitters towards their closest neighbor or random jitter.

### Simulation Control

- `go`: Represents the main simulation loop. It controls the movement of moshpitters, checks for collisions, and stops the simulation when all moshpitters become active.

### Report Functions

The model includes report functions that provide information about the state of the simulation:

- `avg-moshpit-time`: Reports the average time it takes for all moshpitters to become active.
- `percentage-inactive-Moshpitters`: Reports the percentage of inactive moshpitters in the model.

## Usage

To run the Moshpitters Model, follow these steps:

1. Download and install [NetLogo](https://ccl.northwestern.edu/netlogo/) on your computer.
2. Open NetLogo and load the Moshpitters Model.
3. Set the desired parameters, such as the number of moshpitters.
4. Click the "Setup" button to initialize the model.
5. Click the "Go" button to start the simulation.
6. Monitor the simulation and observe the behavior of the moshpitters.

## Results

The Moshpitters Model provides insights into the dynamics of active and inactive moshpitters in a concert setting. It can be used to study crowd behavior, analyze the impact of different parameters, and explore strategies to optimize crowd control.


