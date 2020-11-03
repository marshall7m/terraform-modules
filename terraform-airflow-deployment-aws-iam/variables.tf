variable "deployment_key_pair_tags" {
    default = {}
}

variable "deployment_access_tags" {
    default = {}
}

variable "dag_access_tags" {
    default = {}
}

variable "dag_tag_key" {
    default = ""
}

#### DEPLOYMENT READ ACCESS ROLE ####
variable "create_deployment_read_access_role" {
    default = false
}

variable "attach_default_deployment_read_access_policy" {
    default = false
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


#### DEPLOYMENT FULL ACCESS ROLE ####
variable "create_deployment_full_access_role" {
    default = false
}

variable "attach_default_deployment_full_access_policy" {
    default = false
}

variable "deployment_full_access_role_policy_arns" {
    default = []
}

variable "deployment_full_access_role_name" {
    default = null
}

variable "deployment_full_access_role_path" {
    default = "/"
}

variable "deployment_full_access_role_permissions_boundary_arn" {
    default = ""
}

variable "deployment_full_access_role_requires_mfa" {
    default = true
}

variable "deployment_full_access_role_mfa_age" {
    default = 86400
}

variable "deployment_tag_key" {
    default = ""
}
variable "deployment_full_access_role_tags" {
    default = {}
}

variable "deployment_full_access_role_actions" {
    default = []
}


variable "deployment_full_access_role_description" {
    default = null
}

variable "deployment_full_access_role_force_detach_policies" {
    default = false
}

variable "deployment_full_access_role_permissions_boundary" {
    default = ""
}

variable "deployment_full_access_role_max_session_duration" {
    default = 3600
}

#### DAG READ ACCESS ROLE ####
variable "create_dag_read_access_roles" {
    default = false
}

variable "attach_default_dag_read_access_policy" {
    default = false
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



#### DAG FULL ACCESS ROLE ####
variable "create_dag_full_access_roles" {
    default = false
}

variable "attach_default_dag_full_access_policy" {
    default = false
}

variable "dag_full_access_roles_policy_arns" {
    default = []
}

variable "dag_full_access_roles_name" {
    default = null
}

variable "dag_full_access_roles_path" {
    default = "/"
}

variable "dag_full_access_roles_permissions_boundary_arn" {
    default = ""
}

variable "dag_full_access_roles_requires_mfa" {
    default = true
}

variable "dag_full_access_roles_mfa_age" {
    default = 86400
}

variable "dag_full_access_roles_tags" {
    default = {}
}

variable "dag_full_access_roles_actions" {
    default = []
}


variable "dag_full_access_roles_description" {
    default = null
}

variable "dag_full_access_roles_force_detach_policies" {
    default = false
}

variable "dag_full_access_roles_permissions_boundary" {
    default = ""
}

variable "dag_full_access_roles_max_session_duration" {
    default = 3600
}


variable "default_full_access_actions" {
    description = "Default read, write, and tag actions for all full access roles"
    default = [
        "glue:GetCrawler",
        "glue:BatchGetDevEndpoints",
        "glue:GetTableVersions",
        "glue:GetPartitions",
        "glue:GetMLTransform",
        "glue:UpdateCrawler",
        "glue:GetDevEndpoint",
        "glue:UpdateTrigger",
        "glue:GetTrigger",
        "glue:GetJobRun",
        "glue:GetJobs",
        "glue:DeleteCrawler",
        "glue:GetTriggers",
        "glue:GetWorkflowRun",
        "glue:GetMapping",
        "glue:GetPartition",
        "glue:DeleteConnection",
        "glue:UseMLTransforms",
        "glue:BatchDeleteConnection",
        "glue:StartCrawlerSchedule",
        "glue:UpdateMLTransform",
        "glue:CreateMLTransform",
        "glue:GetClassifiers",
        "glue:StartMLEvaluationTaskRun",
        "glue:BatchDeletePartition",
        "glue:DeleteTableVersion",
        "glue:CreateTrigger",
        "glue:CreateUserDefinedFunction",
        "glue:StopCrawler",
        "glue:StopTrigger",
        "glue:DeleteJob",
        "glue:GetCatalogImportStatus",
        "glue:DeleteDevEndpoint",
        "glue:DeleteMLTransform",
        "glue:CreateJob",
        "glue:GetTableVersion",
        "glue:GetConnection",
        "glue:ResetJobBookmark",
        "glue:CreatePartition",
        "glue:UpdatePartition",
        "glue:BatchGetPartition",
        "glue:GetTags",
        "glue:StartMLLabelingSetGenerationTaskRun",
        "glue:GetTable",
        "glue:GetDatabase",
        "glue:GetDataflowGraph",
        "glue:BatchGetCrawlers",
        "glue:CreateDatabase",
        "glue:BatchDeleteTableVersion",
        "glue:GetPlan",
        "glue:GetJobRuns",
        "glue:BatchCreatePartition",
        "glue:SearchTables",
        "glue:GetDataCatalogEncryptionSettings",
        "glue:CreateClassifier",
        "glue:GetWorkflowRunProperties",
        "glue:UpdateTable",
        "glue:DeleteTable",
        "glue:DeleteWorkflow",
        "glue:GetSecurityConfiguration",
        "glue:GetResourcePolicy",
        "glue:CreateScript",
        "glue:UpdateWorkflow",
        "glue:GetUserDefinedFunction",
        "glue:StartWorkflowRun",
        "glue:StopCrawlerSchedule",
        "glue:GetUserDefinedFunctions",
        "glue:PutResourcePolicy",
        "glue:GetClassifier",
        "glue:TagResource",
        "glue:UpdateDatabase",
        "glue:GetTables",
        "glue:CreateTable",
        "glue:DeleteResourcePolicy",
        "glue:BatchStopJobRun",
        "glue:DeleteUserDefinedFunction",
        "glue:CreateConnection",
        "glue:CreateCrawler",
        "glue:DeleteSecurityConfiguration",
        "glue:GetDevEndpoints",
        "glue:BatchGetWorkflows",
        "glue:BatchGetJobs",
        "glue:StartJobRun",
        "glue:BatchDeleteTable",
        "glue:UpdateClassifier",
        "glue:CreateWorkflow",
        "glue:DeletePartition",
        "glue:GetJob",
        "glue:GetWorkflow",
        "glue:GetConnections",
        "glue:GetCrawlers",
        "glue:CreateSecurityConfiguration",
        "glue:PutWorkflowRunProperties",
        "glue:DeleteDatabase",
        "glue:StartTrigger",
        "glue:ImportCatalogToGlue",
        "glue:PutDataCatalogEncryptionSettings",
        "glue:StartCrawler",
        "glue:UntagResource",
        "glue:UpdateJob",
        "glue:GetJobBookmark",
        "glue:StartImportLabelsTaskRun",
        "glue:DeleteClassifier",
        "glue:StartExportLabelsTaskRun",
        "glue:UpdateUserDefinedFunction",
        "glue:CancelMLTaskRun",
        "glue:GetSecurityConfigurations",
        "glue:GetDatabases",
        "glue:GetMLTaskRun",
        "glue:UpdateCrawlerSchedule",
        "glue:UpdateConnection",
        "glue:BatchGetTriggers",
        "glue:CreateDevEndpoint",
        "glue:UpdateDevEndpoint",
        "glue:GetWorkflowRuns",
        "glue:DeleteTrigger",
        "glue:GetCrawlerMetrics",
        "athena:TagResource",
        "athena:CreateDataCatalog",
        "athena:UpdateDataCatalog",
        "athena:UntagResource",
        "athena:GetTableMetadata",
        "athena:StartQueryExecution",
        "athena:GetQueryResultsStream",
        "athena:DeleteWorkGroup",
        "athena:GetQueryResults",
        "athena:GetDatabase",
        "athena:GetDataCatalog",
        "athena:DeleteNamedQuery",
        "athena:UpdateWorkGroup",
        "athena:GetNamedQuery",
        "athena:CreateWorkGroup",
        "athena:ListTagsForResource",
        "athena:GetWorkGroup",
        "athena:CreateNamedQuery",
        "athena:StopQueryExecution",
        "athena:DeleteDataCatalog",
        "athena:GetQueryExecution",
        "athena:BatchGetNamedQuery",
        "athena:BatchGetQueryExecution",
        "redshift:DescribeHsmConfigurations",
        "redshift:DeleteClusterSecurityGroup",
        "redshift:CreateTags",
        "redshift:DeleteClusterSubnetGroup",
        "redshift:CreateSavedQuery",
        "redshift:CreateClusterSecurityGroup",
        "redshift:ModifyClusterIamRoles",
        "redshift:ModifySnapshotSchedule",
        "redshift:DeleteSnapshotSchedule",
        "redshift:DescribeDefaultClusterParameters",
        "redshift:DeleteScheduledAction",
        "redshift:PauseCluster",
        "redshift:DescribeClusterSubnetGroups",
        "redshift:DescribeQuery",
        "redshift:RestoreTableFromClusterSnapshot",
        "redshift:DeleteClusterSnapshot",
        "redshift:BatchModifyClusterSnapshots",
        "redshift:DescribeClusterVersions",
        "redshift:DescribeClusterSnapshots",
        "redshift:DescribeStorage",
        "redshift:DeleteClusterParameterGroup",
        "redshift:DescribeClusterSecurityGroups",
        "redshift:DescribeEventSubscriptions",
        "redshift:DescribeOrderableClusterOptions",
        "redshift:CreateHsmClientCertificate",
        "redshift:DescribeScheduledActions",
        "redshift:AcceptReservedNodeExchange",
        "redshift:ResizeCluster",
        "redshift:RevokeSnapshotAccess",
        "redshift:ResumeCluster",
        "redshift:CreateScheduledAction",
        "redshift:CancelQuery",
        "redshift:RevokeClusterSecurityGroupIngress",
        "redshift:CreateEventSubscription",
        "redshift:ModifyClusterDbRevision",
        "redshift:EnableLogging",
        "redshift:DescribeSnapshotCopyGrants",
        "redshift:DeleteSnapshotCopyGrant",
        "redshift:DeleteHsmConfiguration",
        "redshift:CopyClusterSnapshot",
        "redshift:CancelQuerySession",
        "redshift:DescribeResize",
        "redshift:ModifyClusterParameterGroup",
        "redshift:GetClusterCredentials",
        "redshift:ModifyClusterSnapshot",
        "redshift:CreateHsmConfiguration",
        "redshift:JoinGroup",
        "redshift:ModifyCluster",
        "redshift:AuthorizeClusterSecurityGroupIngress",
        "redshift:GetReservedNodeExchangeOfferings",
        "redshift:DeleteCluster",
        "redshift:PurchaseReservedNodeOffering",
        "redshift:ModifySavedQuery",
        "redshift:CreateSnapshotSchedule",
        "redshift:ModifyClusterMaintenance",
        "redshift:ResetClusterParameterGroup",
        "redshift:ModifySnapshotCopyRetentionPeriod",
        "redshift:DescribeEventCategories",
        "redshift:ModifyClusterSnapshotSchedule",
        "redshift:DescribeReservedNodeOfferings",
        "redshift:CreateClusterSnapshot",
        "redshift:DescribeSnapshotSchedules",
        "redshift:DisableSnapshotCopy",
        "redshift:DescribeSavedQueries",
        "redshift:DescribeLoggingStatus",
        "redshift:DescribeTableRestoreStatus",
        "redshift:DescribeClusterParameters",
        "redshift:ModifyEventSubscription",
        "redshift:CreateClusterUser",
        "redshift:DeleteTags",
        "redshift:DeleteHsmClientCertificate",
        "redshift:RotateEncryptionKey",
        "redshift:ModifyClusterSubnetGroup",
        "redshift:ModifyScheduledAction",
        "redshift:CancelResize",
        "redshift:DisableLogging",
        "redshift:DescribeAccountAttributes",
        "redshift:DescribeHsmClientCertificates",
        "redshift:DescribeTags",
        "redshift:DescribeClusterParameterGroups",
        "redshift:FetchResults",
        "redshift:AuthorizeSnapshotAccess",
        "redshift:RebootCluster",
        "redshift:RestoreFromClusterSnapshot",
        "redshift:BatchDeleteClusterSnapshots",
        "redshift:DescribeReservedNodes",
        "redshift:CreateCluster",
        "redshift:CreateClusterParameterGroup",
        "redshift:EnableSnapshotCopy",
        "redshift:ExecuteQuery",
        "redshift:CreateClusterSubnetGroup",
        "redshift:DeleteEventSubscription",
        "redshift:DescribeTable",
        "redshift:DeleteSavedQueries",
        "redshift:CreateSnapshotCopyGrant",
        "rds:StartDBCluster",
        "rds:DeleteGlobalCluster",
        "rds:RemoveRoleFromDBCluster",
        "rds:RestoreDBInstanceFromS3",
        "rds:CrossRegionCommunication",
        "rds:ResetDBParameterGroup",
        "rds:CreateGlobalCluster",
        "rds:DeregisterDBProxyTargets",
        "rds:CreateOptionGroup",
        "rds:CreateDBSubnetGroup",
        "rds:PurchaseReservedDBInstancesOffering",
        "rds:ModifyDBParameterGroup",
        "rds:AddSourceIdentifierToSubscription",
        "rds:DownloadDBLogFilePortion",
        "rds:CopyDBParameterGroup",
        "rds:AddRoleToDBCluster",
        "rds:CreateDBProxy",
        "rds:ModifyDBInstance",
        "rds:ModifyDBClusterParameterGroup",
        "rds:RegisterDBProxyTargets",
        "rds:ModifyDBClusterSnapshotAttribute",
        "rds:DeleteDBInstance",
        "rds:CopyDBClusterParameterGroup",
        "rds:CreateDBClusterEndpoint",
        "rds:StopDBCluster",
        "rds:CreateDBParameterGroup",
        "rds:CancelExportTask",
        "rds:DeleteDBSnapshot",
        "rds:DeleteDBProxy",
        "rds:DeleteDBInstanceAutomatedBackup",
        "rds:RemoveFromGlobalCluster",
        "rds:PromoteReadReplica",
        "rds:StartDBInstance",
        "rds:StopActivityStream",
        "rds:RestoreDBClusterFromS3",
        "rds:DeleteDBSubnetGroup",
        "rds:CreateDBSnapshot",
        "rds:RestoreDBInstanceFromDBSnapshot",
        "rds:DeleteDBSecurityGroup",
        "rds:ModifyDBClusterEndpoint",
        "rds:ModifyDBCluster",
        "rds:CreateDBClusterSnapshot",
        "rds:DeleteDBParameterGroup",
        "rds:CreateDBClusterParameterGroup",
        "rds:ModifyDBSnapshotAttribute",
        "rds:RemoveTagsFromResource",
        "rds:PromoteReadReplicaDBCluster",
        "rds:CreateEventSubscription",
        "rds:ModifyOptionGroup",
        "rds:RestoreDBClusterFromSnapshot",
        "rds:StartExportTask",
        "rds:StartActivityStream",
        "rds:DeleteOptionGroup",
        "rds:FailoverDBCluster",
        "rds:DeleteEventSubscription",
        "rds:RemoveSourceIdentifierFromSubscription",
        "rds:AddRoleToDBInstance",
        "rds:ModifyDBProxy",
        "rds:CreateDBInstance",
        "rds:DeleteDBClusterEndpoint",
        "rds:RevokeDBSecurityGroupIngress",
        "rds:ModifyCurrentDBClusterCapacity",
        "rds:DeleteDBCluster",
        "rds:ResetDBClusterParameterGroup",
        "rds:RestoreDBClusterToPointInTime",
        "rds:AddTagsToResource",
        "rds:CopyDBSnapshot",
        "rds:CopyDBClusterSnapshot",
        "rds:ModifyEventSubscription",
        "rds:StopDBInstance",
        "rds:CopyOptionGroup",
        "rds:ModifyDBProxyTargetGroup",
        "rds:ModifyDBSnapshot",
        "rds:DeleteDBClusterSnapshot",
        "rds:ListTagsForResource",
        "rds:CreateDBCluster",
        "rds:CreateDBSecurityGroup",
        "rds:RebootDBInstance",
        "rds:ModifyGlobalCluster",
        "rds:DeleteDBClusterParameterGroup",
        "rds:ApplyPendingMaintenanceAction",
        "rds:BacktrackDBCluster",
        "rds:CreateDBInstanceReadReplica",
        "rds:RemoveRoleFromDBInstance",
        "rds:ModifyDBSubnetGroup",
        "rds:RestoreDBInstanceToPointInTime"
    ]
}