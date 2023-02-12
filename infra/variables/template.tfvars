### This is a template file describing the usage of each variable required for the deployment

global_tags = map of objects tag key/value pairs which can be used to tag all the resources

tags = additional map of object tag key/value pairs can be used to tag resources.

### Commmon Variables

application = provide the name of the application to deploy in string format. provided value will be used in resource naming

### VPC Components related variables

region = AWS region of the deployment in string format.
vpc_cidr = CIDR block for create the VPC in string format.
priv_subnets_cidr = List of CIDR blocks to create private subnets in the VPC.
pub_subnets_cidr = List of CIDR blocks to create public subnets in the VPC.
db_subnets_cidr = List of CIDR blocks to create db subnets in the VPC.
vpc_azs = List of AWS availability zones to use for provision network resources.
num_az  = number of availability zones using for the deployment.
pub_sub_map_public_ip_on_launch = Set value "true" to enable assigning public ips for resources in public subnets.

### If creating multiple VPCs on same account set this to false in other vpc creation configs 
vpc_flow_iam_set =  set value to "true" if want to create vpc flow logs related IAM roles.


### DB component related variables
db_username = username for the RDS db in string format.
db_name      = name of the db to be created at the RDS provisioning, this DB will used to restore the data from provided dump.
db_instance_class = type of the db instance used for the deployment
db_allocated_storage = size of the allocated storage for db.
db_restore_role_name = name of the IAM role to be used with the ec2 instance performing DB restore

### ECS Deployment related variables
ecs_task_cpu  = Cpu allocated for each ecs task
ecs_task_memory  = memory allocated for each ecs task
desired_task_count = desired count of ecs tasks
container_name     = name of the application container
container_port     = application port in the container
task_execution_role_name = name of the ecs task execution role
application_image_name   = name of the application image
ecs_service_name         = name of the ecs service
