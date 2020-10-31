variable "deployment_key_pair_tags" {
    default = {}
}

#### DEPLOYMENT READ ACCESS ROLE ####
variable "create_deployment_read_access_role" {
    default = false
}

variable "deployment_access_tags" {
    default = {}
}

variable "deployment_read_access_role_policy_arns" {
    default = []
}

variable "deployment_read_access_role_name" {
    default = null
}

variable "deployment_read_access_role_path" {
    default = "/"
}

variable "deployment_read_access_role_permissions_boundary_arn" {
    default = ""
}

variable "deployment_read_access_role_requires_mfa" {
    default = true
}

variable "deployment_read_access_role_mfa_age" {
    default = 86400
}

variable "deployment_read_access_role_tags" {
    default = {}
}

variable "deployment_read_access_role_actions" {
    default = []
}

variable "deployment_read_access_role_description" {
    default = null
}

variable "deployment_read_access_role_force_detach_policies" {
    default = false
}

variable "deployment_read_access_role_permissions_boundary" {
    default = ""
}

variable "deployment_read_access_role_max_session_duration" {
    default = 3600
}


#### DAG READ ACCESS ROLE ####
variable "create_dag_read_access_roles" {
    default = false
}

variable "dag_access_tags" {
    default = {}
}

variable "dag_read_access_roles_policy_arns" {
    default = []
}

variable "dag_read_access_roles_name" {
    default = null
}

variable "dag_read_access_roles_path" {
    default = "/"
}

variable "dag_read_access_roles_permissions_boundary_arn" {
    default = ""
}

variable "dag_read_access_roles_requires_mfa" {
    default = true
}

variable "dag_read_access_roles_mfa_age" {
    default = 86400
}

variable "dag_tag_key" {
    default = ""
}
variable "dag_read_access_roles_tags" {
    default = {}
}

variable "dag_read_access_roles_actions" {
    default = []
}

variable "dag_read_access_roles_description" {
    default = null
}

variable "dag_read_access_roles_force_detach_policies" {
    default = false
}

variable "dag_read_access_roles_permissions_boundary" {
    default = ""
}

variable "dag_read_access_roles_max_session_duration" {
    default = 3600
}


