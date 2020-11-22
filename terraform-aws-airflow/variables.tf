variable "resource_prefix" {
  description = "Prefix to use for all resource names"
  type = string
  default = ""
}

variable "resource_suffix" {
  description = "Suffix to use for all resource names"
  default = ""
}

variable "region" {
  description = "AWS region used for Airflow EC2 and DB"
  type = string
}

#### VPC ####

variable "vpc_id" {
  description = "VPC ID of a pre-existing VPC"
  type = string
  default = null
}

variable "vpc_s3_endpoint_pl_id" {
  description = "VPC S3 endpoint prefix ID. Must be the same VPC specified under `vpc_id`"
  type = string
  default = null
}


variable "private_subnet_ids" {
  description = "List of VPC subnets IDs used to host Airflow DB"
  type = list(string)
  default = null
}

variable "private_subnets_cidr_blocks" {
  description = "List of VPC IPv4 CIDR blocks used to host Airflow DB"
  type = list(string)
  default = null
}

#### AIRFLOW-EC2 ####

variable "create_airflow_ec2" {
  description = "Determines if module should launch an EC2 instance to host Airflow on"
  type = bool
  default = false
}

variable "create_airflow_ec2_sg" {
  description = "Determines if module should create a security group for the Airflow instance"
  type = bool
  default = false
}

variable "create_ec2_eip" {
  default = false
}

variable "airflow_db_storage_type" {
  description = "Airflow DB storage type"
  type = string
  default = "gp2"
}

variable "airflow_ec2_ami" {
  description = "Airflow EC2 instance AMI (e.g. \"ami-0841edc20334f9287\")"
  type = string
  default = null
}

variable "airflow_ec2_type" {
  description = "Airflow EC2 instance type (e.g. \"t2.micro\")"
  type = string
  default = null
}

variable "airflow_ec2_ssh_cidr_blocks" {
  description = "IPv4 CIDR list of user IPs who can SSH into the airflow instance. `airflow_instance_key_name` must also be defined."
  type = list(string)
  default = null
}

variable "airflow_ec2_subnet_id" {
  description = "The subnet that will host the airflow instance"
  type = string
  default = null
}

variable "airflow_ec2_key_name" {
  description = "The key pair name used to SSH into the Airflow instance"
  type = string
  default = null
}

variable "airflow_ec2_tags" {
  description = "Dictionary of tags used for the Airflow instance"
  type = map(string)
  default = {}
}

variable "airflow_ec2_user_data" {
  description = "Script to run at launch for the Airflow instance"
  type = string
  default = null
}

#### AIRFLOW-EC2-SSM ####

variable "ssm_logs_bucket_name" {
  description = "S3 bucket used to store ssm logs"
  default = null
}

variable "install_code_deploy_agent" {
  description = "Determines if an CodeDeploy agent should be installed on the Airflow EC2"
  type = bool
  default = false
}

variable "code_deploy_agent_output_key" {
  description = "S3 output key for CodeDeploy agent installation logs"
  type = string
  default = "ssm/state_manager_logs/codedeploy_agent/"
}

variable "airflow_ec2_has_ssm_access" {
  description = "Determines if an SSM agent should be installed on the Airflow EC2. If yes, the EC2 instance can be accessed via SSM Session Manager."
  type = bool
  default = false
}

variable "ssm_agent_output_key" {
  description = "S3 output key for SSM agent installation logs"
  default = "ssm/state_manager_logs/ssm_agent/"
}

variable "ssm_install_dependencies_output_key" {
  default = "ssm/state_manager_logs/dependencies/"
}

variable "ecr_repo_url" {
  description = "ECR repo to authenticate docker with"
  default = null
}

variable "kms_key_alias" {
  description = <<-EOF
  KMS key alias used to encrypt/decrypt Airflow meta-db connection string store within SSM parameter store.
  Defaults to AWS managed ssm key. 
  EOF
  default = "alias/aws/ssm"
}

####AIRFLOW-DB####

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

variable "airflow_db_engine" {
  description = "The RDS type to be used for the Airflow DB"
  default = "postgres"
}

variable "airflow_db_engine_version" {
  description = "The RDS engine version to be used for the Airflow instance"
  default = 11.8
}

variable "airflow_db_allocated_storage" {
  description = "The allocated storage for the Airflow RDS in gibibytes"
  default = 20
}

variable "airflow_db_name" {
  description = "The name of the database within the Airflow RDS instance"
  default = null
}

variable "airflow_db_instance_class" {
  description = "The type of RDS to launch (e.g. \"db.t2.micro\")"
  type = string
  default = null
}

variable "airflow_db_port" {
  description = "Airflow DB port (defaults to Postgres port)."
  type = number
  default = 5432
}

variable "airflow_db_username_ssm_key" {
  description = "Existing SSM Parameter Store key used to retrieve the Airflow RDS instance username value"
  default = null
}

variable "airflow_db_username" {
  description = "Airflow RDS username"
  default = null
}

variable "airflow_db_password" {
  description = "Airflow RDS password"
  default = null
}

variable "airflow_db_password_ssm_key" {
  description = "Existing SSM Parameter Store key used to retrieve the Airflow RDS instance password value"
  default = null
}

variable "load_airflow_db_uri_to_ssm" {
  description = "Determines if Airflow RDS URI should be uploaded to SSM Parameter store"
  default = false
}

variable "airflow_db_uri_ssm_key_alias" {
  description = "SSM Paramter Store key used for Airflow RDS URI value"
  default = null
}
variable "airflow_db_tags" {
  description = "Tags to attach to the Airflow RDS"
  default = {}
}

variable "airflow_db_ssm_tags" {
  description = "Tags to attach to the SSM Paramter Store key-value pair for the Airflow URI"
  default = {}
}


#### AIRFLOW-IAM ####

variable "create_ec2_role" {
  description = "Determiens if an IAM role should be created for the Airflow EC2"
  default = true
}

variable "create_ec2_profile" {
  description = "Determines if an EC2 profile should be created for the Airflow EC2"
  default = true
}

variable "airflow_ec2_role_statements" {
  description = "IAM policy statements to attach to the Airflow EC2 role"
/* 
 change to below when issue: https://github.com/hashicorp/terraform/issues/19898 is fixed to allow optional condition map
  type = list(object({
    effect = string
    resources = list(string)
    actions = list(string)
    condition = list(map(object({
      test = string
      variable = string
      values = list(string)
    })))
  }))
*/
  type = list(any)
  default = null
}

variable "airflow_ec2_allowed_actions" {
  description = "List of AWS actions the Airflow Ec2 can perform (e.g. [\"s3:GetObject\"])"
  default = null
}

variable "airflow_ec2_allowed_resources" {
  description = "List of AWS resources associated with the allowed Airflow Ec2 actions"
  default = null
}