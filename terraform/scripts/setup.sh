#!/bin/bash

sudo mkdir /instance-vol
sudo mkdir /etc/ecs
sudo mkfs -t xfs /dev/nvme1n1
sudo mount /dev/nvme1n1 /instance-vol
sudo echo ECS_CLUSTER=ecs-cluster-for-unstructured >> /etc/ecs/ecs.config
