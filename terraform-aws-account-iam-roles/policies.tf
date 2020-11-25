#### ADMIN-IAM-POLICIES ####

data "aws_iam_policy_document" "admin_permissions" {
    count = var.admin_allowed_resources != null && var.admin_allowed_actions != null || var.admin_role_statements != null ? 1 : 0
    dynamic "statement" {
        for_each = var.admin_allowed_resources != [] && var.admin_allowed_actions != [] ? {} : null
        content {
            effect = "Allow"
            resources = var.admin_allowed_resources
            actions = var.admin_allowed_actions
        }
    }
    dynamic "statement" {
        for_each = var.admin_role_statements != [] ? {for statement in var.admin_role_statements: statement.effect => statement} : {}
        content {
            effect = statement.value.effect
            resources = statement.value.resources
            actions = statement.value.actions
            dynamic "condition" {
                for_each = can(statement.value.condition) ? {for condition in statement.value.condition: condition.test => condition} : {}
                content {
                    test = statement.value.condition.test
                    variable = statement.value.condition.variable
                    values = statement.value.condition.values
                }
            }
        }
    }
}

resource "aws_iam_policy" "admin_permissions" {
    count = var.admin_allowed_resources != null && var.admin_allowed_actions != null || var.admin_role_statements != null ? 1 : 0
    name = var.admin_policy_name
    description = var.admin_policy_description
    path = var.admin_policy_path
    policy = data.aws_iam_policy_document.admin_permissions[0].json
}

resource "aws_iam_role_policy_attachment" "admin_permissions" {
  count = var.admin_allowed_resources != null && var.admin_allowed_actions != null || var.admin_role_statements != null ? 1 : 0

  role       = aws_iam_role.admin_role[0].name
  policy_arn = aws_iam_policy.admin_permissions[0].arn
}

resource "aws_iam_role_policy_attachment" "custom_admin_permissions" {
  count = length(var.admin_role_cross_account_arns) > 0 && length(var.custom_admin_role_policy_arns) > 0 ? length(var.custom_admin_role_policy_arns) : 0

  role       = aws_iam_role.admin_role[0].name
  policy_arn = element(var.custom_admin_role_policy_arns, count.index)
}

#### DEV-IAM-POLICIES ####

data "aws_iam_policy_document" "dev_permissions" {
    count = var.dev_allowed_resources != null && var.dev_allowed_actions != null || var.dev_role_statements != null ? 1 : 0
    dynamic "statement" {
        for_each = var.dev_allowed_resources != [] && var.dev_allowed_actions != [] ? {} : null
        content {
            effect = "Allow"
            resources = var.dev_allowed_resources
            actions = var.dev_allowed_actions
        }
    }
    dynamic "statement" {
        for_each = var.dev_role_statements != [] ? {for statement in var.dev_role_statements: statement.effect => statement} : {}
        content {
            effect = statement.value.effect
            resources = statement.value.resources
            actions = statement.value.actions
            dynamic "condition" {
                for_each = can(statement.value.condition) ? {for condition in statement.value.condition: condition.test => condition} : {}
                content {
                    test = statement.value.condition.test
                    variable = statement.value.condition.variable
                    values = statement.value.condition.values
                }
            }
            
        }
    }
}

resource "aws_iam_policy" "dev_permissions" {
    count = var.dev_allowed_resources != null && var.dev_allowed_actions != null || var.dev_role_statements != null ? 1 : 0
    name = var.dev_policy_name
    description = var.dev_policy_description
    path = var.dev_policy_path
    policy = data.aws_iam_policy_document.dev_permissions[0].json
}

resource "aws_iam_role_policy_attachment" "dev_permissions" {
  count = var.dev_allowed_resources != null && var.dev_allowed_actions != null || var.dev_role_statements != null ? 1 : 0

  role       = aws_iam_role.dev_role[0].name
  policy_arn = aws_iam_policy.dev_permissions[0].arn
}

resource "aws_iam_role_policy_attachment" "custom_dev_permissions" {
  count = length(var.dev_role_cross_account_arns) > 0 && length(var.custom_dev_role_policy_arns) > 0 ? length(var.custom_dev_role_policy_arns) : 0

  role       = aws_iam_role.dev_role[0].name
  policy_arn = element(var.custom_dev_role_policy_arns, count.index)
}

#### READ-IAM-POLICIES ####

data "aws_iam_policy_document" "read_permissions" {
    count = var.read_allowed_resources != null && var.read_allowed_actions != null || var.read_role_statements != null ? 1 : 0
    dynamic "statement" {
        for_each = var.read_allowed_resources != [] && var.read_allowed_actions != [] ? {} : null
        content {
            effect = "Allow"
            resources = var.read_allowed_resources
            actions = var.read_allowed_actions
        }
    }
    dynamic "statement" {
        for_each = var.read_role_statements != [] ? {for statement in var.read_role_statements: statement.effect => statement} : {}
        content {
            effect = statement.value.effect
            resources = statement.value.resources
            actions = statement.value.actions
            dynamic "condition" {
                for_each = can(statement.value.condition) ? {for condition in statement.value.condition: condition.test => condition} : {}
                content {
                    test = statement.value.condition.test
                    variable = statement.value.condition.variable
                    values = statement.value.condition.values
                }
            }
            
        }
    }
}

resource "aws_iam_policy" "read_permissions" {
    count = var.read_allowed_resources != null && var.read_allowed_actions != null || var.read_role_statements != null ? 1 : 0
    name = var.read_policy_name
    description = var.read_policy_description
    path = var.read_policy_path
    policy = data.aws_iam_policy_document.read_permissions[0].json
}

resource "aws_iam_role_policy_attachment" "read_permissions" {
  count = var.read_allowed_resources != null && var.read_allowed_actions != null || var.read_role_statements != null ? 1 : 0

  role       = aws_iam_role.read_role[0].name
  policy_arn = aws_iam_policy.read_permissions[0].arn
}

resource "aws_iam_role_policy_attachment" "custom_read_permissions" {
  count = length(var.read_role_cross_account_arns) > 0 && length(var.custom_read_role_policy_arns) > 0 ? length(var.custom_read_role_policy_arns) : 0

  role       = aws_iam_role.read_role[0].name
  policy_arn = element(var.custom_read_role_policy_arns, count.index)
}

#### TF-PLAN-IAM-POLICIES ####

data "aws_iam_policy_document" "tf_plan_permissions" {
    count = var.tf_plan_allowed_resources != null && var.tf_plan_allowed_actions != null || var.tf_plan_role_statements != null ? 1 : 0
    dynamic "statement" {
        for_each = var.tf_plan_allowed_resources != [] && var.tf_plan_allowed_actions != [] ? {} : null
        content {
            effect = "Allow"
            resources = var.tf_plan_allowed_resources
            actions = var.tf_plan_allowed_actions
        }
    }
    dynamic "statement" {
        for_each = var.tf_plan_role_statements != [] ? {for statement in var.tf_plan_role_statements: statement.effect => statement} : {}
        content {
            effect = statement.value.effect
            resources = statement.value.resources
            actions = statement.value.actions
            dynamic "condition" {
                for_each = can(statement.value.condition) ? {for condition in statement.value.condition: condition.test => condition} : {}
                content {
                    test = statement.value.condition.test
                    variable = statement.value.condition.variable
                    values = statement.value.condition.values
                }
            }
            
        }
    }
}

resource "aws_iam_policy" "tf_plan_permissions" {
    count = var.tf_plan_allowed_resources != null && var.tf_plan_allowed_actions != null || var.tf_plan_role_statements != null ? 1 : 0
    name = var.tf_plan_policy_name
    description = var.tf_plan_policy_description
    path = var.tf_plan_policy_path
    policy = data.aws_iam_policy_document.tf_plan_permissions[0].json
}

resource "aws_iam_role_policy_attachment" "tf_plan_permissions" {
  count = var.tf_plan_allowed_resources != null && var.tf_plan_allowed_actions != null || var.tf_plan_role_statements != null ? 1 : 0

  role       = aws_iam_role.tf_plan_role[0].name
  policy_arn = aws_iam_policy.tf_plan_permissions[0].arn
}

resource "aws_iam_role_policy_attachment" "custom_tf_plan_permissions" {
  count = length(var.tf_plan_role_cross_account_arns) > 0 && length(var.custom_tf_plan_role_policy_arns) > 0 ? length(var.custom_tf_plan_role_policy_arns) : 0

  role       = aws_iam_role.tf_plan_role[0].name
  policy_arn = element(var.custom_tf_plan_role_policy_arns, count.index)
}

#### TF-APPLY-IAM-POLICIES ####

data "aws_iam_policy_document" "tf_apply_permissions" {
    count = var.tf_apply_allowed_resources != null && var.tf_apply_allowed_actions != null || var.tf_apply_role_statements != null ? 1 : 0
    dynamic "statement" {
        for_each = var.tf_apply_allowed_resources != [] && var.tf_apply_allowed_actions != [] ? {} : null
        content {
            effect = "Allow"
            resources = var.tf_apply_allowed_resources
            actions = var.tf_apply_allowed_actions
        }
    }
    dynamic "statement" {
        for_each = var.tf_apply_role_statements != [] ? {for statement in var.tf_apply_role_statements: statement.effect => statement} : {}
        content {
            effect = statement.value.effect
            resources = statement.value.resources
            actions = statement.value.actions
            dynamic "condition" {
                for_each = can(statement.value.condition) ? {for condition in statement.value.condition: condition.test => condition} : {}
                content {
                    test = statement.value.condition.test
                    variable = statement.value.condition.variable
                    values = statement.value.condition.values
                }
            }
            
        }
    }
}

resource "aws_iam_policy" "tf_apply_permissions" {
    count = var.tf_apply_allowed_resources != null && var.tf_apply_allowed_actions != null || var.tf_apply_role_statements != null ? 1 : 0
    name = var.tf_apply_policy_name
    description = var.tf_apply_policy_description
    path = var.tf_apply_policy_path
    policy = data.aws_iam_policy_document.tf_apply_permissions[0].json
}

resource "aws_iam_role_policy_attachment" "tf_apply_permissions" {
  count = var.tf_apply_allowed_resources != null && var.tf_apply_allowed_actions != null || var.tf_apply_role_statements != null ? 1 : 0

  role       = aws_iam_role.tf_apply_role[0].name
  policy_arn = aws_iam_policy.tf_apply_permissions[0].arn
}

resource "aws_iam_role_policy_attachment" "custom_tf_apply_permissions" {
  count = length(var.tf_apply_role_cross_account_arns) > 0 && length(var.custom_tf_apply_role_policy_arns) > 0 ? length(var.custom_tf_apply_role_policy_arns) : 0

  role       = aws_iam_role.tf_apply_role[0].name
  policy_arn = element(var.custom_tf_apply_role_policy_arns, count.index)
}
