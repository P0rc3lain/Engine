# ``Engine``

The library is meant to provide a functionality helping in the process of rednering three-dimensional scenes.
It encapsulates low-level interactions with GPU and limitates the need of math usage.
Suitable for small games as well as utility applications.

## Overview

In order to create an example scene a specific process needs to be followed. 
The user must first prepare a window suitable for showing the engine's content.
In the next step load assets needed and finally pass them to the engine.
It is highly encouraged to read the topics in the above order if not used as a reference.

## Topics

### Scene

Contains symbols that are closely related to the objects that might be presented on the scene graph.
Core building blocks or content of nodes.

- <doc:Animation>
- <doc:Lights>
- <doc:Material>
- <doc:Particle>
- <doc:Bound>
- <doc:Camera>
- <doc:Mesh>

### Graph

Provides information about organization of the nodes themselves.
Includes all of the types and the components used for flattening purposes of the graph.

- <doc:Organization>
- <doc:Transcription>

### Assets

Management of assets that may be part of the scene.
Load and further processing of the data.

- <doc:Import>

### Framework

Related to the framework itself.
Configuration, core components and task planning.

- <doc:Utility>
- <doc:Task>
- <doc:Main>
- <doc:Math>
- <doc:Config>

### Interface

Components of interface that can be included in the application.

- <doc:UI>
- <doc:Reactive>

### Data

Management of data, storing both dynamically allocated as well as static buffers.
Including CPU-based, exclusive GPU stores and hybrid use-cases.

- <doc:Buffer>
