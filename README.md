# Solutions

#Quest

I have solved this using a ECS Fargate. The project uses Terraform to manage the IaC and app is hosted on Node. We have solved this with the below steps
1. Created the networks like vpc, subnet, sg, igw.
2. Setup the IAM Policy and role for ECS
3. Created an ECS Cluster
4. Saved the Secret word in AWS Secret Manager
5. Uploaded the certs to secret manager during deployment scripts
6. Deployed a LB, Listener and Target Group
7. Hosted a Fargate ECS Service to launch the container.

Why ECS over EC2 or EKS?
- ECS is lightweight for the Node app running.
- Simplified infrastructure management.
- Seamless upgrades handled by ECS.
- No need to maintain instances (AMIs, security packages, regular updates).
- Managed auto-scaling by AWS. 


Refer to the architecture here:

![Architecture Diagram](solution/architecture.drawio.png)

# How to setup?

Install
1. NPM 
2. Docker
3. Terraform
4. Create AWS ECR Repo.

## Local Setup

1. Clone this repository to your local machine
2. Run the below
```
docker build -t quest:latest .
docker run -p 3000:3000 quest:latest
```

Output - 
"You are not in any cloud."(Something like this)

## Deploying over cloud.
1. Setting up AWS Creds and regions
Example of using creds.
```
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export AWS_SESSION_TOKEN=EXAMPLE
export AWS_DEFAULT_REGION=us-west-2
``` 

Validate - 
```
aws sts get-caller-identity
```

2. Building the image and uploading to ECR

```
Update the Makefile with your ECR Repo
make setup_app_image
```

Note the image name pushed to ECR.

3. Deploying the infra
```
export SECRET_WORD=TwelveFactor
export APP_IMAGE="public.ecr.aws/XYZ/shaswatpoc:2.0.0"
make tf_apply

```
Expected Output - [TF Apply Logs](solution/terraform_apply.logs)


##Cleaning up the resources
1. Run Terraform Destory
```
export SECRET_WORD=TwelveFactor
export APP_IMAGE="public.ecr.aws/XYZ/shaswatpoc:2.0.0"
make tf_destroy
```

Expected Output - [TF Destroy Logs](solution/terraform_destroy.logs)

2. Delete the ECR image.

# Submission (What do I have to submit?)\

1. Your work assets, as one or both of the following: https://github.com/shaswat96/quest

2. Proof of completion, as one or both of the following:
- Terrform logs - [TF Apply Logs](solution/terraform_apply.logs) and [TF Destroy Logs](solution/terraform_destroy.logs)

- Index Page - ![Index Page](solution/index_page.jpeg)

- Certificate Page - ![Certificate Page](solution/certificate.png)

- Validation Endpoints - ![Validation Endpoints](solution/validation_endpoints.jpeg)

- AWS Resources
![Load Balancer](solution/loadbalancer.png)
![ECS](solution/ECSCluster.png)

3. An answer to the prompt: "Given more time, I would improve..."
- I would have prefer to develop the rearc-provisioning-service which I have highlighted in the architecture diagram. This will basically provision the infra from API. I would designed the below API. I would have created in FastAPI in python.
> POST - v1/{account_id}

> PATCH - v1/{account_id}

> DELETE - v1/{account_id}


- mTLS implementation. 

- Added health checks and validations

- Evaluated more precisely to use EC2 with load balancer, EKS and Autoscaling or ECS. 

- Implmented on GCP as well since I know the achitecture.

- Adding the CI/CD pipeline for building image for Node app, testing E2E with more test cases. 
