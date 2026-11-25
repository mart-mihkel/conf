---
name: hpc-rocket
description: Univeristy of Tartu HPC Rocket usage guide.
---

# Rocket

Rocket is a heterogeneous HPC cluster that currently consists of 50 compute nodes, featuring almost 12000 cores, a bit over 5 terabytes of memory and 64 GPUs, interconnected by high-speed low-latency Infiniband networking. The cluster also utilizes two General Parallel File systems, which in total provide more than 10 petabytes of usable storage space.

This cluster is available to University of Tartu, and to third parties via ETAIS. One can access the cluster via SSH at `rocket.hpc.ut.ee`.

[Documentation](https://docs.hpc.ut.ee/public/)

## Pricing

- **Memory** 0.012 EUR/6GB/h
- **CPU** 0.012 EUR/core/h
- **GPU** from 0.5 EUR/GPU/h

Memory usage is calculated by 6 GB segments. Accounting for the use of the computing servers is based on the amount of memory (1 unit = 6 GB of RAM/h) and processors (1 unit = 1 core/h) allocated to the user's job(s). The price is based on whichever resource has more units allocated to it. For instance, for a job that uses 1 core and 2 GB of memory, and runs for 10 hours, the price is `max(1, 2/6) * 10 * 0.012 = 0.12` euros, but for a job that uses 1 core and 12 GB of memory, and runs for 10 hours, the price is `max(1, 12/6) * 10 * 0.012 = 0.24` euros.

## Jobs

Every job submitted to the scheduling system is subject to resource limits. This is necessary to prevent, for example, one user from taking up all the resources of the entire cluster for an indefinite time period. In general, UTHPC tries to specify the limits based on the following guidelines:

- The number of long-running jobs should be minimal - long-running jobs that don't have checkpoints and can't resume work in the event of an interruption, such as a system failure, are generally inefficient and error-prone, and can easily result in a significant amount of wasted CPU time.
- Shorter jobs should have greater priority – short jobs allow the scheduling system to place the work of different users on available resources more optimally, therefore increasing the overall throughput of the cluster.
- Parallel jobs have greater priority – since parallel jobs are essentially what compute clusters are for, they get prioritized as much as possible. Since they can also be difficult to test and debug, and may need multiple restarts for example due to changing a parameter, this prioritization also shortens their turnover time.
- Fair sharing of resources – one of the main goals of the scheduling system is to ensure that all users get allocated an equal share of the available resources. For example, when someone has already ran a lot of jobs, the scheduling system pushes their still-pending jobs a little bit down the queue to allow others to get their fair share of the available resources.

### Don't use the head node for calculations

The head nodes (`login.hpc.ut.ee`) are for facilitating interactions with the queue, and for data movement. Don't run any kind of processing on the head nodes, as this negatively impacts other users. User sessions on the login nodes are limited to 6 GB of RAM and 2 CPU cores.

This also means if you need to compile software, use `sbatch` or `srun`.

### Partitions

| Partition | DefaultTime | MaxTimeLimit | Nodes                                                 | CPU cores1 | Comments                                              |
| --------- | ----------- | ------------ | ----------------------------------------------------- | ---------- | ----------------------------------------------------- |
| testing   | 10 minutes  | 2 hours      | ares(18, 20)                                          | 256        | Only for short testing jobs.                          |
| AMD       | 10 minutes  | 8 days       | ares(1-20), artemis(1-20)                             | 5120       | Main job queue, high core density.                    |
| main      | 10 minutes  | 8 days       | ares(1-20), artemis(1-20)                             | 5120       | Alias for AMD partition, default destination of jobs. |
| long      | 8 days      | 30 days      | artemis17                                             | 256        | Long-running jobs.                                    |
| GPU       | 10 minutes  | 8 days       | falcon(1-6), pegasus(1-2), firefly(1-3), shepard(2-3) | N/A        | Utilising GPUs                                        |

### Nodes

| Node         | Cores | GPUs          | GPU TFLOPs (FP32) | GPU TFLOPs (Tensor/AI) | RAM    | Cores per GPU | RAM per GPU |
| ------------ | ----- | ------------- | ----------------- | ---------------------- | ------ | ------------- | ----------- |
| falcon(1-2)  | 24    | 6 V100 32 GB  | 14                | 112 (FP16)             | 500 GB | 4             | 80 GB       |
| falcon3      | 48    | 6 V100 16 GB  | 14                | 112 (FP16)             | 500 GB | 8             | 80 GB       |
| falcon(4-6)  | 32    | 8 V100 32 GB  | 15.7              | 125 (FP16)             | 500 GB | 4             | 60 GB       |
| pegasus      | 96    | 4 A100 40 GB  | 19.5              | 312 (BF16)             | 500 GB | 24            | 120 GB      |
| pegasus2     | 128   | 8 A100 80 GB  | 19.5              | 312 (BF16)             | 2 TB   | 16            | 250 GB      |
| firefly(1-3) | 128   | 4 H200 141 GB | 60                | 1671 (BF16)            | 1.5 TB | 32            | 375 GB      |
| shepard(2-3) | 256   | 8 B200 192 GB | 75                | 2250 (BF16)            | 3 TB   | 32            | 375 GB      |

### Limits

| Partition | MaxWalltime         | Nodes                                                      | CPU cores | Comments                             |
| --------- | ------------------- | ---------------------------------------------------------- | --------- | ------------------------------------ |
| testing   | 2:00:00 2 hours     | artemis20                                                  | 256       | Only for short testing jobs.         |
| long      | 30-00:00:00 30 days | artemis17                                                  | 256       | Long-running jobs.                   |
| GPU       | 8-00:00:00 8 days   | falcon(1-6), pegasus, pegasus2, firefly(1-3), shepard(2-3) | N/A       | Jobs utilizing GPUs.                 |
| AMD       | 8-00:00:00 8 days   | ares(1-20), artemis(1-20)                                  | 5120      | Nodes using AMD EPYC 7702 processors |
| main      | 8-00:00:00 8 days   | ares(1-20), artemis(1-20)                                  | 5120      | Alias for the AMD partition          |
