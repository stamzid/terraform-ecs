#!/bin/bash

terraform init
terraform apply -target=aws_ecr_repository.unstructured-repo -auto-approve
