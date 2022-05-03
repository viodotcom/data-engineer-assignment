# FindHotel's Data Engineer assignment

## Introduction

This assignment is part of the recruitment process of Data Engineers here at FindHotel. The purpose is to asses the technical skills of our candidatess in a generic scenario, similar to the one they would experience at FindHotel.

Please, read carefully all the instructions before starting to work on your solution and feel free to contact us if you have any doubt.

## Repository content

The content of this repository is organised as follows:
- Root directory including:
  - [Dockerfile](.Dockerfile) used to build the `client` docker image for the assignment.
  - [docker-compose](.docker-compose.yaml) file used to launch the `localstack` and `client` docker containers.
  - [Makefile](.Makefile) used in the `client` docker container and that should be used to execute all the necessary steps of the assignment.
  - [zip-lambdas](.zip-lambdas.sh) auxiliary script that can be used to zip the code of the AWS Lambda function(s) deployed in the `localstack` docker container.
- [aws](./aws) directory including a credentials file that allows connecting from the `client` docker container to the `localstack` docker container using the AWS CLI.
- [deployment](./deployment) directory including a sample Terraform script that deploys a S3 bucket and a Lambda function.
- [lambda](./lambda) directory including a `test` Python script for the sample Lambda function.

## Quick start

Follow this steps to get your environment ready for the assignment

1) Fork this repository.

2) Install [Docker](https://docs.docker.com/get-docker/).

3) Go to the root folder of this project and execute the following command to create the Docker images and run the containers:

```bash
$ cd data-engineer-assignment
$ docker-compose up
```

4) You will be working with the `client` container. Whenever you change anything, it is recommended to remove the existing container and image to ensure the latest version is used. You can do this with:

```bash
$ docker ps -a

CONTAINER ID   IMAGE                             COMMAND                  CREATED          STATUS        PORTS  NAMES
e30532b91de5   data-engineer-assignment_client   "/bin/sh -c make"        29 minutes ago   Up 8 seconds         client
fc6259295a34   localstack/localstack             "docker-entrypoint.sh"   25 hours ago     Up 9 seconds   ...   localstack

$ docker stop client
$ docker rm client

$ docker image list

REPOSITORY                        TAG         IMAGE ID       CREATED          SIZE
data-engineer-assignment_client   latest      513762759561   32 minutes ago   619MB
localstack/localstack             latest      24d3ad4fc839   4 days ago       1.52GB

$ docker image rm data-engineer-assignment_client
```

5) You can open a SSH session in the `client` container with:

```bash
$ docker exec -it client /bin/bash
```

6) You can also run specific commands. For example, you can use the AWS CLI to list the files in the `test` S3 bucket:

```bash
$ docker exec client aws --endpoint-url=http://localstack:4566 s3 ls test

2022-05-03 15:17:06         31 20220503151706.json
2022-05-03 15:18:08         31 20220503151808.json
```

## Environment

The default configuration in this repository will create two Docker containers:
- `localstack`:
  - Uses the [localstack](https://hub.docker.com/r/localstack/localstack) Docker image
  - Localstack is a local and limited emulation of AWS, which allows deploying a subset of the AWS resources.
  - It will be used to deploy a simple data infrastructure and run the assignment tasks.
  - This container should be used as is.
- `client`
  - Uses a custom Docker image defined in the [Dockerfile](.Dockerfile) and it is based on Ubuntu 20.04.
  - It is used to interact with the `localstack` container.
  - It has some tools pre-installed (Terraform, AWS CLI, Python, etc.).
  - This container and/or its components can (and should) be modified in order to complete the assignment.

The `client` container is configured in the following way:
- All the necessary tools and resources are installed and copied using the [Dockerfile](.Dockerfile).
- The entry point of the container is the [Makefile](.Makefile).
- The default [Makefile](.Makefile) takes care of:
  - Waiting for the `localstack` container to be up and running.
  - Zipping the [lambda](lambda/) function code.
  - Deploying a `test` S3 bucket and a `test` Lambda function defined in the [main.tf](deployment/main.tf) Terraform script.
  - Checking the deployed resources using the AWS CLI.
  - Invoking the Lambda function every 60 seconds using the AWS CLI.

The sample [test](lambda/test/test.py) Lambda function creates a dummy `YYYYMMDDhhmmss.json` object in S3 every time it is invoced.

## Assignment

TODO

## References

- [LocalStack docs](https://docs.localstack.cloud/overview/)
- [Terraform docs](https://www.terraform.io/docs)
- [Terraform AWS provider docs](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [AWS CLI docs](https://docs.aws.amazon.com/cli/latest/index.html)
- [AWS Python SDK docs](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)
