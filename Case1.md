# Case 1 Solution

Following solution is a fully automated application deployment solution which is developed to deploy the rates application on to AWS Elastic Container service using terraform. To ensure the efficiency and usability of the solution end to end deployment process is fully automated to support 3 kind of deployment approaches.

## High Level Architecture Diagram

![Case 1 Architecture Diagram](https://user-images.githubusercontent.com/36834246/218263693-595599bd-fac2-4666-9008-ab18928a7ebc.png)

### Technologies and Tools Used for the Solution

**Cloud Provider** - AWS Cloud used as the main cloud provider to host the application considering variety of services which can be utilized to automate the application deployment and infrastructure by ensuring the security, availability, reliability, and scalability of the solution.

**Infrastructure as Code** – Terraform used as the IAC tool for implement the solution considering support for various of providers, readability of terraform syntax and support for code reusability using terraform modules. Solution is implemented in a manner to use terraform modules to ensure reusability of the code to deploy to different environments. Additionally a CloudFormation template used to deploy terraform state management resources.

**Database:** As the database for the solution RDS postgres DB used considering the availability of RDS service and manageability comparing to building a database on scratch on a server.
 
**Containerization** - Amazon ECS Fargate used to deploy the dockerized application in AWS considering the scalability, reliability, monitoring support, support for integration with services such as secret manager, ELB, ECR and IAM for access management. Also, ease of setup and management comparing to deploying a dockerized application in a self-hosted server.

**Container Registry** - Amazon ECR used as the container registry considering the ease of integration with AWS services such as ECS, EKS using IAM policies and roles.

**Secret Management** – AWS Secret manager used for management of secrets in application deployment considering ease of integration and access management to secrets using AWS services.

**Monitoring** – AWS CloudWatch used as the main monitoring solution for the deployment considering native support for no of AWS services to log integration, metrics capturing and automation and event execution support using CloudWatch alarm actions.

**CI/CD** – Github actions workflow support used to automate deployment process using CI/CD pipelines considering its support for various kind of providers and easy native integration with GitHub repositories. 

## How to Manage Multiple Environment Configurations

Terraform configurations and the modules are designed in a way to support for deployments in different environment with less of configurations changes. Simply if you wish to add a new environment. Please follow below instructions.

**Define a new terraform backend for environment terraform state configuration**

* Create a directory with name of the environment in `infra/backends` directory.

* Inside the newly created environment directory add a new file as `<env>.tfvars`

  ex : creating a backend for QA

       infra/backends/qa/qa.tfvars

* To identify configurations required for add a new terraform backend configuration please refer `infra/backend/template.tfvars` Simply this file contains the configurations required to manage terraform state.

**Special Note:** Automated deployment process is developed in a way to deploy a S3 bucket and a DynamoDB using a Cloudformation template during the application deployment these resource creation can be skipped by passing a option parameter during the deployment if you wish to create state management resources seperately. Otherwise you need to update backend configuration to use resources which will be created during the deployment for that please update both DynamoDB and S3 bucket in backend configuration according to below naming convention as both resources will be named same.

        terraform-state-[AWS_ACCOUNT_ID]-[AWS_REGION]
     
  ex : if the AWS Account ID : 112233445566 and Deployment AWS Regions : eu-west-1 resources name should be as follows
     
        terraform-state-112233445566-eu-west-1

**Define environment specific input variables**

* Create a directory with name of the environment in infra/variables directory.

* Inside the newly created environment directory add a new file as <env>.tfvars
 
  ex : creating input variables file for QA

      infra/variables/qa/qa.tfvars
 
* Update the file with input variable values as required

* To identify configurations required for the deployment variable template file stored in `infra/variables/template.tfvars` file can be referred. This template file contains all the required variables to be passed as input for the deployment. All other variables will be dynamically assigned based on the deployment environment.

## How to Deploy the Solution.

This solution is designed and developed in a way to support 3 deployment approaches.

### 1. Manual Deployment using local machine or using an AWS EC2 Instance.

**Prerequisites:**

To deploy the application manually following prerequies should be met.

* Following tools need to be installed within the operating system.

   * Docker
   * Terraform 1.3.7
   * aws cli

* AWS Credentials should be exported to environment variables or EC2 instance should using for the deployment should have a IAM role attached with proper permissions.
 
 ```
export AWS_ACCESS_KEY_ID=<access_key_id>
export AWS_SECRET_ACCESS_KEY=<secret_access_key>
export AWS_DEFAULT_REGION=<aws_region>
```

**Deployment Instructions:**

  * Clone the repository to local computer or the EC2 which is met with mentioned prerequisites.

  * Simply you can deploy the application by to any of the preferred environment in the configurations by executing `deploy_application.sh` script in the root of the GitHub project. During the execution users need to provide set of required parameters as well a optional parameter depends on the requirement.
 
***Parameters Expecting for Deployment Script***
 
 `ENVIRONMENT` - Deployment Environment (required parameter)
 
 `DEPLOYMENT_VERSION` - Version of the Deployment about to perform (required parameter)\
 
 `CREATE_STATE_STACK` - (optional parameter)if not set will use default value as 'False', if parameter value set to 'True' terraform state resources stack will be created during the deployment, before the deployment backend configurations should be updated accordingly.
 
***Example Deployment Commands***
 
 * Deploy deployment version 1.0.0 to dev environment with creating the terraform state resources stack.
 
 ` ./deploy_aplication.sh ENVIRONMENT='dev' DEPLOYMENT_VERSION='1.0.0' CREATE_STATE_STACK='True' `
 
 * Deploy deployment version 1.0.0 to qa environment without creating the terraform state resources stack.

 ` ./deploy_aplication.sh ENVIRONMENT='qa' DEPLOYMENT_VERSION='1.0.0'`
 
**Destroy Infrastructure and Deployments**
 
To destroy the deployment you can execute `destroy_infra.sh` script as same as deployment script. 

***Parameters Expecting for Destroy Script***
 
`ENVIRONMENT` - Deployment Environment (required parameter)
 
`DEPLOYMENT_VERSION` - Version of the Deployment about to perform (required parameter)
 
`DESTROY_STATE_STACK` - (optional parameter)if not set will use default value as 'False', if parameter value set to 'True' terraform state resources stack will be destroyed during the script execution.
 
***Example Destroy Commands***
 
 * Destroy dev infra deployment with last deployment version 5.0.0 in dev environment with destroying the terraform state resources stack.
 
 ` ./destroy_infra.sh ENVIRONMENT='dev' DEPLOYMENT_VERSION='1.0.0' DESTROY_STATE_STACK='True' `
 
 * Destroy qa infra deployment with last deployment version 5.0.0 to qa environment without destroying the terraform state resources stack.

 ` ./destroy_infra.sh ENVIRONMENT='qa' DEPLOYMENT_VERSION='1.0.0'`
 
### 2. Auto Deploy Application to AWS using GitHub Actions Workflow based on changes committed Master branch.
 
**Prerequisites:**

* To deploy the application using auto commit GitHub actions workflow aws creadentials should be added to GitHub actions secrets.
 
* Terraform backend configurations and environment configuration variables should be update properly as mentioned in How to Manage Multiple Environment configuration section.

Once the above prerequisites are met auto deployment workflow will be triggered when changes are commited to the master branch of the repository. The specific deployment image will be tagged with the GitHub SHA value of the last commit to the master branch.
 
<img width="1702" alt="auto deploy pipeline" src="https://user-images.githubusercontent.com/36834246/218275130-9d692c65-9de4-434b-95de-dc6f009d67da.png">


### 3. Ad-Hoc Deployment of Application to AWS using using Github Actions Workflow

Ad-hoc deployment workflow can be used to deploy the application to AWS from any of the branches by providing required variable values during the deployment users can select the environment, select whether to create terraform stack management resources or provide any specific deployment version for the deployment execution. If a version not provided commit sha of the last commit will be used for tag the deployment image. This workflow is a ideal solution for rollback deployments to previous versions if required.
 
 <img width="1000" alt="trigger adhoc workflow" src="https://user-images.githubusercontent.com/36834246/218273837-38f6246c-62a6-4cbb-9317-0c4dbd88186b.png">
 
 <img width="1000" alt="addhoc workflow" src="https://user-images.githubusercontent.com/36834246/218273855-c719c2be-3da1-4c18-86c6-f1186775c7d4.png">

## Possible Improvements
 
 Following are few improvements and best practices identified which i didn't had enough time to work on. These improvemnts can optimize solutions and the best practices of the implementation.

 * Application Autoscaling policies and integrated CloudWatch alarms actions can be implemented to scale the application base on the load when promoting to higher environments.

* Current implementation is designed on based to build a separate docker image for each environment and deploy using the newly built image for the environment. This can be improved to promote same docker image to multiple environments.

* Currently database restore process has been handled by an ec2 instance launched during the initial deployment. This database restoration process can be implemented using separate data ingestion pipeline process once the database resources are provisioned. This can help to deploy any additional data insert processes easily.

* Deployment approvals can be setup to promote application to different environments.

