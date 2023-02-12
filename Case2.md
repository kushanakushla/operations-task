# Case 2 Solution

## Data Ingestion Pipeline Solution

While designing the solution for data ingestion pipeline I considered below specific requirements. And made few assumptions to design the process.

**Assumptions**

* As mentioned in the scenario data will be provided in same format. Therefore, I assumed new batch of data will be uploaded to a S3 bucket in csv file format so each new csv data file uploaded to the bucket will have the latest data to be inserted to the RDS database.

**Considerations**

* As mentioned, data updates and requests can be highly sporadic, therefore solution should be implemented in an event driven approach. Using Serverless resources to save cost and compute resources when there is no active data ingestion happening.

* Each batch of data need to be processed together and data inserting process should insert all data in the batch or nothing in the batch should be inserted to the RDS database. Considering this requirement, I decided to use import data from S3 to RDS PostgresDB using COPY command, as when performing copy operation from s3 to RDS PostgresDB if there any error occurred during the data copy operation all the changes will be rolled back to avoid the inconsistency and to protect the data integrity in the database.

### Design of the Solution

![data ingestion (1)](https://user-images.githubusercontent.com/36834246/218320338-2e07aa8a-cea7-4eb1-8aba-365b7afd7040.png)

As I mentioned in the assumptions in my solution, I assumed data batches will be uploaded to a s3 bucket in csv files format. Once csv files uploaded to s3 a s3 event notification will trigger an aws lambda function to invoke an aws batch job in a defined compute environment. This batch job will be triggered from a batch task definition which includes all configurations and commands ready to execute copy from operation aws s3 to RDS PostgresDB   Once the AWS batch job is triggered it will be able to identify the specific newly added file to the S3 and perform data ingestion operation to copy data from AWS S3 to RDS PostgresDB authentication and access between database and the s3 has been managed using IAM roles and the policies. Additionally, since the copy operation is been performed for data ingestion if any error occurred during the ingestion database will be rolled back to its original state. Retry attempts on failed batch jobs can be set to process failed ingestion data again.  AWS Cloudwatch can be intergrated with S3 bucket, Lambda function, Batch Jobs and RDS Postgres database to capture log events as well as monitor performances and trigger alarms and actions based on metric thresholds.

Following is few of possible bottlenecks which may occurred as the load grows.

* RDS database performance could be decreased as the amount of data grows, the RDS database may become a bottleneck. We might need to scale the RDS instance, add read replicas, or implement database partitioning to improve performance.

* S3 bucket performance could decrease as the amount of data stored in the S3 bucket grows, the performance of the S3 bucket may become a bottleneck. Implementing S3 lifecycle policies to move older data file between different tiers.

* AWS Batch job processing time can be increased when the load grows To address this bottleneck, the AWS Batch job can be optimized by adjusting the compute resources, such as the number of vCPUs and memory.

Answers to Additional Questions

**1.	The batch updates have started to become very large, but the requirements for their processing time are strict.**


* When the batch updates become very large but when the requirement of processing time should be strict there could be following limitations occurred with the designed solution.
Once the batch updates become very large time taken to data upload to s3 and download from s3 can be increased which could affect the time constraints for data ingestion. This can be mitigated by improving the network connectivity between RDS and S3 bucket by creating a VPC endpoint for S3 and enable direct connection to S3 from RDS without using public internet. Or using Amazon S3 Transfer acceleration which can help to optimize the data download speed.

* AWS Batch jobs may require a lot of compute resources, especially when processing large batches of data.Therefore need to carefully analyze resource requirements and enhance the batch job resource assignments based on the size of data batch. This can be handled by adding new  compute environment to process large batch data and adding new batch queues from lambda function code can be updated to change the compute environment based on the size of data batch.

* Also data ingestion time can be increased due to performance in database, we can optimize database performance to strict the ingestion time using optimizing the database by tuning the configuration parameters, such as increasing the number of connections, memory allocation, and indexes, can also consider using a cache mechanism to reduce the number of database calls or using optimized type of instance class.

**2. Code updates need to be pushed out frequently. This needs to be done without the risk of stopping a data update already being processed, nor a data response being lost.**

To push code updates fequently from the application deployment we can implement blue/green deployment approach. To perfrom frequent application deployments without affecting data ingestion or any data lost for application requests database can be optimized and scaled to a multi az postgres RDS database deployment with adding more read replicas with this optimisation application will be able to perform read queries frequently on the read replicas without affecting the postgres writer instance performance when data ingestion is happening. additionally, caching mechanism could be implemented to support application read capabilities.

**3. For development and staging purposes, you need to start up a number of scaled-down versions of the system.**

To development and staging environments solution can be deployed using leveraging less amount of compute capacities for services like AWS Batch and Lambda. 


