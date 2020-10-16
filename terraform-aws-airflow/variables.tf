variable "env" {
  description = "Environment name to associate aws resources with"
}

variable "resource_prefix" {
  description = "string prefix to add to all aws resources"
  default = ""
}

variable "region" {
  description = "The default region used if specific region variables are not defined"
}

variable "private_bucket" {
  description = "S3 bucket used to store ssm logs"
}

####VPC####

variable "vpc_id" {
  description = "VPC ID of a pre-existing VPC"
  default = null
}

variable "vpc_s3_endpoint_pl_id" {
  description = "VPC S3 endpoint prefix ID. Must be the same VPC specified under `vpc_id`"
  default = null
}

variable "private_subnets_cidr_blocks" {
  description = "Private subnets CIDR list. Must be specified if Airflow instances will be created"
  default = []
}

variable "private_subnets_ids" {
  description = "Public subnets CIDR list. Used to host public resources under the specified VPC ID"
  default = []
}

####AIRFLOW INSTANCE####

variable "create_airflow_instance" {
  description = "Determines if module should launch an EC2 instance to host Airflow on"
  type = bool
  default = false
}

variable "create_airflow_instance_sg" {
  description = "Determines if module should create a security group for the Airflow instance"
  type = bool
  default = false
}

variable "airflow_instance_ssm_access" {
  description = "Determines if Airflow EC2 instance can be accessed via SSM Session Manager"
  type = bool
  default = false
}

variable "airflow_instance_ami" {
  description = "Airflow EC2 instance AMI (e.g. \"ami-0841edc20334f9287\")"
  type = string
  default = null
}

variable "airflow_instance_type" {
  description = "Airflow EC2 instance type (e.g. \"t2.micro\")"
  default = null
}

variable "airflow_instance_ssh_cidr_blocks" {
  description = "IPv4 CIDR list of user IPs who can SSH into the airflow instance. `airflow_instance_key_name` must also be defined."
  default = []
}

variable "airflow_instance_subnet_id" {
  description = "The subnet that will host the airflow instance"
  default = null
}

variable "airflow_instance_key_name" {
  description = "The key pair name used to SSH into the Airflow instance"
  default = null
}

variable "airflow_db_instance_class" {
  description = "The type of to launch (e.g. \"db.t2.micro\")"
  default = null
}

variable "airflow_instance_tags" {
  description = "Dictionary of tags used for Airflow instance"
  default = {}
}

variable "airflow_instance_user_data" {
  description = "Script to run at launch for the Airflow instance"
  default = null
}

variable "airflow_instance_region" {
  default = null
  description = "The region used to define the SSM S3 ARN for the Airflow instance policy"
}

###AIRFLOW INSTANCE SSM####

variable "ssm_codedeploy_agent_output_key" {
  default = "ssm/state_manager_logs/codedeploy_agent/"
}

variable "ssm_agent_output_key" {
  default = "ssm/state_manager_logs/ssm_agent/"
}

variable "ssm_install_dependencies_output_key" {
  default = "ssm/state_manager_logs/install_dependencies/"
}

variable "ecr_repo_url" {
  description = "ECR repo to authenticate docker with"
  default = null
}

####AIRFLOW DB PARAMETERS####

variable "create_airflow_db" {
  description = "Determines if module should launch an RDS instance to host Airflow meta-db on"
  type = bool
  default = false
}

variable "create_airflow_db_sg" {
  description = "Determines if module should create a security group for the Airflow RDS instance"
  type = bool
  default = false
}

variable "airflow_db_allocated_storage" {
  description = "The allocated storage for the db in gibibytes"
  default = 5
}

variable "airflow_db_name" {
  description = "The name of the Airflow meta-db"
  default = null
}

variable "airflow_db_username" {
  description = "Airflow meta-db username (USE ENVIRONMENT VARS or retrieve from AWS SSM Parameter Store!)"
  default = null
}

variable "airflow_db_password" {
  description = "Airflow meta-db password (USE ENVIRONMENT VARS or retrieve from AWS SSM Parameter Store!)"
  default = null
}

