#!/bin/bash
# Details: For each GalaxyGroup we calculate the following to monitor the cluster usage

for cluster in $(condor_status -autoformat GalaxyGroup | sort | grep -v undefined | uniq); do
    total_slots=$(condor_status -af Name -constraint 'GalaxyGroup == "'$cluster'" && (SlotType == "Partitionable" || SlotType == "Dynamic")' | wc -l)
    claimed_slots=$(condor_status -af Name -constraint 'GalaxyGroup == "'$cluster'" && State == "Claimed"' | wc -l)
    unclaimed_slots=$(condor_status -af Name -constraint 'GalaxyGroup == "'$cluster'" && State == "Unclaimed"' | wc -l)
    total_cpus=$(condor_status -af DetectedCpus -constraint 'GalaxyGroup == "'$cluster'" && SlotType == "Partitionable"' | paste -s -d'+' | bc)
    claimed_cpus=$(condor_status -af Cpus -constraint 'GalaxyGroup == "'$cluster'" && State == "Claimed"' | paste -s -d'+' | bc)
    unclaimed_cpus=$(condor_status -af Cpus -constraint 'GalaxyGroup == "'$cluster'" && State == "Unclaimed"' | paste -s -d'+' | bc)
    total_memory=$(condor_status -af TotalMemory -constraint 'GalaxyGroup == "'$cluster'" && SlotType == "Partitionable"' | paste -s -d'+' | bc)
    claimed_memory=$(condor_status -af Memory -constraint 'GalaxyGroup == "'$cluster'" && State == "Claimed"' | paste -s -d'+' | bc)
    unclaimed_memory=$(condor_status -af Memory -constraint 'GalaxyGroup == "'$cluster'" && State == "Unclaimed"' | paste -s -d'+' | bc)
    total_gpu_slots=$(condor_status -af Name -constraint 'GalaxyGroup == "'$cluster'" && CUDADeviceName =!= undefined' | wc -l)
    claimed_gpus=$(condor_status -af Name -constraint 'GalaxyGroup == "'$cluster'" && State == "Claimed" && CUDADeviceName =!= undefined' | wc -l)
    unclaimed_gpus=$(condor_status -af Name -constraint 'GalaxyGroup == "'$cluster'" && State == "Unclaimed" && CUDADeviceName =!= undefined' | wc -l)
    echo "htcondor_cluster_usage,classad='cluster',group=$cluster total_slots=$total_slots,claimed_slots=$claimed_slots,unclaimed_slots=$unclaimed_slots,total_cpus=$total_cpus,claimed_cpus=$claimed_cpus,unclaimed_cpus=$unclaimed_cpus,total_memory=$total_memory,claimed_memory=$claimed_memory,unclaimed_memory=$unclaimed_memory,total_gpu_slots=$total_gpu_slots,claimed_gpus=$claimed_gpus,unclaimed_gpus=$unclaimed_gpus"
done
