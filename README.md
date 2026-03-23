# Windows ETW Manifest Archive
A centralized repository of **Event Tracing for Windows (ETW)** provider manifests extracted from various Windows versions and builds.

## Overview
This project serves as an offline reference for security researchers, reverse engineers, and developers. It contains XML definitions (manifests) for ETW providers, which outline event structures, IDs, task names, and opcode definitions.

## The Extraction Script
The repository includes a PowerShell automation script (`Export-ETWManifests.ps1`) designed to simplify the extraction process.

### PerfView
`PerfView` is a free, open-source performance analysis tool developed by Microsoft. While it is primarily used for CPU and memory profiling, it includes advanced capabilities for interacting with Event Tracing for Windows (ETW), such as dumping registered provider manifests and exploring event metadata.
To use the extraction script, you must download the PerfView.exe binary from the official [Microsoft GitHub repository](https://github.com/microsoft/perfview/releases).

## Manifest Field Definitions
The following table describes the primary fields found within the extracted XML manifests:

| Field | Description |
| :--- | :--- |
| **Event ID** | A unique numerical identifier for a specific event type within the provider. |
| **Task** | A logical grouping of related events (e.g., "File I/O", "Registry Operations"). |
| **Opcode** | Identifies the specific operation within a task (e.g., "Start", "Stop", "Info"). |
| **Keyword** | A 64-bit bitmask used for high-level filtering (e.g., "Security", "Network", "Performance"). |
| **Level** | Indicates the severity or verbosity of the event (e.g., "Critical", "Error", "Informational"). |
| **Template** | Defines the data structure and fields (payload) included with the event. |
