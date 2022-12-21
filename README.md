# terraform-ecs

This is an example on how to deploy a `fastapi` and `uvicorn` based webapp on AWS ECS cluster running on EC2 instance. The code for webapp and sqlite3 DB logic is under `services` directory in a poetry project. The infrastructure code is under `terraform` directory. `Dockerfile` contains docker image building code for the dummy webapp.

## Prerequisites

The example assumes that AWS VPC and account access with credentials is already there. Before getting started couple of the AWS resources need to be created manually for setting terraform backend on AWS S3 and DynamoDB. The example assumes following names for the resources:

`S3 Bucket`: `unstructured-terraform` \
`DynamoDB Table`: `unstructured_tf`

The partition key for the DynamoDB table is `LockID`. Ofcourse, user can choose to name these resources as they like, however, the name change needs to be refelected in `terraform/main.tf` file.

Following environment variables are required to be set before getting started:

```
AWS_ACCESS_KEY=<your-aws-access-key-id>
AWS_SECRET_KEY=<your-aws-secret-key>
TF_VAR_AWS_ACCESS=<your-aws-access-key-id>
TF_VAR_AWS_SECRET=<your-aws-secret-key>
```

Ensure that these credentials have proper permissions because they will be used to access multiple AWS services and IAM permissions.

## Setting Up Terraform and ECR Repostory

Once he environment variables are set, `cd` to terraform and run executable `setup-tf-ecr.sh` scripts. That should set up terraform backend and create the ECR repository on AWS. The terraform apply part should ouput the repository url at the end of the run, save this for next stage.

## Build and Push Docker Image

Change directory back to the root and execute the following commands in order:

For obtaining ecr credentials: \
`aws ecr get-login-password | docker login -u AWS --password-stdin "https://$(aws sts get-caller-identity --query 'Account' --output text).dkr.ecr.us-east-1.amazonaws.com"`

Building the image: \
`docker build . -t unstructured:latest`

Tag the image for push: \
`aws ecr get-login-password | docker login -u AWS --password-stdin "https://$(aws sts get-caller-identity --query 'Account' --output text).dkr.ecr.us-east-1.amazonaws.com"`

Push the image: \
`docker push <repository_url_output>:latest`

## Provision Rest of the Infrastructure

Change directory to `terraform/` and run the command `terraform apply`. This will show a plan, double check the resources and then type `yes` to apply the plan. Once finished this will output the DNS of the load balancer. From a browser or a HTTP client like PostMan or with curl, call this endpoint and it should return something like following:

```
{
    "deploy_times": [
        "2022-12-21T06:13:00.753558"
    ]
}
```
