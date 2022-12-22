#!/bin/bash

sudo mkdir /instance-vol
sudo mkdir /etc/ecs
sudo mkfs.ext4 /dev/nvme1n1
sudo mount /dev/nvme1n1 /instance-vol
sudo echo ECS_CLUSTER=ecs-cluster-for-unstructured >> /etc/ecs/ecs.config
